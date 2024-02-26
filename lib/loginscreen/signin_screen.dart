import 'package:flutter/material.dart';
import 'package:dubz_creator/loginscreen/home_screen.dart';
import 'package:dubz_creator/loginscreen/signup_screen.dart';
import 'package:dubz_creator/loginscreen/reset_password.dart';
import 'package:dubz_creator/reusable_widgets/reusable_widget.dart';
import 'package:dubz_creator/utils/color_utils.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Config.primaryColor,    
      ),
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).size.height * 0.2, 20, 0),
        child: Column(children: <Widget>[
          logoWidget("assets/dinerdubz.png"),
          const SizedBox(
            height: 30,
          ),
          reusableTextField("Enter UserName", Icons.person_outline, false,
              _emailTextController),
          const SizedBox(
            height: 20,
          ),
          reusableTextField("Enter Password", Icons.lock_outline, true,
              _passwordTextController),
          const SizedBox(
            height: 20,
          ),

          forgetPassword(context),

          firebaseUIButton(context, "Sign In", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
          signUpOption()
        ]),
      )),
    ));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 35,
        alignment: Alignment.bottomRight,
        child: TextButton(
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.right,
          ),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ResetPassword())),
        ),
      );
    }  
}
