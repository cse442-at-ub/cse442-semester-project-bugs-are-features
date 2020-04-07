import 'package:flutter/material.dart';

///Initialize to 100. Is 10 for debugging
int energyInit = 10;

///Increases energy by 5 when the candle is lit
void setEnergyCandleLit(bool isLit){
  if(isLit && ((energyInit + 5) <= 100)){
      energyInit += 5;
      debugPrint("Candle lit: Energy set to $energyInit");
  }
}

/*void checkDonateEnergy(){
  if( ((energyInit - 40) <= 25)){
    energyInit -= 40;
    debugPrint("-40 Energy donated. Energy set to $energyInit");
  }
}*/

///Getters and setters
set energy(int e) {
    energyInit = e;
}

int get energy => energyInit;
