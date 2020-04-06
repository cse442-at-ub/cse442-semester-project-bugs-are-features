import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghost_app/models/ghost.dart';
import 'package:quiver/async.dart';
import 'package:ghost_app/models/energy.dart' as Energy;

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

//in seconds
const dur = 5;
const interval = 1;

class _CandleState extends State<Candle> {
  /// If the candle is currently lit or not
  bool _isLit = false;

  Timer _timer;
  double _remaining;

  startCandle() {
    _remaining = dur.toDouble();
    _lightCandle();

    Duration time = new Duration(seconds: dur);
    Duration increment = new Duration(seconds: interval);
    CountdownTimer countdownTimer = new CountdownTimer(time, increment);

    var subscribers = countdownTimer.listen(null);
    subscribers.onData((timer) {
      setState(() {
        _remaining -= 1;
      });
    });

    subscribers.onDone(() {
      _extinguishCandle();
      subscribers.cancel();
    });
  }

  /// Lights the candle, rendering the ghost inaccessible
  _lightCandle() async {
    await widget._ghost.setCandleLit(true);
    Energy.setEnergyCandleLit(true); //Increment energy by 5 on lighting candle
    widget._setInteract(false);
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
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset('assets/misc/Candle.png', width: 50.0),
          SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(value: _remaining / dur))
        ],
      );
    } else {
      return GestureDetector(
        onTap: () => startCandle(),
        child: Image.asset('assets/misc/UnlitCandle.png',
            color: Color.fromRGBO(190, 190, 190, 1.0),
            colorBlendMode: BlendMode.modulate,
            width: 50.0),
      );
    }
  }
}
