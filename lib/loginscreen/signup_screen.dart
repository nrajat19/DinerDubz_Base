import 'package:flutter/material.dart';
import 'package:dubz_creator/loginscreen/home_screen.dart';
import 'package:dubz_creator/reusable_widgets/reusable_widget.dart';
import 'package:dubz_creator/utils/color_utils.dart';
import 'package:dubz_creator/utils/main_layout.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);


  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}


class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  bool isRestaurant = false; // false for Customer, true for Restaurant
  String _errorMessage = '';
  late RegExp passwordRegExp;
  double _strength = 0;
  String _strengthLabel = '';
  Color _labelColor = Colors.white; // Default color


  @override
  void initState() {
    super.initState();
    passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    _passwordTextController.addListener(updatePasswordStrength);
  }


  void updatePasswordStrength() {
    String password = _passwordTextController.text;
    int metRequirements = 0;
    // Check each requirement
    if (password.isEmpty) {
      _strengthLabel = 'Password cannot be left blank';
      _labelColor = Colors.red;
      _strength = 0;
    } else {
      if (password.length >= 8) metRequirements++;
      if (RegExp(r'.*[A-Z].*').hasMatch(password)) metRequirements++;
      if (RegExp(r'.*[a-z].*').hasMatch(password)) metRequirements++;
      if (RegExp(r'.*[0-9].*').hasMatch(password)) metRequirements++;
      if (RegExp(r'.*[!@#\$&*~].*').hasMatch(password)) metRequirements++;
      
      if (metRequirements == 5) {
        _strengthLabel = 'Password is strong';
        _labelColor = Colors.green;
      } else if (metRequirements >= 3) {
        _strengthLabel = 'Password is medium';
        _labelColor = Colors.orange;
      } else {
        _strengthLabel = 'Password is weak';
        _labelColor = Colors.red;
      }
      _strength = metRequirements / 5.0;
    }


    setState(() {
      if (_strength != 1) {
        _errorMessage = 'Password strength must be strong to proceed.';
      } else {
        _errorMessage = '';
      }
    });
  }


  void showPasswordRequirementsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password Requirements'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Minimum 8 characters'),
                Text('At least one uppercase letter (A-Z)'),
                Text('At least one lowercase letter (a-z)'),
                Text('At least one digit (0-9)'),
                Text('At least one special character (!@#\$&*~)'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Sign Up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Config.primaryColor),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                buildToggleSwitch(),
                const SizedBox(height: 20),
                reusableTextField("Enter UserName", Icons.person_outline, false, _userNameTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter Email Id", Icons.mail_outline, false, _emailTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5, // 50% of screen width
                    child: LinearProgressIndicator(
                      value: _strength,
                      backgroundColor: Colors.grey,
                      color: _strength < 0.5 ? Colors.red : _strength < 1 ? Colors.orange : Colors.green,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_strengthLabel, style: TextStyle(color: _labelColor)),
                      IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.white),
                        onPressed: () => showPasswordRequirementsDialog(context),
                      ),
                    ],
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
                  ),
                firebaseUIButton(context, "Sign Up", signUp),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void signUp() async {
    if (_strength < 1) {
      setState(() {
        _errorMessage = "Complete all password strength requirements to sign up.";
      });
      return;
    }


    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text
      );


      // Get the UID of the newly created user
      String uid = userCredential.user!.uid;


      // Determine the collection based on user type
      String collectionName = isRestaurant ? 'restaurant' : 'diner';


      // Store additional user details in Firestore
      await FirebaseFirestore.instance.collection(collectionName).doc(uid).set({
        'userName': _userNameTextController.text,
        'email': _emailTextController.text,
        'address': '',
        'phoneNumber': '',
        'cuisineType': '',
        'displayImage': '', // Add other fields as needed
      });


      // Navigate to different screens based on user type
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isRestaurant ? MainLayout() : HomeScreen()
        )
      );


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign up successful"))
      );
    } on FirebaseAuthException catch (e) {
      String errorText = "An error occurred during sign up";
      if (e.code == 'email-already-in-use') {
        errorText = "Email already registered";
      }
      setState(() {
        _errorMessage = errorText;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage))
      );
    } catch (e) {
      setState(() {
        _errorMessage = "An unexpected error occurred";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage))
      );
    }
  }



  Widget buildToggleSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isRestaurant = false;
            });
          },
          child: Text(
            "Diner",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isRestaurant ? Colors.grey : Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          "|",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              isRestaurant = true;
            });
          },
          child: Text(
            "Restaurant",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isRestaurant ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}






