import 'package:flutter/material.dart';

import 'package:flutter_clock_clone/models/Alarm.dart';
import 'package:provider/provider.dart';
import 'package:flutter_clock_clone/utils/colors.dart';
import 'package:flutter_clock_clone/utils/styles.dart';
import 'package:flutter_clock_clone/blocs/alarm_bloc.dart';

import 'package:flutter_clock_clone/utils/dimensions.dart';

class AlarmListItem extends StatefulWidget {
  final String scheduledTimeText;
  final Alarm theAlarm;

  AlarmListItem(this.theAlarm)
      : scheduledTimeText =
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
        padding: EdgeInsets.only(
            left: screenSize.width * alarmItemHorizontalPaddingSF,
            right: screenSize.width * alarmItemHorizontalPaddingSF,
            top: screenSize.width * alarmItemTopPaddingSF),
        color: (expanded) ? appTabBarGray : appBackgroundBlack,
        child: Column(
          children: <Widget>[
            _topPart(context, false, alarmBloc, screenSize),
            _bottomPart(expanded, alarmBloc, screenSize),
          ],
        ),
      ),
    );
  }

  //TODO: have a textstyle  and copy with fontColor changing on isEnabled.
  Widget _topPart(BuildContext myContext, bool isEnabled, AlarmBloc theBloc, Size screenSize) {
    return Container(
      //color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () async {
                var selectedTime = await showTimePicker(
                context: myContext,
                initialTime: TimeOfDay.fromDateTime(widget.theAlarm.scheduledTime),
                );
                if (selectedTime != null) {
                  theBloc.setAlarmScheduledTime(selectedTime.hour, selectedTime.minute, widget.theAlarm);
                }
              },
              child: Text(widget.scheduledTimeText,
                  style: alarmScheduledTimeStyle.copyWith(
                    fontSize: screenSize.width * alarmNumberFontSizeSF,
                    color: (widget.theAlarm.isEnabled)
                        ? appBlue
                        : appAlarmNumberGray,
                  )),
            ),
          ),
          Switch(
              activeColor: appBlue,
              inactiveThumbColor: appIconGray,
              inactiveTrackColor: appIconGray.withOpacity(0.5),
              value: widget.theAlarm.isEnabled,
              onChanged: (newValue) {
                theBloc.setAlarmEnabledStatus(newValue, widget.theAlarm);
              })
        ],
      ),
    );
  }

  Widget _bottomPart(bool isExpanded, AlarmBloc theBloc, Size screenSize) {
    if (isExpanded) {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: screenSize.width * 0.02),
            child: Row(
              children: <Widget>[
                Container(
                  child: Theme(
                    //TODO: PERSONAL WARNING: THIS IS HACKING, AND A DUPLICATED ONE !!!
                    data: ThemeData(unselectedWidgetColor: appWhite),
                    child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor:
                            appTransparent, // affects square border too !
                        checkColor: appWhite,
                        value: widget.theAlarm.repeats,
                        onChanged: (newValue) {
                          theBloc.setAlarmRepeatStatus(
                              newValue, widget.theAlarm);
                        }),
                  ),
                ),
                Text(
                  'Repeat',
                  style: alarmItemTextStyle,
                )
              ],
            ),
          ),
          _repeatDaysRow(widget.theAlarm, theBloc, screenSize),
          Padding(
            padding: EdgeInsets.only(
                bottom: screenSize.width * 0.035), //TODO: hardcoded dimension
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      print('I clicked default morning');
                    },
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              right: screenSize.width *
                                  alarmItemIconRightPaddingSF),
                          child: Icon(
                            Icons.notification_important,
                            color: appWhite,
                          ),
                        ),
                        Text(
                          'Default (Morning Glory)',
                          style: alarmItemTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Theme(
                      //TODO: PERSONAL WARNING: THIS IS HACKING, AND A DUPLICATED ONE !!!
                      data: ThemeData(unselectedWidgetColor: appWhite),
                      child: Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor:
                              appTransparent, // affects square border too !
                          checkColor: appWhite,
                          value: widget.theAlarm.vibrates,
                          onChanged: (checked) {}),
                    ),
                    Text(
                      'Vibrate',
                      style: alarmItemTextStyle,
                    )
                  ],
                ),
              ],
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                print('I clicked label');
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: screenSize.width * 0.04),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right: screenSize.width * alarmItemIconRightPaddingSF),
                      child: Icon(
                        Icons.label_outline,
                        color: appWhite,
                      ),
                    ),
                    Text(
                      'Label',
                      style:
                          alarmItemTextStyle.copyWith(color: appAlarmNumberGray),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: screenSize.width * 0.045),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right:
                              screenSize.width * alarmItemIconRightPaddingSF),
                      child: Icon(Icons.notification_important),
                    ),
                    Text('blablabla'),
                  ],
                ),
                Icon(
                  Icons.help_outline,
                  color: appWhite,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: screenSize.width * 0.025),
            child: _divider(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: screenSize.width * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right:
                              screenSize.width * alarmItemIconRightPaddingSF),
                      child: Icon(
                        Icons.delete_forever,
                        color: appWhite,
                      ),
                    ),
                    Text(
                      'Delete',
                      style: alarmItemTextStyle,
                    ),
                  ],
                ),
                IconButton(
                    icon: Icon(Icons.expand_less),
                    color: appWhite,
                    onPressed: () {}),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Tomorrow',
              style: alarmItemTextStyle.copyWith(
                  color: (widget.theAlarm.isEnabled)
                      ? appWhite
                      : appAlarmNumberGray),
            ),
            IconButton(
                icon: Icon(Icons.expand_more),
                color: appWhite,
                onPressed: () {})
          ],
        ),
        _divider()
      ],
    );
  }

  Widget _repeatDaysRow(Alarm theAlarm, AlarmBloc myBloc, Size screenSize) {
    return Visibility(
      visible: theAlarm.repeats,
      // this GD is here to catch taps that miss the avatars so the item doesnt
      // collapse due to the outer GD (alarm item)
      child: GestureDetector(
        onTap: () {},
        child: Container(
          color:
              appTabBarGray, //This color is here cuz the GD doesnt work for containers without colors.. idk why.
          padding: EdgeInsets.symmetric(vertical: screenSize.width * 0.025),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MyCustomCircleAvatar(screenSize, 'S', 0, myBloc, theAlarm),
              MyCustomCircleAvatar(screenSize, 'M', 1, myBloc, theAlarm),
              MyCustomCircleAvatar(screenSize, 'T', 2, myBloc, theAlarm),
              MyCustomCircleAvatar(screenSize, 'W', 3, myBloc, theAlarm),
              MyCustomCircleAvatar(screenSize, 'T', 4, myBloc, theAlarm),
              MyCustomCircleAvatar(screenSize, 'F', 5, myBloc, theAlarm),
              MyCustomCircleAvatar(screenSize, 'S', 6, myBloc, theAlarm),
            ],
          ),
        ),
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

class MyCustomCircleAvatar extends StatelessWidget {
  final Size screenSize;
  final String text;
  final int index;
  final AlarmBloc bloc;
  final Alarm alarm;

  MyCustomCircleAvatar(
      this.screenSize, this.text, this.index, this.bloc, this.alarm);

  @override
  Widget build(BuildContext context) {
    var avatarRadiusScalingFactor = 0.038;
    var avatarTextScalingFactor = 0.045;

    return GestureDetector(
      onTap: () {
        bloc.setAlarmRepeatDay(!alarm.repeatDays[index], alarm, index);
      },
      child: CircleAvatar(
        radius: screenSize.width * avatarRadiusScalingFactor,
        child: Text(
          text,
          style: alarmItemCircleAvatarStyle.copyWith(
              fontSize: screenSize.width * avatarTextScalingFactor,
              color: (alarm.repeatDays[index]) ? appTabBarGray : appIconGray),
        ),
        backgroundColor: (alarm.repeatDays[index]
            ? appWhite
            : appDisabledAlarmRepeatDayBackground),
      ),
    );
  }
}
