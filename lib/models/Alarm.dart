import 'package:flutter/material.dart';

class Alarm {
  DateTime scheduledTime;
  bool repeats;
  bool isEnabled;
  List<bool> repeatDays;
  String ringtone;
  bool vibrates;
  String label;

  // choosing defaults in model.. couldve put them in addNewAlarm method.
  Alarm(
      {@required this.scheduledTime,
      this.repeats = false,
      this.isEnabled = true,
      
      this.ringtone = "Morning Glory",
      this.vibrates = true,
      this.label = ""}) {

        this.repeatDays = [true, true, true, true, true, true, true];

      }
}
