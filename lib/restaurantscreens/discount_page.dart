import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiscountPage extends StatefulWidget {
  const DiscountPage({Key? key}) : super(key: key);

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

enum FilterStatus { Current, Upcoming, Closed }

class _DiscountPageState extends State<DiscountPage> {
  FilterStatus status = FilterStatus.Upcoming;
  Alignment _alignment = Alignment.centerLeft;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left:20, top: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            Text(
              "Discount Schedule",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.spaceSmall,
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (filterStatus == FilterStatus.Current) {
                                  status = FilterStatus.Current;
                                  _alignment = Alignment.centerLeft;
                                } else if(filterStatus == FilterStatus.Upcoming) {
                                  status = FilterStatus.Upcoming;
                                  _alignment = Alignment.center;                                  
                                } else if(filterStatus == FilterStatus.Closed) {
                                  status = FilterStatus.Closed;
                                  _alignment = Alignment.centerRight;                                  
                                }
                              });
                            },
                            child: Center(
                              child: Text(filterStatus.name),
                            ),

                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Config.spaceBig,

            ScheduleCard(),
          
          ],
        ),
      ),
    );
  }
}
 
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      width: Config.widthSize * 0.5,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              SizedBox(
                width: 100,
                child: Text(
                "Dubz Details:",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              ),
            ],
          ),
          
          SizedBox(
            height: 15,
          ),

          Row(
            children: <Widget>[
              SizedBox(
                width: 100,
                child: Text(
                "Dubz Type:",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              ),
            ],
          ),
          
          SizedBox(
            height: 15,
          ),

          Row(
            children: <Widget>[
              SizedBox(
                width: 100,
                child: Text(
                "From:",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              ),

              Icon(
                Icons.calendar_today,
                color: Config.primaryColor,
                size: 15,
              ),
              Icon(
                Icons.access_alarm,
                color: Config.primaryColor,
                size: 15,
              ),
              
              SizedBox(
                width: 25,
              ),

              Text(
                "Wednesday, 2/14/2024",
                style: const TextStyle(color: Config.primaryColor),
              ),

            ],
          ),
          
          SizedBox(
            height: 15,
          ),

          Row(
            children: <Widget>[
              SizedBox(
                width: 100,
                child: Text(
                "To:",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),

              Icon(
                Icons.calendar_today,
                color: Config.primaryColor,
                size: 15,
              ),
              Icon(
                Icons.access_alarm,
                color: Config.primaryColor,
                size: 15,
              ),

              SizedBox(
                width: 25,
              ),
              Text(
                "Wednesday, 2/14/2024",
                style: const TextStyle(color: Config.primaryColor),
              ),

            ],
          ),

          SizedBox(
            height: 15,
          ),

          Row(
            children: <Widget>[
              SizedBox(
                width: 100,
                child: Text(
                "Dubz Qty:",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              ),
            ],
          ),          
        ],
      ),
    );
  }
  
}
