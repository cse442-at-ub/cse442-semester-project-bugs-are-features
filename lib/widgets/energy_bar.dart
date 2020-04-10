import 'package:flutter/material.dart';
import 'package:ghost_app/models/energy.dart' as Energy;

class EnergyBar extends StatefulWidget {
  final VoidCallback _ghostReleased;
  EnergyBar(this._ghostReleased);
  @override
  _EnergyBarState createState() => _EnergyBarState();
}

class _EnergyBarState extends State<EnergyBar> {
  int _energy;

  @override
  void initState() {
    super.initState();
    _energy = Energy.energyInit;
  }

  Widget _makeText() {
    _energy = Energy.energyInit;
    debugPrint(_energy.toString());
    if (_energy <= 0) {
      Energy.resetEnergy();
      _energy = Energy.energyInit;
      widget._ghostReleased();
    }
    return Text(
      "Energy:  $_energy",
      style: TextStyle(fontSize: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_makeText()],
        ));
  }
}
