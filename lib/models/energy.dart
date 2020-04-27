import 'package:flutter/material.dart';
import 'package:ghost_app/db/db.dart';

class Energy {
  ///Initialize to 100. Is 90 for debugging
  DB _db;
  int _energy;

  set energy(int e) {
    if (e > 100) {
      e = 100;
    } else if (e < 0) {
      e = 0;
    }
    _energy = e;
    _db.setCurrentEnergy(_energy);
  }

  int get energy {
    return _energy;
  }

  Energy(this._db);

  init() async {
    _energy = await _db.getCurrentEnergy();
    debugPrint("Energy received from DB " + _energy.toString());
  }

  void setEnergyCandleLit(bool isLit) async {
    if (((_energy + 5) <= 100)) {
      _energy += 5;
      _db.setCurrentEnergy(_energy);
      debugPrint("Candle lit: Energy set to $_energy");
    }
  }

  void turnOffCandle() async {
    _energy += _energy >= 100 ? 0 : 5;
    _db.setCurrentEnergy(_energy);
  }

  void resetEnergy() {
    _energy = 100; // 90 for debugging
    _db.setCurrentEnergy(_energy);
  }

  void badResponse() {
    _energy -= 1;
    _db.setCurrentEnergy(_energy);
  }
}
