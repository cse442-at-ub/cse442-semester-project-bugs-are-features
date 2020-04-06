import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ghost_app/models/cycle.dart' as Cycle;
import 'package:ghost_app/models/energy.dart' as Energy;



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
  bool _isDay; //bool value to check if it is a day cycle or a night cycle
  int _offset = 50;

  Duration _dayCycle;
  Duration _nightCycle;
  Duration _currentTime;
  Duration _startOfNextCycle;
  var _remaining;

  @override
  void initState() {
    super.initState();
    _isDay = false;
    _dayCycle = Duration(seconds: 1);
    _nightCycle = Duration(seconds: 1);
    _currentTime = new Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second);
    _startOfNextCycle = new Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second + Cycle.NIGHT_CYCLE);

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
      _remaining = _startOfNextCycle - _currentTime;

      if (_remaining == Duration.zero) {
        _timer.cancel();
        _isDay = !_isDay;

        _startOfNextCycle = new Duration(
            hours: DateTime.now().hour,
            minutes: DateTime.now().minute,
            seconds: Cycle.NIGHT_CYCLE + DateTime.now().second);

        _currentTime = new Duration(
            hours: DateTime.now().hour,
            minutes: DateTime.now().minute,
            seconds: DateTime.now().second);
      }
      else {
        _currentTime = new Duration(
            hours: DateTime.now().hour,
            minutes: DateTime.now().minute,
            seconds: DateTime.now().second);
      }
    });
    _startCycle(false);
  }

  void _switchCycleUI() {
    setState(() {
      _isDay = !_isDay;
      Energy.energy = Energy.energyInit + 0.5; //Increases the energy by 50% by switching the cycle
      _startOfNextCycle = new Duration(
          hours: DateTime.now().hour,
          minutes: DateTime.now().minute,
          seconds: DateTime.now().second + Cycle.NIGHT_CYCLE);

    });
    _startCycle(false);
  }

  void _destroyTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  Widget _makeText() {
    _remaining = _startOfNextCycle - _currentTime;

    format(Duration d) => d.toString().split('.').first.padLeft(0, "0"); // removes 5 extra zeros after seconds.
    String remainingTime = format(_remaining);

    if (_isDay) {
      debugPrint(format(_remaining));
      return Text(
        "Day Cycle is On!  $remainingTime",
        style: TextStyle(fontSize: 30),
      );
    } else {
      debugPrint(_remaining.toString());
      return Text("Night Cycle is On!  $remainingTime");
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
                onTap: _isDay ? _switchCycleUI : null, child: _loadCycle()),
            _makeText()
          ],
        ));
  }
}
