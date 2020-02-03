
import 'package:flutter/material.dart';

class Alarm {

  int scheduledTime;
  bool repeats;
  bool isEnabled;
  List<bool> repeatDays;
  String ringtone;
  bool vibrates;
  String label;

  Alarm({
    @required this.scheduledTime,
     this.repeats = false,
     this.isEnabled = true,
     this.repeatDays = const [true, true, true, true, true, true, true], //days of the week
     this.ringtone = "Morning Glory",
     this.vibrates = true,
     this.label = ""
      });


}