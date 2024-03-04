import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubz_creator/reusable_widgets/reusable_widget.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:convert';


class CuisineEditPage extends StatefulWidget {
  const CuisineEditPage({Key? key}) : super(key: key);

  @override
  State<CuisineEditPage> createState() => _CuisineEditPageState();
}


class _CuisineEditPageState extends State<CuisineEditPage> {
  final List<String> cuisineTypes = ['Italian', 'American', 'Indian', 'Chinese', 'Mediterranean'];


  // Map to keep track of selected cuisines
  Map<String, bool> selectedCuisines = {};

  @override
  void initState() {
    super.initState();
    // Initialize all cuisine types to false (not selected)
    for (var cuisine in cuisineTypes) {
      selectedCuisines[cuisine] = false;
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
            color: Colors.white,
          ),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                Container(  
                  width: Config.widthSize * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    children: [
                      Text(
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

                
                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                    onPressed: () {
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Config.primaryColor,
                      fixedSize: const Size(360, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Set to zero for square corners
                      ),
                    ),
                  ),
              ],
            ),
          ))),
    );
  }
}




