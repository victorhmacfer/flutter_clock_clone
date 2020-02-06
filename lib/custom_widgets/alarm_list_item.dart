import 'package:flutter/material.dart';

import 'package:flutter_clock_clone/models/Alarm.dart';
import 'package:provider/provider.dart';
import 'package:flutter_clock_clone/utils/colors.dart';
import 'package:flutter_clock_clone/utils/styles.dart';
import 'package:flutter_clock_clone/blocs/alarm_bloc.dart';

import 'package:flutter_clock_clone/utils/dimensions.dart';


class AlarmListItem extends StatefulWidget {
  final String scheduledTime;
  final Alarm theAlarm;

  AlarmListItem(this.theAlarm)
      : scheduledTime =
            '${(theAlarm.scheduledTime.hour < 10) ? '0' : ''}${theAlarm.scheduledTime.hour}:${(theAlarm.scheduledTime.minute < 10) ? '0' : ''}${theAlarm.scheduledTime.minute}';

  @override
  _AlarmListItemState createState() => _AlarmListItemState();
}

class _AlarmListItemState extends State<AlarmListItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    var alarmBloc = Provider.of<AlarmBloc>(context);
    var screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * alarmItemHorizontalPaddingSF, 
          vertical: screenSize.width * alarmItemVerticalPaddingSF),
        color: (expanded) ? appTabBarGray : appBackgroundBlack,
        child: Column(
          children: <Widget>[
            Container(
              child: _topPart(false, alarmBloc, screenSize),
            ),
            Container(
              child: _bottomPart(expanded, alarmBloc, screenSize),
            ),
          ],
        ),
      ),
    );
  }

  //TODO: have a textstyle  and copy with fontColor changing on isEnabled.
  Widget _topPart(bool isEnabled, AlarmBloc theBloc, Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          widget.scheduledTime, 
          style: alarmScheduledTimeStyle.copyWith(
            fontSize: screenSize.width * alarmNumberFontSizeSF,
            color: (widget.theAlarm.isEnabled) ? appBlue : appAlarmNumberGray,
          )),
        Switch(
          activeColor: appBlue,
          inactiveThumbColor: appIconGray,
          inactiveTrackColor: appIconGray.withOpacity(0.5),
          value: widget.theAlarm.isEnabled,
          onChanged: (newValue) {
            theBloc.setAlarmEnabledStatus(newValue, widget.theAlarm);
          })
      ],
    );
  }

  Widget _bottomPart(bool isExpanded, AlarmBloc theBloc, Size screenSize) {
    if (isExpanded) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: appTransparent,  // affects square border too !
                checkColor: appWhite,
                  value: widget.theAlarm.repeats,
                  onChanged: (newValue) {
                    theBloc.setAlarmRepeatStatus(newValue, widget.theAlarm);
                  }),
              Text('Repeat', style: alarmItemTextStyle,)
            ],
          ),
          _repeatDaysRow(
              widget.theAlarm.repeats, widget.theAlarm.repeatDays, theBloc),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.notification_important, color: appWhite,),
                  Text('Default (Morning Glory)', style: alarmItemTextStyle,),
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(value: false, onChanged: (checked) {}),
                  Text('Vibrate', style: alarmItemTextStyle,)
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.label_outline, color: appWhite,),
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
              Icon(Icons.help_outline, color: appWhite,),
            ],
          ),
          _divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.delete_forever, color: appWhite,),
                  Text('Delete', style: alarmItemTextStyle,),
                ],
              ),
              IconButton(icon: Icon(Icons.expand_less), color: appWhite, onPressed: () {}),
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
            Text('Tomorrow', style: alarmItemTextStyle.copyWith(color: (widget.theAlarm.isEnabled) ? appWhite : appAlarmNumberGray),),
            IconButton(icon: Icon(Icons.expand_more), color: appWhite, onPressed: () {})
          ],
        ),
        _divider()
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

  Widget _divider() {
    return Container(
      height: 1,
      color: appDividerGray,
    );
  }
}
