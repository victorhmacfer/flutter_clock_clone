import 'dart:async';

import 'package:flutter_clock_clone/blocs/bloc_base.dart';
import 'package:flutter_clock_clone/models/Alarm.dart';
import 'package:rxdart/rxdart.dart';

class AlarmBloc implements BlocBase {
  final _alarmListBehaviorSubject = BehaviorSubject<List<Alarm>>();

  Stream<List<Alarm>> get alarmListStream => _alarmListBehaviorSubject.stream;

  List<Alarm> _alarms = [];

  void addNewAlarm(int hour, int minute) {
    var now = DateTime.now();
    var dateTime = DateTime(now.year, now.month, now.day, hour, minute);
    _alarms.add(Alarm(scheduledTime: dateTime));
    _sortAlarmsList();
    _alarmListBehaviorSubject.add(_alarms);
  }

  void setAlarmEnabledStatus(bool newValue, Alarm alarm) {
    alarm.isEnabled = newValue;
    _alarmListBehaviorSubject.add(_alarms);
  }

  void setAlarmRepeatStatus(bool newValue, Alarm alarm) {
    alarm.repeats = newValue;
    _alarmListBehaviorSubject.add(_alarms);
  }

  void _sortAlarmsList() {
    _alarms.sort((a1, a2) => a1.scheduledTime.compareTo(a2.scheduledTime));
  }

  @override
  void dispose() {
    _alarmListBehaviorSubject.close();
  }
}
