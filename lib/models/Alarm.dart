
import 'package:flutter/material.dart';

class Alarm {

  int scheduledHour;
  int scheduledMinute;
  bool repeats;
  bool isEnabled;
  List<bool> repeatDays;
  String ringtone;
  bool vibrates;
  String label;

  // choosing defaults in model.. couldve put them in addNewAlarm method.
  Alarm({
    @required this.scheduledHour,
    @required this.scheduledMinute,
     this.repeats = false,
     this.isEnabled = true,
     this.repeatDays = const [true, true, true, true, true, true, true], //days of the week
     this.ringtone = "Morning Glory",
     this.vibrates = true,
     this.label = ""
      });


}