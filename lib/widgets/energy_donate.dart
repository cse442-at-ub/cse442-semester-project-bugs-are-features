import 'package:flutter/material.dart';
import 'package:ghost_app/models/ghost.dart' as GhostModel;
import 'package:ghost_app/models/energy.dart' as Energy;

class EnergyDonate extends StatefulWidget{
  @override
  _EnergyDonateState createState() => _EnergyDonateState();
}

class _EnergyDonateState extends State<EnergyDonate>{
  bool _donate = true;

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

  ///Energy -40
  ///Score +75
  void checkDonateEnergy() async{
    if((Energy.energyInit - 40) >= 0){
      Energy.energy = Energy.energyInit - 40;
      _donate = !_donate;
      debugPrint("-40 Energy donated. Energy set to ${Energy.energyInit}");
    }
    debugPrint("Donation Aborted. Energy < 40");
  }
  

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        margin:
        EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
        child: Column(
          mainAxisAlignment:
          _donate ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                onTap: _donate ? checkDonateEnergy : null, child: _loadImage()
            ),

          ],
        ));
  }

}