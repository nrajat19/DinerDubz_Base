import 'package:dubz_creator/utils/main_layout.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DubzVerifyPage extends StatefulWidget {
  const DubzVerifyPage({Key? key}) : super(key: key);

  @override
  State<DubzVerifyPage> createState() => _DubzVerifyPageState();
}

class _DubzVerifyPageState extends State<DubzVerifyPage> {
  String otpCode = '';
  String? selectedCouponDescription;
  List<Map<String, dynamic>> currentCoupons = [];
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCurrentCoupons().then((coupons) {
      setState(() {
        currentCoupons = coupons;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MainLayout()),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 1,
                vertical: 1,
              ),
              child: Text(
                '< Back',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
          ),          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "Verify Customer Dubz Code",
                    style: TextStyle(
                      color: Config.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                Config.spaceSmall,

                SizedBox(
                  width: Config.widthSize * 0.5,
                  height: 50,
                  child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select Current Dubz",
                    border: OutlineInputBorder(),
                  ),
                  value: selectedCouponDescription,
                  items: currentCoupons.map<DropdownMenuItem<String>>((coupon) {
                    return DropdownMenuItem<String>(
                      value: coupon['description'],
                      child: Text(coupon['description']),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCouponDescription = newValue;
                    });
                  },
                ),
                ),

                Config.spaceBig,

                const Center(
                  child: Text(
                    "Please Enter 6-Digit Dubz Code From Customer Side",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Config.spaceMedium,
                
                SizedBox(
                  width: Config.widthSize * 0.5,
                  
                  child: PinCodeTextField(
                  appContext: context, 
                  length: 6, 
                  controller: pinController,
                  onChanged: (value) {
                    setState(() {
                      otpCode = value;
                    });
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 50,
                    fieldWidth: 60,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: Config.primaryColor,
                    inactiveColor: Colors.grey[400],
                    selectedColor: Config.primaryColor,

                  ),

                  keyboardType: TextInputType.number,
                  autoFocus: true,
                  cursorColor: Config.primaryColor,
                  animationType: AnimationType.fade,
                  animationDuration: Duration(milliseconds: 100),
                  enableActiveFill: true,
                ),
                ),
                

                Config.spaceSmall,
                
                Center (
                  child: ElevatedButton(
                    onPressed: verifyCoupon,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Config.primaryColor,
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

  Future<List<Map<String, dynamic>>> fetchCurrentCoupons() async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  var discountsCollection = FirebaseFirestore.instance.collection('restaurant')
      .doc(userId).collection('discount_groups');

  QuerySnapshot querySnapshot = await discountsCollection.get();
  DateTime now = DateTime.now();
  List<Map<String, dynamic>> currentCoupons = [];

  for (var doc in querySnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    DateTime startDate = data['startDate'].toDate();
    DateTime endDate = data['endDate'].toDate();

    // Fetch coupons to count used and remaining
    QuerySnapshot couponsSnapshot = await doc.reference.collection('discounts').get();
    int totalCoupons = couponsSnapshot.docs.length;
    int usedCoupons = couponsSnapshot.docs.where((coupon) => coupon['verified']).length;

    data['totalCoupons'] = totalCoupons;
    data['usedCoupons'] = usedCoupons;

    if (now.isAfter(startDate) && now.isBefore(endDate) && usedCoupons < totalCoupons) {
      currentCoupons.add(data);
    }
  }
  return currentCoupons;
}


void verifyCoupon() async {
  if (selectedCouponDescription == null || otpCode.isEmpty) {
    // Show an error message if the description or code is not entered
    dbResponse("Please select a coupon and enter the code");
    return;
  }

  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var couponsQuery = FirebaseFirestore.instance
        .collection('restaurant')
        .doc(userId)
        .collection('discount_groups')
        .doc(selectedCouponDescription)
        .collection('discounts')
        .where('uniqueId', isEqualTo: otpCode)
        .get();

    var coupons = await couponsQuery;

    if (coupons.docs.isEmpty || coupons.docs.first.data()['verified']) {
      // Coupon code is invalid or already used
      dbResponse("Invalid or Coupon Code Already Used");
    } else {
      // Coupon code is valid, update the 'verified' field to true
      await coupons.docs.first.reference.update({'verified': true});
      dbResponse("Coupon Verified Successfully");

      setState(() {
        otpCode = '';
        selectedCouponDescription = null;
        pinController.clear();
      });

      fetchCurrentCoupons();
    }
  } catch (e) {
    dbResponse("Error verifying coupon: ${e.toString()}");
  }
}

void dbResponse(String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

}