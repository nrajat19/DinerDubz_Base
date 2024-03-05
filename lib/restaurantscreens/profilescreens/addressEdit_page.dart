import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:dubz_creator/reusable_widgets/reusable_widget.dart';


class AddressEditPage extends StatefulWidget {
  const AddressEditPage({Key? key}) : super(key: key);

  @override
  State<AddressEditPage> createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
  TextEditingController _streetTextController = TextEditingController();
  TextEditingController _cityTextController = TextEditingController();
  TextEditingController _stateTextController = TextEditingController();
  TextEditingController _zipTextController = TextEditingController();

  Future<void> updateAddress() async {
    String street = _streetTextController.text.trim();
    String city = _cityTextController.text.trim();
    String state = _stateTextController.text.trim();
    String zip = _zipTextController.text.trim();

    String fullAddress = '$street, $city, $state, $zip';

    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && fullAddress.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('restaurant') // Adjust if using a different collection
            .doc(currentUser.uid)
            .update({'address': fullAddress});

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Address updated successfully")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating address: $e")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields")));
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
          "Edit Restaurant Address",
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
                reusableTextField("Enter Street Address", Icons.streetview, false, _streetTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter City", Icons.location_city, false, _cityTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter State", Icons.map, false, _stateTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter Zip-Code", Icons.local_post_office, false, _zipTextController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: updateAddress,
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



