import 'dart:async';
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
  int _currentTime = 10;

  /*Duration _start = new Duration(
      hours: 2 + DateTime.now().hour,
      minutes: DateTime.now().minute,
      seconds: DateTime.now().second
  );
*/
  int _start = 100;
  //Countdown timer to show progress
  void startTimer() {

    CountdownTimer countDownTimer = new CountdownTimer(new Duration(seconds: _start), new Duration(seconds: 1),);

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _currentTime = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }



  ///Toggle button to toggle between day and night cycles. Moon = Night cycle, Sun = Day cycle
  @override
  Widget build(BuildContext context) {

    if (_isDay) {
      return Column(
        children: <Widget>[
          SwitchListTile.adaptive(
            title: Image.asset('assets/misc/Sun.png', height: 40, width: 40, alignment: new Alignment(-1.0, -1.0)),
            secondary: Text(_currentTime.toString()),
            value: _isDay,
            onChanged: (bool value) {
             // _toNightCycle(_timer);
              startTimer();
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
              secondary: Text(_currentTime.toString()),
              onChanged: (bool value) {
                startTimer();
                setState(() {
                  _isDay = value;
                });
              },
              value: _isDay)
        ],
      );
    }
  }
}


