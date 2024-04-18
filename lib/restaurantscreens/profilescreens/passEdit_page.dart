import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:dubz_creator/reusable_widgets/reusable_widget.dart';

class PassEditPage extends StatefulWidget {
  const PassEditPage({Key? key}) : super(key: key);

  @override
  State<PassEditPage> createState() => _PassEditPageState();
}

class _PassEditPageState extends State<PassEditPage> {
  TextEditingController _oldPassTextController = TextEditingController();
  TextEditingController _newPassTextController = TextEditingController();
  TextEditingController _confirmPassTextController = TextEditingController();

  late RegExp passwordRegExp;

  @override
  void initState() {
    super.initState();
    // Password strength requirements: At least 8 characters, one uppercase letter, one lowercase letter, one digit, and one special character
    passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  }

  bool isPasswordValid(String password) {
    return passwordRegExp.hasMatch(password);
  }

  Future<void> updatePassword() async {
  String oldPassword = _oldPassTextController.text;
  String newPassword = _newPassTextController.text;
  String confirmPassword = _confirmPassTextController.text;

  if (newPassword != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New passwords do not match")));
    return;
  }


  // Validate password strength
  if (!isPasswordValid(newPassword)) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New password does not meet strength requirements")));
    return;
  }

  User? user = FirebaseAuth.instance.currentUser;
  String email = user!.email!;

  try {
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: oldPassword);
    await user.reauthenticateWithCredential(credential);

    await user.updatePassword(newPassword);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password updated successfully")));
  } on FirebaseAuthException catch (e) {
    if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incorrect old password")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating password: ${e.message}")));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Edit Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
                reusableTextField("Enter Old Password", Icons.lock, true, _oldPassTextController),
                const SizedBox(height: 10),
                //Display following strength requirements below
                //At least 8 characters
                //One uppercase
                //One lowercase
                //One digit
                //One special character
                reusableTextField("Enter New Password", Icons.lock_outline, true, _newPassTextController),
                const SizedBox(height: 10),
                reusableTextField("Confirm New Password", Icons.lock_outline, true, _confirmPassTextController),
                const SizedBox(height: 20),

                const Text("Password Requirements:" , style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 145, 144, 144)),),
                const Text("1 Uppercase Character", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 145, 144, 144)),),
                const Text("1 Lowercase Character", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 145, 144, 144)),),
                const Text("1 Numerical Character", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 145, 144, 144)),),
                const Text("1 Special Character", style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 145, 144, 144)),),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: updatePassword,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    child: Text(
                      'Confirm',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: const Size(360, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



