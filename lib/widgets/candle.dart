import 'dart:async';

import 'package:Inspectre/models/game.dart';
import 'package:Inspectre/settings.dart' as Settings;
import 'package:flutter/material.dart';

/// The Candle class that sets the ghost away to be away, or not
class Candle extends StatefulWidget {
  /// The Game model instance
  final Game _game;
  /// Sets whether or not we can use things on the interface
  final ValueSetter<bool> _setInteract;

  Candle(this._game, this._setInteract);

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

    _maxDuration = Settings.CANDLE_LENGTH;

    assert(() {
      _maxDuration = Settings.CANDLE_LENGTH_DEV;
      return true;
    }());

    if (widget._game.timers.candleTimer != null &&
        widget._game.timers.candleTimer.isActive) {
      _isLit = true;
    } else {
      _isLit = false;
      widget._game.timers.resetCandleRemaining();
    }
  }

  /// Called on every tick second of the countdown
  _tick(Timer timer) {
    setState(() {
      widget._game.timers.candleRemaining -= 1;

      if (widget._game.timers.candleRemaining == 0) {
        _extinguishCandle();
      }
    });
  }

  /// Start the countdown timer for the energy well
  _startTimer() {
    widget._game.timers.candleTimer = Timer.periodic(Settings.ONE_SECOND, _tick);
    _lightCandle();
  }

  /// Lights the candle, rendering the ghost inaccessible
  _lightCandle() async {
    await widget._game.ghost.setCandleLit(true);
    // Increment energy by 5 on lighting candle
    widget._game.energy.setEnergyCandleLit(true);
    setState(() {
      _isLit = true;
    });
    widget._setInteract(false);
  }

  /// Extinguishes the candle, allowing the ghost back
  _extinguishCandle() {
    widget._game.timers.cancelCandleTimer();
    widget._game.timers.resetCandleRemaining();

    setState(() {
      _isLit = false;
    });

    widget._game.ghost.setCandleLit(false);
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
                  value: widget._game.timers.candleRemaining / _maxDuration
              )
          )
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
