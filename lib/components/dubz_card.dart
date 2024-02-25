import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DubzCard extends StatefulWidget {
  DubzCard({Key? key}) : super(key: key);

  @override
  State<DubzCard> createState() => _DubzCardState();
}
class _DubzCardState extends State<DubzCard> {
  @override

  Widget build(BuildContext context) {
    return Container();
      /** 
      width: double.infinity,
      decoration: BoxDecoration(
        color: Config.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            children: <Widget>[

            ],
          ),
        ),

      ),
      
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column( 
            children: <Widget>[ 
              Row(
                children: [
                  CircleAvatar(
                    //backgroundImage:
                      //AssetImage()
                      //insert restaurant Logo
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Restaurant Name",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Bar/Restaurant Type",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              Config.spaceSmall,

              ScheduleCard(),
              Config.spaceSmall,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ),                  
                ],
              ),
            ],
          ),
        ),
      ),
      
    );
    */
  }
}

class PlotLineGraph extends StatelessWidget {
  const PlotLineGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}


class PlotPieGraph extends StatelessWidget {
  const PlotPieGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class PlotBarGraph extends StatelessWidget {
  const PlotBarGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Wednesday, 2/14/2024",
            style: const TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              "2:00 PM", 
              style: TextStyle(color: Colors.white),
          ))
        ],
      ),
    );
  }
}