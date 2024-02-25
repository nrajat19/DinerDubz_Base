import 'package:dubz_creator/utils/config.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatefulWidget {
  const RestaurantCard({Key? key}) : super(key : key);

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.widthSize * 0.33,
                //insert logo of restaurant
                //child: Image.asset
              ),
              Flexible(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    const Text(
                      "Restaurant Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Restaurant Type",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        Icon(Icons.star_border, color: Colors.yellow, size: 16,),
                        Spacer(flex: 1,),
                        Text('4.5'),
                        Spacer(flex: 1),
                        Text("Reviews"),
                        Spacer(flex: 1),
                        Text("(20)"),  
                        Spacer(flex: 7),                                            
                      ],
                    ),
                  ],
                ),
              ),),
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}