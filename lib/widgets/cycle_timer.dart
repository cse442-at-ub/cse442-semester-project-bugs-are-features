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

  bool _isDay = false;
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




 /* @override
  Widget build(BuildContext context) {
    // TODO: implement build
    RestartableTimer t;
    if (!_isDay) {
      return Image.asset('assets/misc/Moon.png', width: 10.0);
    }
    else {
      return GestureDetector(
        onTap: _toDayCycle(t),
        child: Image.asset(
            'assets/misc/Sun.png',
            width: 10.0
        ),
      );
    }
  }*/

  bool _lights = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Lights'),
      value: _lights,
      onChanged: (bool value) { setState(() { _lights = value; }); },
      secondary: const Icon(Icons.lightbulb_outline),
    );
  }

}