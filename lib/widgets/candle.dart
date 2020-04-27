import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghost_app/models/ghost_model.dart';
import 'package:ghost_app/models/energy.dart';
import 'package:ghost_app/models/game.dart' as Game;
import 'package:ghost_app/models/timers.dart';

/// The Candle class that sets the ghost away to be away, or not
class Candle extends StatefulWidget {
  /// The current ghost instance
  final GhostModel _ghost;

  /// Sets whether or not we can use things on the interface
  final ValueSetter<bool> _setInteract;

  /// The Timers class instances
  final Timers _timers;

  final Energy _energy;

  Candle(this._ghost, this._setInteract, this._timers, this._energy);

  @override
  _CandleState createState() => _CandleState();
}

class _CandleState extends State<Candle> {
  /// If the candle is currently lit or not
  bool _isLit;

  /// The duration remaining
  int _maxDuration;

  @override
  initState() {
    super.initState();

    _maxDuration = Game.CANDLE_LENGTH;

    assert(() {
      _maxDuration = Game.CANDLE_LENGTH_DEV;
      return true;
    }());

    if (widget._timers.candleTimer != null &&
        widget._timers.candleTimer.isActive) {
      _isLit = true;
    } else {
      _isLit = false;
      widget._timers.resetCandleRemaining();
    }
  }

  /// Called on every tick second of the countdown
  _tick(Timer timer) {
    setState(() {
      widget._timers.candleRemaining -= 1;

      if (widget._timers.candleRemaining == 0) {
        _extinguishCandle();
      }
    });
  }

  /// Start the countdown timer for the energy well
  _startTimer() {
    widget._timers.candleTimer = Timer.periodic(Game.ONE_SECOND, _tick);
    _lightCandle();
  }

  /// Lights the candle, rendering the ghost inaccessible
  _lightCandle() async {
    await widget._ghost.setCandleLit(true);
    widget._energy
        .setEnergyCandleLit(true); //Increment energy by 5 on lighting candle
    setState(() {
      _isLit = true;
    });
    widget._setInteract(false);
  }

  /// Extinguishes the candle, allowing the ghost back
  _extinguishCandle() {
    widget._timers.cancelCandleTimer();
    widget._timers.resetCandleRemaining();

    setState(() {
      _isLit = false;
    });

    widget._ghost.setCandleLit(false);
    widget._setInteract(true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLit) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset('assets/misc/Candle.png', width: 50.0),
          SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                  value: widget._timers.candleRemaining / _maxDuration))
        ],
      );
    } else {
      return GestureDetector(
        onTap: () => _startTimer(),
        child: Image.asset('assets/misc/UnlitCandle.png',
            color: Color.fromRGBO(190, 190, 190, 1.0),
            colorBlendMode: BlendMode.modulate,
            width: 50.0),
      );
    }
  }
}
