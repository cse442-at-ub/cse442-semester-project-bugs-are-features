import 'dart:async';

import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/db/constants.dart' as Constants;
import 'package:ghost_app/settings.dart' as Game;

class Timers {

  /// The Day/Night cycle timer
  Timer dayNightTimer;

  /// How much time is remaining for the Day/Night cycle timer
  int dayNightRemaining;

  /// The Candle Timer
  Timer candleTimer;

  /// How much time is remaining for the Candle timer
  int candleRemaining;

  /// The Energy Well timer
  Timer energyWellTimer;

  /// How much time is remaining for the Energy Well timer
  int energyWellRemaining;

  DB _db;

  Timers(this._db);

  startTimers() async {
    var row = await _db.getStoredTimers();
    dayNightRemaining = row[0]['${Constants.GAME_CYCLE_TIMER}'];
    candleTimer = row[0]['${Constants.GAME_CANDLE_TIMER}'];
    energyWellTimer = row[0]['${Constants.GAME_ENERGY_TIMER}'];

    if (candleRemaining == 0) {
      resetCandleRemaining();
    }

    if (energyWellRemaining == 0) {
      resetEnergyWellRemaining();
    }
  }

  /// Resets the candle timer's length to its maximum
  resetCandleRemaining() {
    candleRemaining = Game.CANDLE_LENGTH;

    assert(() {
      candleRemaining = Game.CANDLE_LENGTH_DEV;
      return true;
    }());
  }

  /// Resets the energy well timer's length to its maximum
  resetEnergyWellRemaining() {
    energyWellRemaining = Game.ENERGY_WELL_LENGTH;

    assert(() {
      energyWellRemaining = Game.ENERGY_WELL_LENGTH_DEV;
      return true;
    }());
  }

  /// Cancels all non-day/night cycle timers
  cancelTimers() {
    cancelCandleTimer();
    cancelEnergyWellTimer();
  }

  /// Cancels the energy well timer & sets it to `null`
  cancelEnergyWellTimer() {
    if (energyWellTimer != null) {
      energyWellTimer.cancel();
      energyWellTimer = null;
    }
  }

  /// Cancels the candle timer & sets it to `null`
  cancelCandleTimer() {
    if (candleTimer != null) {
      candleTimer.cancel();
      candleTimer = null;
    }
  }

  /// Cancels the day/night timer & sets it to `null`
  cancelDayNightTimer() {
    if (dayNightTimer != null) {
      dayNightTimer.cancel();
      dayNightTimer = null;
    }
  }

  storeTimers() async {
    await _db.storeTimers(dayNightRemaining, energyWellRemaining,
        candleRemaining);
  }
}