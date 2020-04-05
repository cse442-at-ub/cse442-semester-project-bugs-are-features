import 'package:flutter/cupertino.dart';

class EnergyBar extends StatefulWidget{
  @override
  _EnergyBarState createState() => _EnergyBarState();
}

class _EnergyBarState extends State<EnergyBar>{
  double _energy;


  @override
  void initState(){
    super.initState();
    _energy = 100.0;
  }

  void calcEnergyLeft(){
    _energy = _energy - 10.0;
  }

  Widget _makeText() {
    _energy -= 10.0;
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