import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_clone/blocs/alarm_bloc.dart';

import 'package:flutter_clock_clone/home.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // statusBarColor: appTabBarGray,
      statusBarColor: Color.fromARGB(0, 230, 15, 45),  //TODO: this is a bug
    ));


    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          Provider<AlarmBloc>(create: (_) => AlarmBloc()),
        ],
        child: MyHome(),),
    );
  }
}
