import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:dubz_creator/reusable_widgets/reusable_widget.dart';


class NumberEditPage extends StatefulWidget {
  const NumberEditPage({Key? key}) : super(key: key);

  @override
  State<NumberEditPage> createState() => _NumberEditPageState();
}

class _NumberEditPageState extends State<NumberEditPage> {
  TextEditingController _numberTextController = TextEditingController();

  void updatePhoneNumber() async {
    String newPhoneNumber = _numberTextController.text.trim();
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('restaurant')
            .doc(currentUser.uid)
            .update({'phoneNumber': newPhoneNumber});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Phone number updated successfully"))
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating phone number: $e"))
        );
      }
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
          "Edit Phone Contact",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
                reusableTextField("Enter Phone Number (XXX-XXX-XXXX)", Icons.phone, false, _numberTextController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: updatePhoneNumber,
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


