import 'package:flutter/cupertino.dart';

int energyInit = 90;

///Increases energy by 5 when the candle is lit
void setEnergyCandleLit(bool isLit){
  if(isLit && ((energyInit + 5) <= 100)){
      energyInit += 5;
      debugPrint("Candle lit: Energy set to $energyInit");
  }
}

///Getters and setters
set energy(int e) {
    energyInit = e;
}

int get energy => energyInit;
