import 'package:flutter/material.dart';
import 'package:flutter_clock_clone/blocs/alarm_bloc.dart';
import 'package:flutter_clock_clone/models/Alarm.dart';

import 'package:flutter_clock_clone/utils/colors.dart';
import 'package:provider/provider.dart';

class AlarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var alarmBloc = Provider.of<AlarmBloc>(context);

    return Scaffold(
      body: Container(
        color: appBackgroundBlack,
        constraints: BoxConstraints.expand(),
        child: MyAlarmListView(alarmBloc),
      ),
      floatingActionButton: _alarmFab(context, alarmBloc),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
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

class ExpandableItem extends StatefulWidget {
  final String scheduledTime;
  final Alarm theAlarm;

  ExpandableItem(this.theAlarm)
      : scheduledTime =
            '${(theAlarm.scheduledTime.hour < 10) ? '0' : ''}${theAlarm.scheduledTime.hour}:${(theAlarm.scheduledTime.minute < 10) ? '0' : ''}${theAlarm.scheduledTime.minute}';

  @override
  _ExpandableItemState createState() => _ExpandableItemState();
}

class _ExpandableItemState extends State<ExpandableItem> {
  bool expanded = false;

  Widget _divider() {
    return Container(
      height: 1,
      color: appDividerGray,
    );
  }

  //TODO: have a textstyle  and copy with fontColor changing on isEnabled.
  Widget _topPart(bool isEnabled, AlarmBloc theBloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(widget.scheduledTime),
        Switch(
            value: widget.theAlarm.isEnabled,
            onChanged: (newValue) {
              theBloc.setAlarmEnabledStatus(newValue, widget.theAlarm);
            })
      ],
    );
  }

  Widget _repeatDaysRow(
      bool repeats, List<bool> repeatDaysBitmap, AlarmBloc myBloc) {
    return Visibility(
      visible: repeats,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CircleAvatar(
            radius: 16,
            child: Text('S'),
            backgroundColor: (repeatDaysBitmap[0]
                ? appWhite
                : appDisabledAlarmRepeatDayBackground),
          ),
          CircleAvatar(
            radius: 16,
            child: Text('M'),
            backgroundColor: (repeatDaysBitmap[1]
                ? appWhite
                : appDisabledAlarmRepeatDayBackground),
          ),
          CircleAvatar(
            radius: 16,
            child: Text('T'),
            backgroundColor: (repeatDaysBitmap[2]
                ? appWhite
                : appDisabledAlarmRepeatDayBackground),
          ),
          CircleAvatar(
            radius: 16,
            child: Text('W'),
            backgroundColor: (repeatDaysBitmap[3]
                ? appWhite
                : appDisabledAlarmRepeatDayBackground),
          ),
          CircleAvatar(
            radius: 16,
            child: Text('T'),
            backgroundColor: (repeatDaysBitmap[4]
                ? appWhite
                : appDisabledAlarmRepeatDayBackground),
          ),
          CircleAvatar(
            radius: 16,
            child: Text('F'),
            backgroundColor: (repeatDaysBitmap[5]
                ? appWhite
                : appDisabledAlarmRepeatDayBackground),
          ),
          CircleAvatar(
            radius: 16,
            child: Text('S'),
            backgroundColor: (repeatDaysBitmap[6]
                ? appWhite
                : appDisabledAlarmRepeatDayBackground),
          ),
        ],
      ),
    );
  }

  Widget _bottomPart(bool isExpanded, AlarmBloc theBloc) {
    if (isExpanded) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Checkbox(
                  value: widget.theAlarm.repeats,
                  onChanged: (newValue) {
                    theBloc.setAlarmRepeatStatus(newValue, widget.theAlarm);
                  }),
              Text('Repeat')
            ],
          ),
          _repeatDaysRow(
              widget.theAlarm.repeats, widget.theAlarm.repeatDays, theBloc),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.notification_important),
                  Text('Default (Morning Glory)'),
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(value: false, onChanged: (checked) {}),
                  Text('Vibrate')
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.label_outline),
              Text('Label'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.notification_important),
                  Text('blablabla'),
                ],
              ),
              Icon(Icons.help_outline),
            ],
          ),
          _divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.delete_forever),
                  Text('Delete'),
                ],
              ),
              IconButton(icon: Icon(Icons.expand_less), onPressed: () {}),
            ],
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Tomorrow'),
            IconButton(icon: Icon(Icons.expand_more), onPressed: () {})
          ],
        ),
        _divider()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var alarmBloc = Provider.of<AlarmBloc>(context);

    return InkWell(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        color: (expanded) ? appTabBarGray : appBackgroundBlack,
        child: Column(
          children: <Widget>[
            Container(
              child: _topPart(false, alarmBloc),
            ),
            Container(
              child: _bottomPart(expanded, alarmBloc),
            ),
          ],
        ),
      ),
    );
  }
}

class MyAlarmListView extends StatelessWidget {
  final AlarmBloc alarmBloc;

  MyAlarmListView(this.alarmBloc);

  Widget _buildItem(Alarm alarm) => ExpandableItem(alarm);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Alarm>>(
        stream: alarmBloc.alarmListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              return ListView(
                children: snapshot.data.map(_buildItem).toList(),
              );
            }

            return Center(
              child: Text('No Alarms.'),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
