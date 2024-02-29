import 'package:dubz_creator/components/dubz_card.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:dubz_creator/loginscreen/signin_screen.dart';
import 'package:dubz_creator/restaurantscreens/dubzverify_page.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> dubzCat = [
    {
      //"icon": //insert icon
      "category": "General",
    },
    {
      //"icon": ,//insert icon
      "category": "Drop Discount",
    },
    {
      //"icon": //insert icon
      "category": "Loyalty: Coming Soon",
    },
  ];

  List<String> chartTabs = ['Line Chart', 'Pie Chart', 'Bar Chart'];

  int _currentIndex = 0;
  late Timer _timer;
  String? userName;

  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('restaurant')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['userName']; // Assuming 'userName' is the field in Firestore
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
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % 3;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget analyticsDisplay() {
    switch (_currentIndex) {
      case 0:
        return PlotLineGraph();
      case 1:
        return PlotPieGraph();
      case 2: 
        return PlotBarGraph();
      default:
        return Container();
    }
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      userName ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                
                Center (
                  child: SizedBox (
                    width: Config.widthSize * 0.5,
                    height: Config.heightSize * 0.25,
                    child: analyticsDisplay(),
                  ),
                ),

                Config.spaceBig,

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 240, 99, 5),
                    ),
                    child: const Text(
                      'Verify Customer',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => DubzVerifyPage()),
                      );                  
                    },
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
