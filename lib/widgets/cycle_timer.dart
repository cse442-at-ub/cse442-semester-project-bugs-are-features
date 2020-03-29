import 'dart:async';
import 'package:async/async.dart';
import 'package:quiver/async.dart';

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
  CountdownTimer _timer;

  int _start = 10;
  int _current = 10;

  void _startTimer(int duration) {
    Duration dur =  Duration(hours: 1);

    //Countdown timer to show progress
    _timer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = _timer.listen(null);
    sub.onData((duration) {
      setState(() { _current = _start - duration.elapsed.inSeconds; });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });

    @override
    void dispose() {
      _timer.cancel();
      super.dispose();
    }

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

      if (_isDay) {
        return SwitchListTile.adaptive(
          title: Image.asset('assets/misc/Sun.png', height: 40,
              width: 40,
              alignment: new Alignment(-1.0, -1.0)),
          subtitle: RaisedButton(
            onPressed: () {
              _startTimer(1);
            },
            child: Text("start"),
          ),
          secondary: Text("$_current"),
          value: _isDay,
          onChanged: (bool value) {
            setState(() {
              _isDay = value;
            });
          },
        );
      }
      else {
        return SwitchListTile.adaptive(
            title: Image.asset('assets/misc/Moon.png', height: 40,
                width: 40,
                alignment: new Alignment(-1.0, -1.0)),
            subtitle: RaisedButton(
              onPressed: () {
                _startTimer(1);
              },
              child: Text("start"),
            ),
            secondary: Text("$_current"),
            value: _isDay
        );
      }


  }

}