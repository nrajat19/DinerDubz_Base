import 'package:dubz_creator/components/button_widget.dart';
import 'package:dubz_creator/components/date_picker_widget.dart';
import 'package:dubz_creator/components/date_range_picker_widget.dart';
import 'package:dubz_creator/components/datetime_picker_widget.dart';
import 'package:dubz_creator/components/time_picker_widget.dart';
import 'package:dubz_creator/utils/main_layout.dart';
import 'package:dubz_creator/utils/config.dart';
import 'package:dubz_creator/restaurantscreens/discount_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  var index = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Fill out Form to Upload Discount for Customers",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SizedBox(
                    height: 50,
                    width: Config.widthSize * 0.6,
                    child: const TextField(
                      decoration: InputDecoration(
                          labelText:
                              "Dubz Title/Description"), // Only numbers can be entered
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    width: Config.widthSize * 0.6,
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: index == -1 ? null : index,
                      hint: const Text('Select Dubz Type'),
                      items: [
                        DropdownMenuItem(
                          child: Text('Promotion'),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text('Discount'),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text('Price Drop'),
                          value: 3,
                        ),
                        DropdownMenuItem(
                          child: Text('Loyalty (Coming Soon)'),
                          value: 4,
                        ),
                      ],
                      onChanged: (int? value) {
                        setState(() {
                          index = value ?? -1;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Start",
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(
                      width: Config.widthSize * 0.25,
                    ),
                    const Text(
                      "End",
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DatetimePickerWidget(),
                      const SizedBox(
                        width: 20,
                      ),
                      DatetimePickerWidget(),
                    ],
                ),

                Padding(
                  padding: const EdgeInsets.all(50),
                  child: SizedBox(
                    height: 50,
                    width: Config.widthSize * 0.6,
                    child: TextField(
                      decoration:
                          InputDecoration(labelText: "Enter Dubz Quantity"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Config.primaryColor,
                    ),
                    child: const Text(
                      'Submit Dubz',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    onPressed: () {                
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/** 

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: buildBottomBar(),
        body: buildPages(),
      );

  Widget buildBottomBar() {
    final style = TextStyle(color: Colors.white);

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          icon: Text('DatePicker', style: style),
          label: ('Basic'),
        ),
        BottomNavigationBarItem(
          icon: Text('DatePicker', style: style),
          label: ('Advanced'),
        ),
      ],
      onTap: (int index) => setState(() => this.index = index),
    );
  }

  Widget buildPages() {
    switch (index) {
      case 0:
        return Scaffold(
          backgroundColor: Colors.lightBlue,
          body: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DatePickerWidget(),
                const SizedBox(height: 24),
                TimePickerWidget(),
                const SizedBox(height: 24),
                DateRangePickerWidget(),
              ],
            ),
          ),
        );
      case 1:
        return Scaffold(
          backgroundColor: Colors.lightBlue,
          body: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DatetimePickerWidget(),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }
  */

/**
class _BookingPageState extends State<BookingPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                const Text(
                  'Book Your Dubz',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                _tableCalendar(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      'Select Discount Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  setState (() {
                    _currentIndex = index;
                    _timeSelected = true;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _currentIndex == index
                        ? Colors.white
                        : Colors.black
                    ),
                    borderRadius: BorderRadius.circular(15),
                    color: _currentIndex == index
                      ? Config.primaryColor
                      : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _currentIndex == index ? Colors.white : null,
                    ),
                  ),
                ),
              );
            },
            childCount: 8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 1.5),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: Button(
                width: double.infinity,
                title: "Upload Discount",
                onPressed: () {},
                disable: _timeSelected && _dateSelected ? false : true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2025, 1, 1),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
        todayDecoration:
            BoxDecoration(color: Config.primaryColor, shape: BoxShape.circle),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;
        });
      }),
    );
  }
}

*/
