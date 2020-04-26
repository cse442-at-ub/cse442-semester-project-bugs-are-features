import 'dart:async';

import 'package:ghost_app/db/db.dart';
import 'package:quiver/async.dart';

class Timers {

  /// The Day/Night cycle timer
  Timer dayNightTimer;

  /// The Candle Timer
  Timer candleTimer;

  /// The Energy Well timer
  CountdownTimer energyWell;

  DB _db;

  Timers(this._db);

  startTimers() {
    Duration interval = Duration(seconds: 1);
  }

  /// Cancels all non-day/night cycle timers
  cancelTimers() {
    candleTimer.cancel();
    candleTimer = null;
    energyWell.cancel();
    energyWell = null;
  }

  storeTimers() {
    // TODO: Store timers on app kill
  }

}