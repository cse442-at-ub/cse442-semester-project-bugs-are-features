import 'package:flutter/material.dart';
import 'package:ghost_app/models/energy.dart' as Energy;

class EnergyBar extends StatefulWidget{
  @override
  _EnergyBarState createState() => _EnergyBarState();
}

class _EnergyBarState extends State<EnergyBar>{
  int _energy;
  bool _donate;

  @override
  void initState(){
    super.initState();
    _energy = Energy.energyInit;
    _donate = true;
  }


  Widget _loadImage() {
    var _img;
    if (_donate) {
      _img = Image.asset(
        'assets/misc/GiveEnergyFull.png',
        height: 80,
        width: 80,
      );
    } else {
      _img = Image.asset(
        'assets/misc/GiveEnergyEmpty.png',
        height: 40,
        width: 40,
      );
    }
    return _img;
  }

  ///Gives energy to the ghost if player clicks on the give energy icon.
  ///Player energy: -40
  ///Player score: +75
  void checkDonateEnergy() async{
    setState(() {
      if((Energy.energyInit - 40) >= 0){
        Energy.energy = Energy.energyInit - 40; //-40 Energy
        Energy.donate = false;
        _donate = !_donate;
        debugPrint("-40 Energy donated. Energy set to ${Energy.energyInit}");
      }
      else {
        debugPrint("No Energy donated. Energy cant be < 0");
      }
    });
  }

  
  Widget _makeText() {
    setState(() {
      _energy = Energy.energyInit;
      debugPrint(_energy.toString());
    });

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
            _makeText(),
            GestureDetector(
                onTap: _donate ? checkDonateEnergy : null, child: _loadImage()
            ),
          ],
        ));
  }

}