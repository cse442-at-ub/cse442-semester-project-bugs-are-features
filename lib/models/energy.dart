import 'package:flutter/material.dart';

///Initialize to 100. Is 90 for debugging
int energyInit = 90;
bool donateEnergy;

///Increases energy by 5 when the candle is lit
void setEnergyCandleLit(bool isLit) {
  if (((energyInit + 5) <= 100)) {
    energyInit += 5;
    debugPrint("Candle lit: Energy set to $energyInit");
  } else {
    debugPrint("Donation Aborted. Energy < 40");
  }
}

void resetEnergy() {
  energyInit = 5; // 5 for debugging
}

///Getters and setters
set energy(int e) {
  energyInit = e;
}

set donate(bool d) {
  donateEnergy = d;
}

int get energy => energyInit;
bool get donate => donateEnergy;
