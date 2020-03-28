import 'dart:async';
import 'dart:math' as Math;

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

class _CandleState extends State<Candle>
    with TickerProviderStateMixin {
  /// If the candle is currently lit or not
  bool _isLit = false;

  Timer _timer;

  //Adapted from https://medium.com/flutterdevs/creating-a-countdown-timer-using-animation-in-flutter-2d56d4f3f5f1
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        //TODO find a way to use the same timer as candle
        duration: Duration(seconds: 10));
  }

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
      time = Duration(seconds: 5);
      return true;
    }());
    _timer = Timer(time, _extinguishCandle);

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
  void dispose() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLit) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return CustomPaint(
            painter: CandlePainter(
                animation: _controller,
                backgroundColor: Colors.white,
                color: Theme
                    .of(context)
                    .indicatorColor
            ),
          );
        },
      );
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

class CandlePainter extends CustomPainter {
  CandlePainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);

    paint.color = color;
    double prgs = (1.0 - animation.value) * 2 * Math.pi;
    canvas.drawArc(Offset.zero & size, Math.pi * 1.5, -prgs, false, paint);
  }

  @override
  bool shouldRepaint(CandlePainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}