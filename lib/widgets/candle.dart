import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:ghost_app/db/constants.dart' as Constants;
import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/models/ghost.dart';

class Candle extends StatefulWidget {
  /// The database instance
  final DB _database;

  /// The current ghost instance
  final Ghost _ghost;

  /// Sets whether or not we can use things on the interface
  final ValueSetter<bool> _setInteract;

  Candle(this._database, this._ghost, this._setInteract);

  @override
  _CandleState createState() => _CandleState();
}

class _CandleState extends State<Candle> {
  /// If the candle is currently lit or not
  bool _isLit = false;

  /// Lights the candle, rendering the ghost inaccessible
  _lightCandle() async {
    Map<String, String> row = {Constants.GHOST_CANDLE_LIT: 'true'};
    await widget._database.pool.update(
        Constants.GHOST_TABLE,
        row,
        where: '${Constants.GHOST_ID} = ?',
        whereArgs: [widget._ghost.id]
    );
    widget._setInteract(false);

    Duration time = Duration(hours: 1);
    // If we're in debug, just 1 minute
    assert(() {
      time = Duration(minutes: 1);
      return true;
    }());
    Timer(time, _extinguishCandle);

    setState(() {
      _isLit = true;
    });
  }

  /// Extinguishes the candle, allowing the ghost back
  _extinguishCandle() async {
    Map<String, String> row = {Constants.GHOST_CANDLE_LIT: 'false'};
    await widget._database.pool.update(
        Constants.GHOST_TABLE,
        row,
        where: '${Constants.GHOST_ID} = ?',
        whereArgs: [widget._ghost.id]
    );
    widget._setInteract(true);
    // TODO: Send notification here
    setState(() {
      _isLit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLit) {
      //return Image.asset('assets/misc/candle_lit.png'),
      return Text('🕯️');
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