import 'package:dubz_creator/components/button_widget.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:dubz_creator/loginscreen/signin_screen.dart';
import 'package:dubz_creator/restaurantscreens/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  var index = -1;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  bool verifiedController = false;
  DateTime? startDate;
  DateTime? endDate;
  final GlobalKey<_DatetimePickerWidgetState> startPickerKey = GlobalKey();
  final GlobalKey<_DatetimePickerWidgetState> endPickerKey = GlobalKey();
  String? userName;

  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('restaurant')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['userName']; // Assuming 'userName' is the field in Firestore
          });
        }
      } catch (e) {
        // Handle errors here
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }
  
  String generateUniqueId() {
      Random random = Random();
      int number = random.nextInt(900000) + 100000; // This will generate a random number between 100000 and 999999
      return number.toString();
  }
  void displayError(String errorMessage) {
    // Display error message to the user (e.g., show a snackbar)
    final snackBar = SnackBar(content: Text(errorMessage));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handleSubmit() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DateTime initDate = DateTime.now();
    
    if (endDate != null && endDate!.isBefore(startDate!)) {
      // Show an error message if the end date is earlier than the start date
      displayError("End date cannot be earlier than start date");
      return;
    }

    int quantity = int.tryParse(quantityController.text) ?? 0;
    for (int i = 0; i < quantity; i++) {
      // Generate a unique ID for each document
      String uniqueId = generateUniqueId();
      // Prepare data for Firestore
      Map<String, dynamic> discountSetData = {
        'description': descriptionController.text,
        'type': index,
        'startDate': startDate,
        'endDate': endDate,
        'quantity' : quantityController.text, 
      };

      Map<String, dynamic> discountData = {
        'uniqueId': uniqueId,
        'verified': verifiedController,
      };

      await firestore.collection('restaurant')
                     .doc(userId)
                     .collection('discount_groups')
                     .doc(descriptionController.text) // Using uniqueId as document ID
                     .set(discountSetData)
                     .then((value) => print("Discount Set Added"))
                     .catchError((error) => print("Failed to add discount: $error"));

      // Create a new document for each discount
      await firestore.collection('restaurant')
                     .doc(userId)
                     .collection('discount_groups')
                     .doc(descriptionController.text) // Using uniqueId as document ID
                     .collection("discounts")
                     .doc(uniqueId)
                     .set(discountData)
                     .then((value) => print("Discount IDs Added"))
                     .catchError((error) => print("Failed to add discount: $error"));
    }

    // Clear fields after submission
    descriptionController.clear();
    quantityController.clear();
    startPickerKey.currentState?.resetDateTime();
    endPickerKey.currentState?.resetDateTime();
    
    setState(() {
      index = -1;
      startDate = initDate;
      endDate = initDate;
    });
  }


  void handleStartDateChanged(DateTime selectedDate) {
    setState(() {
      startDate = selectedDate;
    });
  }

  // Function to update the end date
  void handleEndDateChanged(DateTime selectedDate) {
    setState(() {
      endDate = selectedDate;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.person_outline),
                      onPressed: () {
                        // Navigate to another page when the person_outline button is pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                    ),
                    Text(
                      userName ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Config.primaryColor,
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()),
                      );                  
                    },
                  ),

                  ],
                ),
                Config.spaceMedium,

                const Text(
                  "Fill out Form to Upload Discount for Customers",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SizedBox(
                    height: 60,
                    width: Config.widthSize * 0.6,
                    child: TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          labelText:
                              "Dubz Title/Description"), // Only numbers can be entered
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 60,
                    width: Config.widthSize * 0.6,
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: index == -1 ? null : index,
                      hint: const Text('Select Dubz Type'),
                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text('Promotion'),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text('Discount'),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text('Price Drop'),
                        ),
                        DropdownMenuItem(
                          value: 4,
                          child: Text('Loyalty (Coming Soon)'),
                        ),
                      ],
                      onChanged: (int? value) {
                        setState(() {
                          index = value ?? -1;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Start",
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(
                      width: Config.widthSize * 0.25,
                    ),
                    const Text(
                      "End",
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DatetimePickerWidget(
                        key: startPickerKey,
                        onDateTimeChanged: handleStartDateChanged,
                      ),
                      const SizedBox(width: 20),
                      DatetimePickerWidget(
                        key: endPickerKey,
                        onDateTimeChanged: handleEndDateChanged,
                      ),
                    ],
                ),

                Padding(
                  padding: const EdgeInsets.all(50),
                  child: SizedBox(
                    height: 60,
                    width: Config.widthSize * 0.6,
                    child: TextField(
                      controller: quantityController,
                      decoration:
                          const InputDecoration(labelText: "Enter Dubz Quantity"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                  ),
                ),

                Config.spaceBig,

                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Config.primaryColor,
                    ),
                    onPressed: handleSubmit,
                    child: const Text(
                      'Submit Dubz',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),                    
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DatetimePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateTimeChanged;
  final GlobalKey<_DatetimePickerWidgetState> key;

  const DatetimePickerWidget({
    required this.onDateTimeChanged,
    required this.key,
  }) : super(key: key);

  @override
  _DatetimePickerWidgetState createState() => _DatetimePickerWidgetState();
}


class _DatetimePickerWidgetState extends State<DatetimePickerWidget> {
  late DateTime dateTime;
  DateTime initDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    dateTime = initDate; // Initialize date in initState
  }

  void resetDateTime() {
    setState(() {
      dateTime = initDate;
    });
  }

  String getText() {
    if (dateTime == initDate) {
      return 'Select DateTime';
    } else {
      return DateFormat('MM/dd/yyyy HH:mm').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) => ButtonWidget(
        text: getText(),
        onClicked: () => pickDateTime(context),
      );

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      widget.onDateTimeChanged(dateTime);
    });
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: dateTime != initDate
          ? TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    return newTime;
  }
}
