import 'package:flutter/material.dart';

import 'package:flutter_clock_clone/utils/colors.dart';
import 'package:flutter_clock_clone/utils/scrolling_behavior.dart';
import 'package:flutter_clock_clone/utils/styles.dart';

class ClockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appBackgroundBlack,
      floatingActionButton: FloatingActionButton(backgroundColor: appBlue,foregroundColor: appBackgroundBlack, child: Icon(Icons.language), onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ScrollConfiguration(
        behavior: NoMaterialGlowBehavior(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 26), //TODO: hardcoded !!
          child: Column(
            children: <Widget>[
              SizedBox(
                height: screenSize.width * 0.06,
              ),
              Text(
                '13:00',
                style: clockMainTimeStyle,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 22),
                child: Text(
                  'Wed, Feb 12',
                  style: TextStyle(color: appWhite, fontSize: 18),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  height: 1,
                  color: appDividerGray,
                ),
              ),

              _clockList(),

              SizedBox(height: 82)
            ],
          ),
        ),
      ),
    );
  }

  Widget _clockList() {
    return Column(
      children: <Widget>[
        ClockListItem(),
        ClockListItem(),
        ClockListItem(),
        ClockListItem(),
        ClockListItem(),
        ClockListItem(),
        ClockListItem(),
        ClockListItem(),
        ClockListItem(),
      ],
    );
  }
}




class ClockListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      padding: EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Paris',
                style: TextStyle(color: appWhite, fontSize: 17),
              ),
              SizedBox(height: 6),
              Text(
                '4 hours ahead',
                style: TextStyle(color: appAlarmNumberGray),
              ),
            ],
          ),
          Text(
            '19:48',
            style: clockCityTimeStyle,
          )
        ],
      ),
    );
  }
}
