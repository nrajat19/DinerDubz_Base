import 'package:dubz_creator/loginscreen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:dubz_creator/utils/main_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Diner Side"),
          onPressed: () {
          },
        ),
      ),
    );
  }
}
