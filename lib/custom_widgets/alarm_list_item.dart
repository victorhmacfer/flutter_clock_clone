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
        padding: EdgeInsets.only(
            left: screenSize.width * alarmItemHorizontalPaddingSF,
            right: screenSize.width * alarmItemHorizontalPaddingSF,
            top: screenSize.width * alarmItemTopPaddingSF),
        color: (expanded) ? appTabBarGray : appBackgroundBlack,
        child: Column(
          children: <Widget>[
            _topPart(false, alarmBloc, screenSize),
            _bottomPart(expanded, alarmBloc, screenSize),
          ],
        ),
      ),
    );
  }

  //TODO: have a textstyle  and copy with fontColor changing on isEnabled.
  Widget _topPart(bool isEnabled, AlarmBloc theBloc, Size screenSize) {
    return Container(
      //color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(widget.scheduledTime,
              style: alarmScheduledTimeStyle.copyWith(
                fontSize: screenSize.width * alarmNumberFontSizeSF,
                color:
                    (widget.theAlarm.isEnabled) ? appBlue : appAlarmNumberGray,
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
                          theBloc.setAlarmRepeatStatus(newValue, widget.theAlarm);
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
          _repeatDaysRow(widget.theAlarm.repeats, widget.theAlarm.repeatDays,
              theBloc, screenSize),
          Padding(
            padding: EdgeInsets.only(bottom: screenSize.width * 0.035), //TODO: hardcoded dimension
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
                          onChanged: (checked) {
                            
                          }),
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
          Padding(
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
                  style: alarmItemTextStyle.copyWith(color: appAlarmNumberGray),
                ),
              ],
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

  Widget _repeatDaysRow(bool repeats, List<bool> repeatDaysBitmap,
      AlarmBloc myBloc, Size screenSize) {

    var avatarRadiusScalingFactor = 0.038;
    var avatarTextScalingFactor = 0.045;
    return Visibility(
      visible: repeats,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenSize.width * 0.025),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CircleAvatar(
              radius: screenSize.width * avatarRadiusScalingFactor,
              child: Text('S', style: alarmItemCircleAvatarStyle.copyWith(fontSize: screenSize.width * avatarTextScalingFactor),),
              backgroundColor: (repeatDaysBitmap[0]
                  ? appWhite
                  : appDisabledAlarmRepeatDayBackground),
            ),
            CircleAvatar(
              radius: screenSize.width * avatarRadiusScalingFactor,
              child: Text('M', style: alarmItemCircleAvatarStyle.copyWith(fontSize: screenSize.width * avatarTextScalingFactor),),
              backgroundColor: (repeatDaysBitmap[1]
                  ? appWhite
                  : appDisabledAlarmRepeatDayBackground),
            ),
            CircleAvatar(
              radius: screenSize.width * avatarRadiusScalingFactor,
              child: Text('T', style: alarmItemCircleAvatarStyle.copyWith(fontSize: screenSize.width * avatarTextScalingFactor),),
              backgroundColor: (repeatDaysBitmap[2]
                  ? appWhite
                  : appDisabledAlarmRepeatDayBackground),
            ),
            CircleAvatar(
              radius: screenSize.width * avatarRadiusScalingFactor,
              child: Text('W', style: alarmItemCircleAvatarStyle.copyWith(fontSize: screenSize.width * avatarTextScalingFactor),),
              backgroundColor: (repeatDaysBitmap[3]
                  ? appWhite
                  : appDisabledAlarmRepeatDayBackground),
            ),
            CircleAvatar(
              radius: screenSize.width * avatarRadiusScalingFactor,
              child: Text('T', style: alarmItemCircleAvatarStyle.copyWith(fontSize: screenSize.width * avatarTextScalingFactor),),
              backgroundColor: (repeatDaysBitmap[4]
                  ? appWhite
                  : appDisabledAlarmRepeatDayBackground),
            ),
            CircleAvatar(
              radius: screenSize.width * avatarRadiusScalingFactor,
              child: Text('F', style: alarmItemCircleAvatarStyle.copyWith(fontSize: screenSize.width * avatarTextScalingFactor),),
              backgroundColor: (repeatDaysBitmap[5]
                  ? appWhite
                  : appDisabledAlarmRepeatDayBackground),
            ),
            CircleAvatar(
              radius: screenSize.width * avatarRadiusScalingFactor,
              child: Text('S', style: alarmItemCircleAvatarStyle.copyWith(fontSize: screenSize.width * avatarTextScalingFactor),),
              backgroundColor: (repeatDaysBitmap[6]
                  ? appWhite
                  : appDisabledAlarmRepeatDayBackground),
            ),
          ],
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
