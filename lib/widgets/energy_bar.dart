import 'package:flutter/cupertino.dart';
import 'package:ghost_app/models/energy.dart' as Energy;

class EnergyBar extends StatefulWidget{
  @override
  _EnergyBarState createState() => _EnergyBarState();
}

class _EnergyBarState extends State<EnergyBar>{
  double _energy;

  @override
  void initState(){
    super.initState();
    _energy = Energy.energyInit;
  }

  Widget _makeText() {
    _energy = Energy.energy;
    return Text(
      "Energy:  $_energy",
      style: TextStyle(fontSize: 30),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        margin:
        EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _makeText()
          ],
        ));
  }

}