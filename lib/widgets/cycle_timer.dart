import 'dart:async';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:ghost_app/models/ghost.dart';

class CycleTimer extends StatefulWidget {

  final ValueSetter<bool> _interact;

  CycleTimer( this._interact);

  @override
  _CycleTimerState createState() => _CycleTimerState();

}

class _CycleTimerState extends State<CycleTimer>{

  bool _isDay = false; //set to true to test toggle day cycle
  RestartableTimer _timer; //restartable timer

  void _startTimer(int duration) {
    Duration dur =  Duration(hours: 1);

    // If we're in debug, just 1 minute
    assert(() {
      dur = Duration(minutes: 1);
      return true;
    }());

    _timer = Timer.periodic(dur, _toNightCycle);

  }

  ///render all functionality false in day cycle
  _toDayCycle(RestartableTimer t) async {
    // TODO: Send notification here
    t.reset();
    setState(() {
      _isDay = true;
    });
  }

  _toNightCycle(RestartableTimer t) async {
    t.reset();
    setState(() {
      _isDay = false;
    });
  }


///Toggle button to toggle between day and night cycles. Moon = Night cycle, Sun = Day cycle
  @override
  Widget build(BuildContext context) {
    if(_isDay){
      return SwitchListTile(
        title: Image.asset('assets/misc/Sun.png', height: 40, width: 40, alignment: new Alignment(-1.0, -1.0)),
        value: _isDay,
        onChanged: (bool value) {
          setState(() { _isDay = value; });
        },
      );
    }
    else{
      return SwitchListTile(
        title: Image.asset('assets/misc/Moon.png', height: 40, width: 40, alignment: new Alignment(-1.0, -1.0)),
        value: _isDay
      );
    }

  }

}