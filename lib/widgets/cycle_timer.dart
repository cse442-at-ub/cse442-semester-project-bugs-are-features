import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ghost_app/models/cycle.dart' as Cycle;

class CycleTimer extends StatefulWidget {
  /// Sets the Day and Night cycle
  final ValueSetter<bool> _setDayCycle;
  bool _cancelTimer;

  CycleTimer(this._setDayCycle, this._cancelTimer);
  @override
  _CycleTimerState createState() => _CycleTimerState();
}

class _CycleTimerState extends State<CycleTimer> {
  Timer _timer;
  bool _isDay; //set to true to test toggle day cycle
  int _offset = 50;

  Duration _dayCycle;
  Duration _nightCycle;
  var _timeElapsed;

  Widget _loadCycle() {
    var _cycleImg;
    if (_isDay) {
      _cycleImg = Image.asset(
        'assets/misc/Sun.png',
        height: 40,
        width: 40,
      );
    } else {
      _cycleImg = Image.asset(
        'assets/misc/Moon.png',
        height: 40,
        width: 40,
      );
    }
    return _cycleImg;
  }

  Widget _makeText() {
    if (_isDay) {
      return Text("Day Cycle is On!");
    } else {
      return Text("Night Cycle is On!");
    }
  }

  void _startCycle(bool firstStart) {
    _destroyTimer();
    if (_isDay) {
      _timer = Timer(_nightCycle, _switchCycle);
      widget._setDayCycle(true);
    } else {
      _timer = Timer(_dayCycle, _switchCycle);
      if (!firstStart) {
        widget._setDayCycle(false);
      }
    }
  }

  void _switchCycle() {
    setState(() {
      _isDay = !_isDay;
    });
    _startCycle(false);
  }

  @override
  void initState() {
    super.initState();
    _isDay = false;
    _dayCycle = Duration(seconds: Cycle.DAY_CYCLE);
    _nightCycle = Duration(seconds: Cycle.NIGHT_CYCLE);
    _timeElapsed = 0;
    if (widget._cancelTimer) {
      _destroyTimer();
    } else {
      _startCycle(true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _destroyTimer();
  }

  void _destroyTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  ///Toggle button to toggle between day and night cycles. Moon = Night cycle, Sun = Day cycle
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: _isDay ? Alignment.center : Alignment.topCenter,
        margin:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top + _offset),
        child: Column(
          children: <Widget>[
            GestureDetector(
                onTap: _isDay ? _switchCycle : null, child: _loadCycle()),
            _makeText()
          ],
        ));
  }
}
