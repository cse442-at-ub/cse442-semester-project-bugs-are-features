import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghost_app/models/energy.dart' as Energy;
import 'package:ghost_app/models/game.dart' as Game;
import 'package:ghost_app/models/timers.dart';

class CycleTimer extends StatefulWidget {
  /// Sets the Day and Night cycle
  final VoidCallback _switchDayNightCycle;

  /// The current cycle state, from the Ghost screen
  final bool _isDayCycle;

  /// The Timers instance containing all timers
  final Timers _timers;

  CycleTimer(this._switchDayNightCycle, this._isDayCycle, this._timers);

  @override
  _CycleTimerState createState() => _CycleTimerState();
}

class _CycleTimerState extends State<CycleTimer> {
  /// Duration of every day & night cycle
  Duration _cycle;

  /// The cycle length in seconds
  int _cycleLength;

  @override
  void initState() {
    super.initState();
    _cycleLength = Game.DAY_NIGHT_LENGTH;

    // Set cycle to 30 seconds if in debug
    assert(() {
      _cycleLength = Game.DAY_NIGHT_LENGTH_DEV;
      return true;
    }());

    _cycle = Duration(seconds: _cycleLength);
    widget._timers.dayNightTimer = Timer.periodic(
        Game.ONE_SECOND, _switchCycle);
  }

  /// The image widget to be displayed on the UI
  Widget _getIcon() {
    var cycleImg;
    if (widget._isDayCycle) {
      cycleImg = Image.asset(
        'assets/misc/Sun.png',
        height: 80,
        width: 80,
      );
    } else {
      cycleImg = Image.asset(
        'assets/misc/Moon.png',
        height: 40,
        width: 40,
      );
    }
    return cycleImg;
  }

  void _switchCycle(Timer timer) {
    setState(() {
      if (_cycle == Duration.zero) {
        widget._switchDayNightCycle();
        // TODO: Update with class setter
        if (widget._isDayCycle) {
          Energy.energy = 100;
        }
        _cycle = Duration(seconds: _cycleLength);
      } else {
        _cycle -= Duration(seconds: 1);
      }
    });
  }

  void _skipDay() {
    // Add only 50 energy for skipping day cycle
    // TODO: Update with class setter
    Energy.energy += 50;
    if (Energy.energy > 100) {
      Energy.energy = 100;
    }
    widget._switchDayNightCycle();

    setState(() {
      _cycle = Duration(seconds: _cycleLength);
    });
  }

  Widget _makeText() {
    // Removes 5 extra zeros after seconds.
    format(Duration d) => d.toString().split('.').first.padLeft(0, "0");
    String remainingTime = format(_cycle);

    if (widget._isDayCycle) {
      return Text(
          "Sunset in $remainingTime.\nPress sun to skip to night",
          style: Theme
              .of(context)
              .textTheme
              .body1
              .copyWith(fontSize: 30), textAlign: TextAlign.center);
    } else {
      return Text("Sun rises in $remainingTime",
          style: Theme
              .of(context)
              .textTheme
              .body1);
    }
  }

  /// Toggle button to toggle between day and night cycles.
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
//        margin: EdgeInsets.only(
//            bottom: MediaQuery.of(context).padding.bottom + 25),
        child: Column(
          mainAxisAlignment: widget._isDayCycle
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                onTap: widget._isDayCycle ? _skipDay : null,
                child: _getIcon()),
            _makeText()
          ],
        )
    );
  }
}