import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_clock_clone/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // statusBarColor: appTabBarGray,
      statusBarColor: Color.fromARGB(0, 230, 15, 45),
    ));


    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHome(),
    );
  }
}
