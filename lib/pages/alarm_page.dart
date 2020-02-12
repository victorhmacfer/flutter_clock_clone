import 'package:flutter/material.dart';
import 'package:flutter_clock_clone/utils/scrolling_behavior.dart';
import 'package:provider/provider.dart';

import 'package:flutter_clock_clone/blocs/alarm_bloc.dart';
import 'package:flutter_clock_clone/models/Alarm.dart';
import 'package:flutter_clock_clone/utils/colors.dart';
import 'package:flutter_clock_clone/custom_widgets/alarm_list_item.dart';

class AlarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var alarmBloc = Provider.of<AlarmBloc>(context);

    return Scaffold(
      backgroundColor: appBackgroundBlack,
      body: Container(
        constraints: BoxConstraints.expand(),
        child: _alarmListView(alarmBloc),
      ),
      floatingActionButton: _alarmFab(context, alarmBloc),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Widget _alarmListView(AlarmBloc alarmBloc) {
  return StreamBuilder<List<Alarm>>(
      stream: alarmBloc.alarmListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            return ScrollConfiguration(
              behavior: NoMaterialGlowBehavior(),
              child: ListView(
                children: snapshot.data
                    .map((Alarm alarm) => AlarmListItem(alarm))
                    .toList(),
              ),
            );
          }

          return Center(
            child: Text('No Alarms.'),
          );
        }

        return Container();
      });
}

FloatingActionButton _alarmFab(BuildContext myContext, AlarmBloc theBloc) {
  return FloatingActionButton(
    foregroundColor: appBackgroundBlack,
    backgroundColor: appBlue,
    child: Icon(Icons.add),
    onPressed: () async {
      var selectedTime = await showTimePicker(
        context: myContext,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        theBloc.addNewAlarm(selectedTime.hour, selectedTime.minute);
      }
    },
  );
}
