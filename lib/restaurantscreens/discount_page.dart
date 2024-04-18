import 'package:flutter/material.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:intl/intl.dart';
import 'package:dubz_creator/loginscreen/signin_screen.dart';
import 'package:dubz_creator/restaurantscreens/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiscountPage extends StatefulWidget {
  const DiscountPage({Key? key}) : super(key: key);

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

enum FilterStatus { Current, Upcoming, Closed }

class _DiscountPageState extends State<DiscountPage> {
  FilterStatus status = FilterStatus.Current;
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
  }

  Future<List<Map<String, dynamic>>> fetchDiscounts() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var discountsCollection = FirebaseFirestore.instance.collection('restaurant')
        .doc(userId).collection('discount_groups');

    QuerySnapshot querySnapshot = await discountsCollection.get();
    List<Map<String, dynamic>> discounts = [];

    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      
      // Fetch coupons to count used and remaining
      QuerySnapshot couponsSnapshot = await doc.reference.collection('discounts').get();
      int totalCoupons = couponsSnapshot.docs.length;
      int usedCoupons = couponsSnapshot.docs.where((coupon) => coupon['verified']).length;
      
      data['totalCoupons'] = totalCoupons;
      data['usedCoupons'] = usedCoupons;
      discounts.add(data);
    }
    return discounts;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Discount Schedule', style: TextStyle(color: Colors.white)), // Add title at top center
          automaticallyImplyLeading: false, // Remove back arrow
          actions: [
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
                backgroundColor: Config.primaryColor, // Config.primaryColor,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Closed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDiscountList(FilterStatus.Current),
            _buildDiscountList(FilterStatus.Upcoming),
            _buildDiscountList(FilterStatus.Closed),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountList(FilterStatus filterStatus) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchDiscounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No discounts found'));
        }

        // Filter data based on the current status
        List<Map<String, dynamic>> filteredDiscounts = filterDiscounts(snapshot.data!, filterStatus);

        return ListView.builder(
          itemCount: filteredDiscounts.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> discount = filteredDiscounts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ScheduleCard(
                discountData: discount,
                totalCoupons: discount['totalCoupons'],
                usedCoupons: discount['usedCoupons'],
              ),
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> filterDiscounts(List<Map<String, dynamic>> discounts, FilterStatus filterStatus) {
    DateTime now = DateTime.now();

    switch (filterStatus) {
      case FilterStatus.Current:
        return discounts.where((discount) {
          DateTime startDate = discount['startDate'].toDate();
          DateTime endDate = discount['endDate'].toDate();
          bool isFullyUsed = discount['usedCoupons'] == discount['totalCoupons'];
          return now.isAfter(startDate) && now.isBefore(endDate) && !isFullyUsed;
        }).toList();
      case FilterStatus.Upcoming:
        return discounts.where((discount) {
          DateTime startDate = discount['startDate'].toDate();
          return now.isBefore(startDate);
        }).toList();
      case FilterStatus.Closed:
        return discounts.where((discount) {
          DateTime endDate = discount['endDate'].toDate();
          bool isFullyUsed = discount['usedCoupons'] == discount['totalCoupons'];
          return now.isAfter(endDate) || isFullyUsed;
        }).toList();
      default:
        return discounts;
    }
  }
}

class ScheduleCard extends StatelessWidget {
  final Map<String, dynamic> discountData;
  final int totalCoupons;
  final int usedCoupons;

  const ScheduleCard({
    Key? key,
    required this.discountData,
    required this.totalCoupons,
    required this.usedCoupons,
  }) : super(key: key);

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
          CouponProgressBar(
            totalCoupons: totalCoupons,
            usedCoupons: usedCoupons,
          ),
        ],
      ),
    );
  }
}

class CouponProgressBar extends StatelessWidget {
  final int totalCoupons;
  final int usedCoupons;

  CouponProgressBar({required this.totalCoupons, required this.usedCoupons});

  @override
  Widget build(BuildContext context) {
    double usedFraction = totalCoupons > 0 ? usedCoupons / totalCoupons : 0;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.red, // Color for remaining coupons
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        FractionallySizedBox(
          widthFactor: usedFraction,
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.green, // Color for used coupons
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        Center(
          child: Text(
            '$usedCoupons / $totalCoupons Dubz Used',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
