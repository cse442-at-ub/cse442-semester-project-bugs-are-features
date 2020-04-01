import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ghost_app/models/cycle.dart' as Cycle;

class CycleTimer extends StatefulWidget {
  /// Sets the Day and Night cycle
  final ValueSetter<bool> _setDayCycle;
  final bool _cancelTimer;

  CycleTimer(this._setDayCycle, this._cancelTimer);
  @override
  _CycleTimerState createState() => _CycleTimerState();
}

class _CycleTimerState extends State<CycleTimer> {
  Timer _timer;
  bool _isDay; //bool vale to check if it is a day cycle or a night cycle
  int _offset = 50;

  Duration _dayCycle;
  Duration _nightCycle;
  int _timeElapsed;

  @override
  void initState() {
    super.initState();
    _isDay = false;
    _dayCycle = Duration(seconds: 1);
    _nightCycle = Duration(seconds: 1);
    _timeElapsed = Cycle.NIGHT_CYCLE;

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

  Widget _loadCycle() {
    print(_timeElapsed);
    var _cycleImg;
    if (_isDay) {
      _cycleImg = Image.asset(
        'assets/misc/Sun.png',
        height: 80,
        width: 80,
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



  void _startCycle(bool firstStart) {
    _destroyTimer();
    if (_isDay) {
      _timer = Timer.periodic(_nightCycle, _switchCycle);
      widget._setDayCycle(true);
    } else {
      _timer = Timer.periodic(_dayCycle, _switchCycle);
      if (!firstStart) {
        widget._setDayCycle(false);
      }
    }
  }

  void _switchCycle(Timer _t) {
    setState(() {
      if (_timeElapsed < 1) {
        _timer.cancel();
        _isDay = !_isDay;
        _timeElapsed = Cycle.NIGHT_CYCLE;
      } else {
        _timeElapsed -= 1;
      }
    });
    _startCycle(false);
  }

  void _switchCycle2() {
    setState(() {
      _isDay = !_isDay;
      _timeElapsed = Cycle.NIGHT_CYCLE;
    });
    _startCycle(false);
  }

  void _destroyTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  Widget _makeText() {
    if (_isDay) {
      return Text(
        "Day Cycle is On! $_timeElapsed",
        style: TextStyle(fontSize: 30),
      );
    } else {
      return Text("Night Cycle is On! $_timeElapsed");
    }
  }

  ///Toggle button to toggle between day and night cycles. Moon = Night cycle, Sun = Day cycle
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        margin:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top + _offset),
        child: Column(
          mainAxisAlignment:
              _isDay ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                onTap: _isDay ? _switchCycle2 : null, child: _loadCycle()),
            _makeText()
          ],
        ));
  }
}
