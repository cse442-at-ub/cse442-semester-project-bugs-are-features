import 'package:flutter/material.dart';

///Initialize to 100. Is 10 for debugging
int energyInit = 10;
bool donateEnergy;

///Increases energy by 5 when the candle is lit
void setEnergyCandleLit(bool isLit){
  if(isLit && ((energyInit + 5) <= 100)){
      energyInit += 5;
      debugPrint("Candle lit: Energy set to $energyInit");
  }
  debugPrint("Donation Aborted. Energy < 40");
}

///Getters and setters
set energy(int e) {
    energyInit = e;
}

set donate(bool d){
  donateEnergy = d;
}

int get energy => energyInit;
bool get donate => donateEnergy;
