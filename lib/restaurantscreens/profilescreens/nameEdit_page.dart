import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:dubz_creator/reusable_widgets/reusable_widget.dart';

class NameEditPage extends StatefulWidget {
  const NameEditPage({Key? key}) : super(key: key);

  @override
  State<NameEditPage> createState() => _NameEditPageState();
}

class _NameEditPageState extends State<NameEditPage> {
  TextEditingController _userNameTextController = TextEditingController();

  Future<void> updateUsername() async {
    String newName = _userNameTextController.text.trim();
    if (newName.isEmpty) {
      // Optionally, show an error message if the name field is empty
      return;
    }

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('restaurant') // or 'users' if you store in a users collection
            .doc(currentUser.uid)
            .update({'userName': newName});

        // Optionally, show a success message
      } catch (e) {
        // Handle errors here, e.g., show an error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Config.primaryColor,
        elevation: 0,
        title: const Text(
          "Edit Restaurant Name",
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
                reusableTextField("Enter New Name", Icons.person, false, _userNameTextController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: updateUsername,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: const Size(360, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
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



