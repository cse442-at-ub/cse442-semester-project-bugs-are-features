import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/models/ghost.dart';

/// The Candle class that sets the ghost away to be away, or not
class Candle extends StatefulWidget {
  /// The current ghost instance
  final Ghost _ghost;

  /// Sets whether or not we can use things on the interface
  final ValueSetter<bool> _setInteract;

  Candle(this._ghost, this._setInteract);

  @override
  _CandleState createState() => _CandleState();
}

class _CandleState extends State<Candle> {
  /// If the candle is currently lit or not
  bool _isLit = false;

  Timer _timer;

  /// Lights the candle, rendering the ghost inaccessible
  _lightCandle() async {
    await widget._ghost.setCandleLit(true);
    widget._setInteract(false);

    Duration time = Duration(hours: 1);
    // If we're in debug, just 1 minute
    assert(() {
      time = Duration(minutes: 1);
      return true;
    }());
    _timer = Timer(time, _extinguishCandle);

    setState(() {
      _isLit = true;
    });
  }

  /// Extinguishes the candle, allowing the ghost back
  _extinguishCandle() async {
    await widget._ghost.setCandleLit(false);
    widget._setInteract(true);
    // TODO: Send notification here
    setState(() {
      _isLit = false;
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLit) {
      return Image.asset('assets/misc/Candle.png', width: 50.0);
    } else {
      return GestureDetector(
        onTap: () => _lightCandle(),
        //child: Image.asset('assets/misc/candle_unlit.png'),
        child: Text(
            '<Light Candle>',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            )
        ),
      );
    }
  }

}