import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CandleTimer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CandleTimerState();
}

class _CandleTimerState extends State<CandleTimer>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        //TODO find a way to use the same timer as candle
        duration: Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CircularProgressIndicator(value: 1.0 - _controller.value);
  }
}
