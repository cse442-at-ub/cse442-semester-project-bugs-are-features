import 'package:flutter/cupertino.dart';

double energyInit = 100;

///Sets the energy to 100 when the candle is lit
void setEnergyCandleLit(bool isLit){
  if(isLit){
      energyInit = 100;
      debugPrint("Candle lit: Energy set to $energyInit");
  }
}

///Getters and setters
set energy(double e) {
    energyInit = e;
}

double get energy => energyInit;
