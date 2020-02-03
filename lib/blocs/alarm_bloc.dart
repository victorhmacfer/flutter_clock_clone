
import 'dart:async';

import 'package:flutter_clock_clone/blocs/bloc_base.dart';
import 'package:flutter_clock_clone/models/Alarm.dart';

class AlarmBloc implements BlocBase {

  StreamController<List<Alarm>> _alarmListController = StreamController.broadcast();

  Stream<List<Alarm>> get alarmListStream => _alarmListController.stream;

  List<Alarm> _alarms = [];


  void addNewAlarm(int hour, int minute) {
    _alarms.add(Alarm(
      scheduledHour: hour,
      scheduledMinute: minute
    ));
    _alarmListController.sink.add(_alarms);
  }











  @override
  void dispose() {
    _alarmListController.close();
  }


}