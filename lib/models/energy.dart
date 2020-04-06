import 'package:flutter/cupertino.dart';

double energyInit = 90;

///Sets the energy to 100 when the candle is lit
void setEnergyCandleLit(bool isLit){
  if(isLit && ((energyInit + 0.75) <= 100)){
      energyInit += 0.75;
      debugPrint("Candle lit: Energy set to $energyInit");
  }
}

///Getters and setters
set energy(double e) {
    energyInit = e;
}

double get energy => energyInit;
