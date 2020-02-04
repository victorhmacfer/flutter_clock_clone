import 'dart:async';

import 'package:flutter_clock_clone/blocs/bloc_base.dart';
import 'package:flutter_clock_clone/models/Alarm.dart';

class AlarmBloc implements BlocBase {
  StreamController<List<Alarm>> _alarmListController =
      StreamController.broadcast();

  Stream<List<Alarm>> get alarmListStream => _alarmListController.stream;

  List<Alarm> _alarms = [];

  void addNewAlarm(int hour, int minute) {
    var now = DateTime.now();
    var dateTime = DateTime(now.year, now.month, now.day, hour, minute);
    _alarms.add(Alarm(scheduledTime: dateTime));
    _sortAlarmsList();
    _alarmListController.sink.add(_alarms);
  }

  void setAlarmEnabledStatus(bool newValue, Alarm alarm) {
    alarm.isEnabled = newValue;
    _alarmListController.sink.add(_alarms);
  }

  void setAlarmRepeatStatus(bool newValue, Alarm alarm) {
    alarm.repeats = newValue;
    _alarmListController.sink.add(_alarms);
  }

  void _sortAlarmsList() {
    _alarms.sort((a1, a2) => a1.scheduledTime.compareTo(a2.scheduledTime));
  }

  @override
  void dispose() {
    _alarmListController.close();
  }
}
