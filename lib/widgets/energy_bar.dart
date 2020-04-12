import 'package:quiver/async.dart';

import 'package:flutter/material.dart';
import 'package:ghost_app/models/energy.dart' as Energy;
import 'package:ghost_app/models/ghost.dart';

class EnergyBar extends StatefulWidget{
  final Ghost _ghost;
  EnergyBar(this._ghost);
  @override
  _EnergyBarState createState() => _EnergyBarState();
}

class _EnergyBarState extends State<EnergyBar>{
  int _energy;
  bool _donate;
  int _start = 90;
  int _current = 90;
  int _scoreIncrease = 75;
  CountdownTimer countDownTimer;

  @override
  void initState(){
    super.initState();
    _energy = Energy.energyInit;
    _donate = true;
    countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

  }

  @override
  void dispose() {
    super.dispose();
    _destroyTimer();
  }


  //temp function to add score on the current ghost instance
  tempForDonationScore() async {
      await widget._ghost.addScore(_scoreIncrease); //increases score by 75
      debugPrint("+75 Score. Energy donated. Score: ${widget._ghost.score}");
  }

  ///Gives energy to the ghost if player clicks on the give energy icon.
  ///Player energy: -40
  ///Player score: +75
  void checkDonateEnergy() async{
    setState(()  {
      if((Energy.energyInit - 40) >= 0) {
        Energy.energy = Energy.energyInit - 40; //-40 Energy
        tempForDonationScore(); //Add +75 to score
        Energy.donate = false;
        _donate = !_donate;
        debugPrint("-40 Energy donated. Energy set to ${Energy.energyInit}");
        _startTimer(true);
      }
        else{
        debugPrint("No Energy donated. Energy cant be < 0");
      }
    });
  }

  void _startTimer(bool firstStart) {
    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      print("Done");
      _donate = !_donate;
      _current = 90;  //Reset timer
      _start = 90;
      sub.cancel();
    });
  }


  Widget _makeText() {
    setState(() {
      _energy = Energy.energyInit;
      debugPrint(_energy.toString());
    });
    return Text(
      "Energy: $_energy",
      style: TextStyle(fontSize: 25),
    );

  }

  void _destroyTimer() {
    if (countDownTimer != null && countDownTimer.isRunning) {
      countDownTimer.cancel();
    }
  }

  // Stack widget used to overlay text over image
  Widget _loadImage() {
    var _img;
    if (_donate) {
      _img = Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Image.asset('assets/misc/GiveEnergyFull.png', height: 65, width: 65),
        ],
      );
    } else {
      _img = Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Image.asset('assets/misc/GiveEnergyEmpty.png', height: 65, width: 65),
           Positioned(
              bottom: 24,
              left: 15,
              right: 15,
              child: Column(
                children: <Widget>[
                  Text(_current.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 15.0),)
                ],
              )
           )
        ]);

    }
    return _img;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 60),
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