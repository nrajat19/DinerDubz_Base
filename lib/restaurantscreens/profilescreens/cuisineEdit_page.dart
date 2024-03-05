import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubz_creator/utils/config.dart';

class CuisineEditPage extends StatefulWidget {
  const CuisineEditPage({Key? key}) : super(key: key);

  @override
  State<CuisineEditPage> createState() => _CuisineEditPageState();
}

class _CuisineEditPageState extends State<CuisineEditPage> {
  final List<String> cuisineTypes = ['Italian', 'American', 'Indian', 'Chinese', 'Mediterranean', 'Mexican'];
  Map<String, bool> selectedCuisines = {};

  @override
  void initState() {
    super.initState();
    for (var cuisine in cuisineTypes) {
      selectedCuisines[cuisine] = false;
    }
  }

  Future<void> updateCuisines() async {
    List<String> selectedCuisineList = selectedCuisines.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('restaurant') // Adjust if using a different collection
            .doc(currentUser.uid)
            .update({'cuisineType': selectedCuisineList});

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cuisine types updated successfully")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating cuisines: $e")));
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
          "Edit Restaurant Cuisines",
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
                Container(
                  width: Config.widthSize * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Select Cuisine Type",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      ...cuisineTypes.map(
                        (cuisine) => CheckboxListTile(
                          title: Text(
                            cuisine,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          value: selectedCuisines[cuisine],
                          onChanged: (bool? value) {
                            setState(() {
                              selectedCuisines[cuisine] = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: updateCuisines,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white
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



