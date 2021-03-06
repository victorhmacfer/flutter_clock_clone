import 'package:flutter/material.dart';

import 'package:flutter_clock_clone/models/Alarm.dart';
import 'package:provider/provider.dart';
import 'package:flutter_clock_clone/utils/colors.dart';
import 'package:flutter_clock_clone/utils/styles.dart';
import 'package:flutter_clock_clone/blocs/alarm_bloc.dart';

import 'package:flutter_clock_clone/utils/dimensions.dart';
import 'package:vibration/vibration.dart';

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

  final TextEditingController labelTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // labelTextController.text =
    //     'Label'; //This is hardcoded and NOT INTERNATIONALIZED text
  }

  @override
  void dispose() {
    labelTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var alarmBloc = Provider.of<AlarmBloc>(context);
    var screenSize = MediaQuery.of(context).size;

    print('I got inside list item build');

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
            _bottomPart(context, expanded, alarmBloc, screenSize),
          ],
        ),
      ),
    );
  }

  //TODO: have a textstyle  and copy with fontColor changing on isEnabled.
  Widget _topPart(BuildContext myContext, bool isEnabled, AlarmBloc theBloc,
      Size screenSize) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () async {
                var selectedTime = await showTimePicker(
                  context: myContext,
                  initialTime:
                      TimeOfDay.fromDateTime(widget.theAlarm.scheduledTime),
                );
                if (selectedTime != null) {
                  theBloc.setAlarmScheduledTime(
                      selectedTime.hour, selectedTime.minute, widget.theAlarm);
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

  Widget _bottomPart(BuildContext myContext, bool isExpanded, AlarmBloc theBloc,
      Size screenSize) {
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
                          onChanged: (newValue) async {
                            theBloc.setAlarmVibrateStatus(
                                newValue, widget.theAlarm);
                            if (newValue) {
                              if (await Vibration.hasVibrator()) {
                                Vibration.vibrate(duration: 300);
                              }
                            }
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
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                showDialog(
                    context: myContext,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: appBackgroundBlack,
                        contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                        content: SizedBox(
                          width: screenSize.width * alarmLabelDialogWidthSF,
                          child: TextField(
                            style: TextStyle(color: appWhite),
                            controller: labelTextController,
                            cursorWidth: 1,
                            cursorColor: appBlue,
                            autofocus: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              labelText: 'Label',
                              labelStyle: TextStyle(color: appBlue),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: appWhite, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: appBlue, width: 2)),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            textColor: appBlue,
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(myContext);
                            },
                          ),
                          FlatButton(
                            textColor: appBlue,
                            child: Text('OK'),
                            onPressed: () {
                              theBloc.setLabelText(
                                  labelTextController.text, widget.theAlarm);
                              Navigator.pop(myContext);
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: screenSize.width * 0.04),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right:
                              screenSize.width * alarmItemIconRightPaddingSF),
                      child: Icon(
                        Icons.label_outline,
                        color: appWhite,
                      ),
                    ),

                    Expanded(
                      child: TextField(
                        controller: labelTextController,
                        style: alarmItemTextStyle,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Label',
                          hintStyle: alarmItemTextStyle.copyWith(color: appAlarmNumberGray)),
                        enabled: false,
                        readOnly: true,
                      ),
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
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      print('I clicked delete');
                    },
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                right: screenSize.width *
                                    alarmItemIconRightPaddingSF),
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
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.expand_less),
                    color: appWhite,
                    onPressed: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    }),
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
              _chooseSubtitleText(widget.theAlarm),
              style: alarmItemTextStyle.copyWith(
                  color: (widget.theAlarm.isEnabled)
                      ? appWhite
                      : appAlarmNumberGray),
            ),
            IconButton(
                icon: Icon(Icons.expand_less),
                color: appWhite,
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                }),
          ],
        ),
        _divider()
      ],
    );
  }

  String _chooseSubtitleText(Alarm myAlarm) {
    var dateTime = myAlarm.scheduledTime;

    String alarmRepetitionText;

    if (!myAlarm.repeats) {
      alarmRepetitionText =
          (dateTime.isAfter(DateTime.now())) ? 'Today' : 'Tomorrow';
    } else {
      var repeatDays = myAlarm.repeatDays.keys
          .where((dayKey) => myAlarm.repeatDays[dayKey])
          .toList();
      if (repeatDays.length == 7) {
        return 'Every day';
      }
      var buffer = StringBuffer();
      buffer.writeAll(repeatDays, ", ");
      alarmRepetitionText = buffer.toString();
    }
    return alarmRepetitionText;
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
              MyCustomCircleAvatar(screenSize, 'S', 'Sun', myBloc, theAlarm),
              MyCustomCircleAvatar(screenSize, 'M', 'Mon', myBloc, theAlarm),
              MyCustomCircleAvatar(screenSize, 'T', 'Tue', myBloc, theAlarm),
              MyCustomCircleAvatar(screenSize, 'W', 'Wed', myBloc, theAlarm),
              MyCustomCircleAvatar(screenSize, 'T', 'Thu', myBloc, theAlarm),
              MyCustomCircleAvatar(screenSize, 'F', 'Fri', myBloc, theAlarm),
              MyCustomCircleAvatar(screenSize, 'S', 'Sat', myBloc, theAlarm),
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
  final String dayKey;
  final AlarmBloc bloc;
  final Alarm alarm;

  MyCustomCircleAvatar(
      this.screenSize, this.text, this.dayKey, this.bloc, this.alarm);

  @override
  Widget build(BuildContext context) {
    var avatarRadiusScalingFactor = 0.038;
    var avatarTextScalingFactor = 0.045;

    return GestureDetector(
      onTap: () {
        bloc.setAlarmRepeatDay(!alarm.repeatDays[dayKey], alarm, dayKey);
      },
      child: CircleAvatar(
        radius: screenSize.width * avatarRadiusScalingFactor,
        child: Text(
          text,
          style: alarmItemCircleAvatarStyle.copyWith(
              fontSize: screenSize.width * avatarTextScalingFactor,
              color: (alarm.repeatDays[dayKey]) ? appTabBarGray : appIconGray),
        ),
        backgroundColor: (alarm.repeatDays[dayKey]
            ? appWhite
            : appDisabledAlarmRepeatDayBackground),
      ),
    );
  }
}
