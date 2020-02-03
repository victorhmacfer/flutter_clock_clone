import 'package:flutter/material.dart';
import 'package:flutter_clock_clone/blocs/alarm_bloc.dart';
import 'package:flutter_clock_clone/models/Alarm.dart';

import 'package:flutter_clock_clone/utils/colors.dart';
import 'package:flutter_clock_clone/blocs/bloc_base.dart';
import 'package:provider/provider.dart';

//TODO: list items are not radio !  Implement that later.
//TODO: fix dimensions everywhere
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
        print('The time is ${selectedTime.hour}:${selectedTime.minute}');
        theBloc.addNewAlarm(selectedTime.hour, selectedTime.minute);
      }
    },
  );
}

//TODO: implement splash effect on clicking..
//TODO: hardcoded and dummy strings
class ExpandableItem extends StatefulWidget {

  String scheduledTime;
  bool enabled;
  bool repeats;
  String ringtone;
  bool vibrates;
  String label;

  ExpandableItem(Alarm theAlarm) {
    var alarmScheduledHour = theAlarm.scheduledHour;
    scheduledTime = '${(alarmScheduledHour < 10) ? '0': ''}${theAlarm.scheduledHour}:${theAlarm.scheduledMinute}';
    enabled = theAlarm.isEnabled;
    repeats = theAlarm.repeats;
    ringtone = theAlarm.ringtone;
    vibrates = theAlarm.vibrates;
    label = theAlarm.label;
  }

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

  Widget _bottomPart(bool isExpanded) {
    if (isExpanded) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Checkbox(value: false, onChanged: (checked) {}),
              Text('Repeat')
            ],
          ),
          Visibility(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  child: Text('S'),
                  backgroundColor: appWhite,
                ),
                CircleAvatar(
                  radius: 16,
                  child: Text('M'),
                  backgroundColor: appWhite,
                ),
                CircleAvatar(
                  radius: 16,
                  child: Text('T'),
                  backgroundColor: appWhite,
                ),
                CircleAvatar(
                  radius: 16,
                  child: Text('W'),
                  backgroundColor: appWhite,
                ),
                CircleAvatar(
                  radius: 16,
                  child: Text('T'),
                  backgroundColor: appWhite,
                ),
                CircleAvatar(
                  radius: 16,
                  child: Text('F'),
                  backgroundColor: appWhite,
                ),
                CircleAvatar(
                  radius: 16,
                  child: Text('S'),
                  backgroundColor: appWhite,
                ),
              ],
            ),
          ),
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
                  Text('Repeat')
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

  //TODO: have a textstyle  and copy with fontColor changing on isEnabled.
  Widget _topPart(bool isEnabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Text('04:19'), Switch(value: false, onChanged: null)],
    );
  }

  @override
  Widget build(BuildContext context) {
    double tileHeight;

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
              child: _topPart(false),
            ), //TODO: come back here

            Container(
              child: _bottomPart(expanded),
            ),
          ],
        ),
      ),
    );
  }
}



// ListView with radio-like expandable items.
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
