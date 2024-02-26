import 'package:flutter/material.dart';
import 'package:dubz_creator/loginscreen/home_screen.dart';
import 'package:dubz_creator/reusable_widgets/reusable_widget.dart';
import 'package:dubz_creator/utils/color_utils.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Config.primaryColor, 
          ),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.mail, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),

                firebaseUIButton(context, "Sign Up", () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text
                          
                          //approved: True/False
                          )
                      .then((value) {
                    // Get the UID of the newly created user
                    String uid = value.user!.uid;

                    // Store additional user details in Firestore
                    FirebaseFirestore.instance.collection('users').doc(uid).set({
                      'userName': _userNameTextController.text,
                      'email': _emailTextController.text,
                      // Add other fields as needed
                    }).then((_) {
                      print("User details added to Firestore");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    }).catchError((error) {
                      print("Error adding user details to Firestore: $error");
                    });

                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                })
              ],
            ),
          ))),
    );
  }
}
