import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubz_creator/reusable_widgets/reusable_widget.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:convert';


class NumberEditPage extends StatefulWidget {
  const NumberEditPage({Key? key}) : super(key: key);

  @override
  State<NumberEditPage> createState() => _NumberEditPageState();
}


class _NumberEditPageState extends State<NumberEditPage> {
  TextEditingController _numberTextController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Edit Phone Contact",
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
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SizedBox(
                    height: 60,
                    width: Config.widthSize * 0.6,
                    child: TextField(
                      controller: _numberTextController,
                      decoration: const InputDecoration(
                        labelText:
                              "Enter Phone Number (XXX-XXX-XXXX)"), // Only numbers can be entered
                    ),
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




