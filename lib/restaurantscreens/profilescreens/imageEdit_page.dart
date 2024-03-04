import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubz_creator/reusable_widgets/reusable_widget.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:convert';


class ImageEditPage extends StatefulWidget {
  const ImageEditPage({Key? key}) : super(key: key);

  @override
  State<ImageEditPage> createState() => _ImageEditPageState();
}


class _ImageEditPageState extends State<ImageEditPage> {
  Uint8List? _restaurantImageData;


  Future<void> _pickImage() async {
  // Create an input element for file upload
  final html.FileUploadInputElement input = html.FileUploadInputElement()..accept = 'image/*';
  input.click();


  // Listen for file selection
  input.onChange.listen((event) {
    final file = input.files!.first;
    final reader = html.FileReader();


    // Convert the image file to a data URL and then to bytes
    reader.readAsDataUrl(file);
    reader.onLoadEnd.listen((event) {
      setState(() {
        final String base64String = reader.result as String;
        _restaurantImageData = base64.decode(base64String.split(',').last);
      });
    });
  });
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
                  child: 
                  // Button to upload image
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
                    onPressed: _pickImage,
                    child: Text(
                      "Upload Restaurant Image",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                                  // Display the selected image
                if (_restaurantImageData != null)
                  Container(
                    height: 200, // Adjust size as needed
                    width: double.infinity,
                    child: Image.memory(_restaurantImageData!, fit: BoxFit.cover),
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




