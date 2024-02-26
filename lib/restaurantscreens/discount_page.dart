import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';

class DiscountPage extends StatefulWidget {
  const DiscountPage({Key? key}) : super(key: key);

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

enum FilterStatus { Upcoming, Completed, Cancel }

class _DiscountPageState extends State<DiscountPage> {
  FilterStatus status = FilterStatus.Upcoming;
  Alignment _alignment = Alignment.centerLeft;

  List<dynamic> schedules = [
    {
      "discount_name":"Dubz #1",
      //"restaurant_profile": "insert logo",
      "category":"Bar/Restaurant",
      "status": FilterStatus.Upcoming,
    },
    {
      "discount_name":"Dubz #2",
      //"restaurant_profile": "insert logo",
      "category":"Bar/Restaurant",
      "status": FilterStatus.Completed,
    },
    {
      "discount_name":"Dubz #3",
      //"restaurant_profile": "insert logo",
      "category":"Bar/Restaurant",
      "status": FilterStatus.Cancel,
    },    
  ];

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredSchedules = schedules.where((var schedule) {
      return schedule['status'] == status;
    }).toList();

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
                fontSize: 18,
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
                                if (filterStatus == FilterStatus.Upcoming) {
                                  status = FilterStatus.Upcoming;
                                  _alignment = Alignment.centerLeft;
                                } else if(filterStatus == FilterStatus.Completed) {
                                  status = FilterStatus.Completed;
                                  _alignment = Alignment.center;                                  
                                } else if(filterStatus == FilterStatus.Cancel) {
                                  status = FilterStatus.Cancel;
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
                /** 
                AnimatedAlign(
                  alignment: _alignment,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Config.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Center(
                      child: Text(
                        status.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                */
              ],
            ),
            Config.spaceSmall,
            Expanded(
              child: ListView.builder(
                itemCount: filteredSchedules.length,
                itemBuilder: ((context, index) {
                  var _schedule = filteredSchedules[index];
                  bool isLastElement = filteredSchedules.length + 1 == index;
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: !isLastElement
                      ? const EdgeInsets.only(bottom: 20)
                      : EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column (
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row (
                            children: [
                              //CircleAvatar(
                              //  backgroundImage:
                                  //insertImage file for restaurant
                              //),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _schedule['discount_name'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _schedule['category'],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],  
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const ScheduleCard(),  
                          const SizedBox(
                            height: 5,
                          ),      
                          Row (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Cancel',
                                    style: 
                                      TextStyle(color: Config.primaryColor),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Config.primaryColor,
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Reschedule',
                                    style: 
                                      TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),                  
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
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
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[
          Icon(
            Icons.calendar_today,
            color: Config.primaryColor,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Wednesday, 2/14/2024",
            style: const TextStyle(color: Config.primaryColor),
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.access_alarm,
            color: Config.primaryColor,
            size: 17,
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              "2:00 PM", 
              style: TextStyle(color: Config.primaryColor),
          ))
        ],
      ),
    );
  }
}