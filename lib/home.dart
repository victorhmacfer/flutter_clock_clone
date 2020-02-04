import 'package:flutter/material.dart';
import 'package:flutter_clock_clone/utils/colors.dart';

import 'package:flutter_clock_clone/pages/alarm_page.dart';
import 'package:flutter_clock_clone/pages/clock_page.dart';
import 'package:flutter_clock_clone/pages/timer_page.dart';
import 'package:flutter_clock_clone/pages/stopwatch_page.dart';

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: appBackgroundBlack,
          appBar: ColoredTabBar(
            color: appTabBarGray,
            height: media.height * 0.10,
            tabBar: TabBar(
              labelPadding: EdgeInsets.symmetric(
                  horizontal:
                      0), // overriding the default padding for tab labels
              indicatorColor: appBlue,
              labelColor: appBlue,
              unselectedLabelColor: appIconGray,
              tabs: <Widget>[
                TabBarItem.alarm(),
                TabBarItem.clock(),
                TabBarItem.timer(),
                TabBarItem.stopwatch(),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              AlarmPage(),
              ClockPage(),
              TimerPage(),
              StopwatchPage(),
            ],
          ),
        ));
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  final Color color;
  final TabBar tabBar;
  final double height;

  ColoredTabBar({this.color, this.height, this.tabBar});

  @override
  Size get preferredSize => Size(tabBar.preferredSize.width, height);
  // Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24),
      color: color,
      child: Row(
        children: <Widget>[
          Flexible(child: tabBar),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: appIconGray,
            ),
            onPressed: () {
              print('clickei no overflow menu da tabBar');
            },
          )
        ],
      ),
    );
  }
}

class TabBarItem extends StatelessWidget {
  final Icon icon;
  final String text;

  TabBarItem(this.icon, this.text);

  factory TabBarItem.alarm() => TabBarItem(Icon(Icons.alarm), 'Alarm');

  factory TabBarItem.clock() => TabBarItem(Icon(Icons.query_builder), 'Clock');

  factory TabBarItem.timer() => TabBarItem(Icon(Icons.timelapse), 'Timer');

  factory TabBarItem.stopwatch() => TabBarItem(Icon(Icons.timer), 'Stopwatch');

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          icon,
          Text(text),
        ],
      ),
    );
  }
}
