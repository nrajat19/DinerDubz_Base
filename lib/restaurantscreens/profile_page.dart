import 'package:dubz_creator/components/dubz_card.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:dubz_creator/utils/main_layout.dart';
import 'package:dubz_creator/loginscreen/signin_screen.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubz_creator/reusable_widgets/reusable_widget.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:dubz_creator/restaurantscreens/profilescreens/nameEdit_page.dart';
import 'package:dubz_creator/restaurantscreens/profilescreens/passEdit_page.dart';
import 'package:dubz_creator/restaurantscreens/profilescreens/addressEdit_page.dart';
import 'package:dubz_creator/restaurantscreens/profilescreens/numberEdit_page.dart';
import 'package:dubz_creator/restaurantscreens/profilescreens/cuisineEdit_page.dart';
import 'package:dubz_creator/restaurantscreens/profilescreens/imageEdit_page.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Customize Profile",
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
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => NameEditPage()),
                      );  
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      child: Text(
                        'Restaurant Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      fixedSize: const Size(360, 60),
                      shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Set to zero for square corners
                      
    ),
                    ),
                  ),

                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => PassEditPage()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      fixedSize: const Size(360, 60),
                      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Set to zero for square corners
    ),
                    ),
                  ),

                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => AddressEditPage()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      child: Text(
                        'Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      fixedSize: const Size(360, 60),
                      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Set to zero for square corners
    ),
                    ),
                  ),

                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => NumberEditPage()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      child: Text(
                        'Phone Number',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      fixedSize: const Size(360, 60),
                      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Set to zero for square corners
    ),
                    ),
                  ),

                const SizedBox(
                  height: 20,
                ),

                // Button to upload image
                ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CuisineEditPage()),
                      );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        child: Text(
                          'Cuisine Type',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        fixedSize: const Size(360, 60),
                        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Set to zero for square corners
    ),
                      ),
                    ),

                const SizedBox(
                  height: 20,
                ),

                // Button to upload image
                ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ImageEditPage()),
                      );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        child: Text(
                          'Display Image',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.3),
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

