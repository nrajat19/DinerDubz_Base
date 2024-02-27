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
                /** 
                Config.spaceSmall, 
                SizedBox(
                  height: Config.heightSize * 0.05,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(dubzCat.length, (index) {
                      return Card(
                        margin: const EdgeInsets.only(right: 20),
                        color: Config.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal:15, vertical: 10),
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              //Insert Icon Stuff
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                dubzCat[index]['category'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Config.spaceSmall,
                */
                Config.spaceBig,
                
                Center (
                  child: SizedBox (
                    width: Config.widthSize * 0.5,
                    height: Config.heightSize * 0.25,
                    child: analyticsDisplay(),
                  ),
                ),

                Config.spaceBig,
                // const Button(
                // width: double.infinity,
                // title: "Upload Discount",
                // onPressed: () {},
                // ),
                /** 
                Column(
                  children: List.generate(10, (index) {
                    return const RestaurantCard();
                  }),
                ),  
                    */
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


/** 
class PerformancePie extends StatelessWidget{
  const PerformancePie({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ()
  }
}

class PerformanceBar extends StatelessWidget{
  const PerformanceBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ()
  }
}

  LineChart buildLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3),
              FlSpot(2.6, 2),
              FlSpot(4.9, 5),
              FlSpot(6.8, 2.5),
              FlSpot(8, 4),
              FlSpot(9.5, 3),
              FlSpot(11, 4),
            ],
            isCurved: true,
            dotData: FlDotData(show: true),
            color: Colors.blue,
            barWidth: 5,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.7),
            ),
          ),
        ],
        minX: 0,
        maxX: 11,
        minY: 2,
        maxY: 5,
        backgroundColor: Colors.black,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            axisNameWidget: const Text('Time'),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 3,
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: const Text('Total Sales'),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 3,
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.greenAccent,
            strokeWidth: 0.5,
          ),
          drawVerticalLine: true,
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.amberAccent,
            strokeWidth: 0.5,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.red,
            width: 5,
          ),
        ),
      ),
    );
  }

  PieChart buildPieChart() {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 5,
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        sections: [
          PieChartSectionData(
            value: 35, color: Colors.purple, radius: 100
          ),
          PieChartSectionData(
            value: 40, color: Colors.amber, radius: 100
          ),
          PieChartSectionData(
            value: 55, color: Colors.green, radius: 100
          ),
          PieChartSectionData(
            value: 70, color: Colors.blue, radius: 100
          ),          
        ],
      ),
    );      
  }

  BarChart buildBarChart() {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(
          border: const Border(
            top: BorderSide.none,
            right: BorderSide.none,
            left: BorderSide(width: 1),
            bottom: BorderSide(width: 1),
          ),
        ),
        groupsSpace: 10,
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                fromY: 0, toY: 10, width: 15, color: Colors.red, 
              ),                              
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                fromY: 0, toY: 14, width: 15, color: Colors.blue, 
              ),                              
            ],
          ),
          BarChartGroupData(
            x: 5,
            barRods: [
              BarChartRodData(
                fromY: 0, toY: 3, width: 15, color: Colors.purple, 
              ),                              
            ],
          ),
          BarChartGroupData(
            x: 8,
            barRods: [
              BarChartRodData(
                fromY: 0, toY: 5, width: 15, color: Colors.amber, 
              ),                              
            ],
          ),
        ],
      ),
    );
  }


*/