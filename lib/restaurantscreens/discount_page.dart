import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<List<Map<String, dynamic>>> fetchDiscounts() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var discountsCollection = FirebaseFirestore.instance.collection('restaurant')
        .doc(userId).collection('discount_groups');

    QuerySnapshot querySnapshot = await discountsCollection.get();
    List<Map<String, dynamic>> discounts = [];
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      discounts.add(data);
    }
    return discounts;
  }

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
            Config.spaceMedium,

            FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchDiscounts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No discounts found');
              }

              // Filter data based on the current status
              List<Map<String, dynamic>> filteredDiscounts = filterDiscounts(snapshot.data!);

              return Expanded(
                child: ListView.builder(
                  itemCount: filteredDiscounts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10), // Add space between cards
                      child: ScheduleCard(discountData: filteredDiscounts[index]),
                    );  
                  },
                ),
              );
            },
          ),

          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> filterDiscounts(List<Map<String, dynamic>> discounts) {
    DateTime now = DateTime.now();

    switch (status) {
      case FilterStatus.Current:
        return discounts.where((discount) {
          DateTime startDate = discount['startDate'].toDate();
          DateTime endDate = discount['endDate'].toDate();
          return now.isAfter(startDate) && now.isBefore(endDate);
        }).toList();
      case FilterStatus.Upcoming:
        return discounts.where((discount) {
          DateTime startDate = discount['startDate'].toDate();
          return now.isBefore(startDate);
        }).toList();
      case FilterStatus.Closed:
        return discounts.where((discount) {
          DateTime endDate = discount['endDate'].toDate();
          return now.isAfter(endDate);
        }).toList();
      default:
        return discounts;
    }
  }


}
 

class ScheduleCard extends StatelessWidget {
  final Map<String, dynamic> discountData;

  const ScheduleCard({Key? key, required this.discountData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the dates
    String startDate = discountData['startDate'] != null
        ? DateFormat('MM/dd/yyyy HH:mm').format(discountData['startDate'].toDate())
        : 'N/A';
    String endDate = discountData['endDate'] != null
        ? DateFormat('MM/dd/yyyy HH:mm').format(discountData['endDate'].toDate())
        : 'N/A';

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dubz Details: ${discountData['description']}",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 15),
          Text(
            "Dubz Type: ${discountData['type']}",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 15),
          Text(
            "From: $startDate",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 15),
          Text(
            "To: $endDate",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 15),
          Text(
            "Dubz Qty: ${discountData['quantity']}",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );

  }
}

