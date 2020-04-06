import 'package:flutter/cupertino.dart';

int energyInit = 90;


  void setEnergyCandleLit(bool isLit){
    if(isLit){
      energyInit = 100;
      debugPrint("Candle lit: Energy set to $energyInit");
    }
  }

  set energy(int e) {
    energyInit = e;
  }
  int get energy => energyInit;
