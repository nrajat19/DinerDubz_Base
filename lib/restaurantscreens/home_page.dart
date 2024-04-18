import 'package:dubz_creator/components/dubz_card.dart';
import 'package:dubz_creator/restaurantscreens/profile_page.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:dubz_creator/loginscreen/signin_screen.dart';
import 'package:dubz_creator/restaurantscreens/dubzverify_page.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubz_creator/restaurantscreens/profilescreens/nameEdit_page.dart';
import 'package:dubz_creator/restaurantscreens/profilescreens/passEdit_page.dart';
import 'package:dubz_creator/restaurantscreens/profilescreens/addressEdit_page.dart';
import 'package:dubz_creator/restaurantscreens/profilescreens/numberEdit_page.dart';
import 'package:dubz_creator/restaurantscreens/profilescreens/cuisineEdit_page.dart';
import 'package:dubz_creator/restaurantscreens/profilescreens/imageEdit_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  double progress = 0.0;
  Map<String, bool> fieldStatus = {
    'email': false,
    'userName': false,
    'address': false,
    'phoneNumber': false,
    'cuisineType': false,
    'displayImage': false
  };

  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('restaurant')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            userName = data['userName'];
            fieldStatus.forEach((key, _) {
              fieldStatus[key] = data[key] != null && data[key].isNotEmpty;
            });
          });
        }


      } catch (e) {
        // Handle errors here
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Widget buildSegmentedProgressBar() {
    List<Widget> segments = [];
    fieldStatus.forEach((key, value) {
      Widget segment = Expanded(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                // Navigate to different profile pages based on the key
                switch (key) {
                  case 'email':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NameEditPage()),
                    );
                    break;
                  case 'userName':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NameEditPage()),
                    );
                    break;
                  case 'address':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddressEditPage()),
                    );
                    break;
                  case 'phoneNumber':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NumberEditPage()),
                    );
                    break;  
                  case 'cuisineType':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CuisineEditPage()),
                    );
                    break;
                  case 'displayImage':
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImageEditPage()),
                    );
                    break;
                  // Add cases for other keys here
                }
              },
              child: Container(
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: value ? Config.primaryColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: 5), // Spacing between bar and label
            Text(
              key, // Field name as label
              style: TextStyle(
                fontSize: 12,
                color: value ? Colors.black : Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );

      segments.add(segment);
    });

    return Row(children: segments);
  }


  GestureDetector buildItem(
     String title, String subTitle, String url, double rating) {
   return GestureDetector(
     onTap: () {
       //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DetailPage(url)));
     },
     child: Container(
       margin: EdgeInsets.symmetric(vertical: 12.0),
       padding: EdgeInsets.symmetric(horizontal: 25.0),
       child: Column(
         children: <Widget>[
           Hero(
             tag: url,
             child: Container(
               height: 200,
               decoration: BoxDecoration(
                   image: DecorationImage(
                     image: NetworkImage(url),
                     fit: BoxFit.cover,
                   ),
                   borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(10.0),
                     topRight: Radius.circular(10.0),
                   )),
             ),
           ),
           Container(
             padding: EdgeInsets.all(25.0),
             decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.only(
                     bottomLeft: Radius.circular(10.0),
                     bottomRight: Radius.circular(10.0)),
                 boxShadow: [
                   BoxShadow(
                       blurRadius: 2.0, spreadRadius: 1.0, color: Colors.grey)
                 ]),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     Text(
                       title,
                       style: TextStyle(
                           fontWeight: FontWeight.bold, fontSize: 16.0),
                     ),
                     Text(
                       subTitle,
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 12.0,
                           color: Colors.grey),
                     ),
                   ],
                 ), 
               ],
             ),
           ),
         ],
       ),
     ),
   );
 }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchRestaurantData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('restaurant').doc(userId).get();
  }

  Widget buildRestaurantCard(Map<String, dynamic> data) {
    String imageUrl = data['displayImage'] ?? '';
    String title = data['userName'] ?? 'Restaurant Name';
    String subTitle = data['cuisineType'].join(', ') ?? 'Cuisine Type';

    return buildItem(title, subTitle, imageUrl, 4.5); // Example rating
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.person_outline),
                      onPressed: () {
                        // Navigate to another page when the person_outline button is pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                    ),
                    Text(
                      userName ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Config.primaryColor,
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()),
                      );                  
                    },
                  ),

                  ],
                ),
                Config.spaceMedium,

                const Center(
                  child: Text(
                    'Welcome to Diner Dubz: Restaurant Side!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Config.spaceSmall,

                Center(
                  child: SizedBox(
                    width: Config.widthSize * 0.75,
                    height: Config.heightSize * 0.25,
                    child: Image.asset('assets/dinerdubz.png'),
                  ),
                ),

                Config.spaceBig,

                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: fetchRestaurantData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Text("Restaurant data not found");
                    }

                    Map<String, dynamic> restaurantData = snapshot.data!.data()!;

                    // Check if setup is complete
                    if (restaurantData.values.every((v) => v != null && v.toString().isNotEmpty)) {
                      return buildRestaurantCard(restaurantData);
                    } else {
                      return buildSegmentedProgressBar();
                    }
                  },
                ),

                Config.spaceBig,
                Config.spaceBig,

                Center(
                  child: SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Verify Dubz',
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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => DubzVerifyPage()),
                        );
                      }
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
