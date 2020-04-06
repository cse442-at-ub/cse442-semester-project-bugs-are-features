import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghost_app/models/energy.dart' as Energy;

const int DAY_CYCLE = 10; //Duration of day cycle
const int NIGHT_CYCLE = 10; //Duration of night cycle

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

  Duration _interval;
  Duration _cycle;

  @override
  void initState() {
    super.initState();
    _isDay = false;
    _interval = Duration(seconds: 1);
    _cycle = Duration(seconds: NIGHT_CYCLE);

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
      _timer = Timer(_interval, _switchCycle);
    } else {
      _timer = Timer(_interval, _switchCycle);
    }
  }

  void _switchCycle() {

    setState(() {
      if (_cycle == Duration.zero) {
        _timer.cancel();
        _isDay = !_isDay;

        ///Updates energy to 100 when player waits the entire Day cycle
        if(!_isDay){
          Energy.energy = 100;
          debugPrint("Waited out entire Day cycle. Energy: ${Energy.energyInit}");
        }

        widget._setDayCycle(_isDay);
        _cycle = Duration(seconds: NIGHT_CYCLE);
      }
      else {
        _cycle -= Duration(seconds: 1);
      }
    });
    _startCycle(false);
  }

  void _switchCycleUI() {
    setState(() {
      _isDay = !_isDay;

      //Ensures energy doesn't go beyond 100
      if((Energy.energyInit + 50) <= 100){
        Energy.energy = Energy.energyInit + 50; //Increases the energy by 50 by switching the cycle
        debugPrint("Day cycle toggled. Energy +50: ${Energy.energyInit}");
      }

      widget._setDayCycle(_isDay);
      _cycle = Duration(seconds: NIGHT_CYCLE);
    });
    _startCycle(false);
  }

  void _destroyTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  Widget _makeText() {
    format(Duration d) => d.toString().split('.').first.padLeft(0, "0"); // removes 5 extra zeros after seconds.
    String remainingTime = format(_cycle);

    if (_isDay) {
      return Text(
        "Day Cycle is On!  $remainingTime",
        style: TextStyle(fontSize: 30),
      );
    } else {
      return Text("Night Cycle is On!  $remainingTime");
    }
  }

  ///Toggle button to toggle between day and night cycles.
  /// Moon = Night cycle, Sun = Day cycle
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
                onTap: _isDay ? _switchCycleUI : null, child: _loadCycle()
            ),
            _makeText()
          ],
        ));
  }
}
