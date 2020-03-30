import 'dart:async';
import 'dart:developer';
import 'package:async/async.dart';
import 'package:quiver/async.dart';

import 'package:flutter/material.dart';
import 'package:ghost_app/models/ghost.dart';

class CycleTimer extends StatefulWidget {
  final ValueSetter<bool> _setInteract;

  CycleTimer(this._setInteract);

  @override
  _CycleTimerState createState() => _CycleTimerState();
}

class _CycleTimerState extends State<CycleTimer> {
  bool _isDay = true; //set to true to test toggle day cycle

  Timer _timer;
  DateTime _currentTime;
  
  //Countdown timer to show progress
  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), _onTimeChange);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onTimeChange(Timer timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  ///render all functionality false in day cycle
  _toDayCycle(Timer t) async {
    // TODO: Send notification here
    initState();
    widget._setInteract(false);
    setState(() {
      _isDay = true;
    });
  }

  _toNightCycle(Timer t) async {
    initState();
    widget._setInteract(true);
    setState(() {
      _isDay = false;
    });
  }

  ///Toggle button to toggle between day and night cycles. Moon = Night cycle, Sun = Day cycle
  @override
  Widget build(BuildContext context) {
    final startOfNextCycle = calculateStartOfNextCycle(_currentTime);
    final remaining = startOfNextCycle.difference(_currentTime);
    //log(startOfNextCycle.toString(), name: "start");
    //log(remaining.toString(), name: "remaining");

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes - remaining.inHours * 60;
    final seconds = remaining.inSeconds - remaining.inMinutes * 60;

    final formattedRemaining = '$hours : $minutes : $seconds';

    if (_isDay) {
      return Column(
        children: <Widget>[
          SwitchListTile.adaptive(
            title: Image.asset('assets/misc/Sun.png', height: 40, width: 40, alignment: new Alignment(-1.0, -1.0)),
            secondary: Text("$formattedRemaining"),
            value: _isDay,
            onChanged: (bool value) {
             // _toNightCycle(_timer);
              setState(() {
                _isDay = value;
              });
            },
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          SwitchListTile.adaptive(
              title: Image.asset('assets/misc/Moon.png', height: 40, width: 40, alignment: new Alignment(-1.0, -1.0)),
              secondary: Text("$formattedRemaining"),
              value: _isDay)
        ],
      );
    }
  }
}

///Calculates the time remaining for the next cycle switch. Default set to 2 hrs
DateTime calculateStartOfNextCycle(DateTime time) {
  final timeUntilNextCycle = 2 + time.hour;
  var x = DateTime(time.year, time.month, time.day, timeUntilNextCycle);
  //log(x.toString(), name: "x");
  return DateTime(
      time.year, time.month, time.day, timeUntilNextCycle);
}
