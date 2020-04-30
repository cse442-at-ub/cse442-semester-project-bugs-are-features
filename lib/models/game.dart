import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/models/energy.dart';
import 'package:ghost_app/models/ghost_model.dart';
import 'package:ghost_app/models/timers.dart';
import 'package:ghost_app/models/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Contains numerous instances of classes used throughout the app.
class Game {
  /// The database instance
  final DB _db = DB();

  /// The timer's instance
  Timers timers;

  /// The game's current ghost
  GhostModel ghost;

  /// The notification hub
  final Notifier notifier = Notifier();

  /// The app's preferences
  SharedPreferences prefs;

  /// The ghost's energy
  Energy energy;

  /// Called when a ghost is released
  VoidCallback _refresh;

  Game(this._refresh);

  /// Initialize things present regardless of having ghost or not
  init() async {
    // Prefs first
    prefs = await SharedPreferences.getInstance();
    _readPrefs();

    // Connect to db
    await _db.init();

    // Check for ghost
    int gid = prefs.getInt('ghost_id');
    if (gid > 0) {
      ghost = GhostModel(gid, _db);
      await ghost.init();
      dev.log("Current ghost ID = $gid", name: "app.init");
    }
    // Set up energy class
    energy = Energy(_db);
    await energy.init();
  }

  /// Sets the current ghost via id
  setGhost(int gid) async {
    ghost = GhostModel(gid, db);
    await ghost.init();
    dev.log("Current ghost ID = $gid", name: "app.init");
  }

  get db => _db;

  /// Creates our instance of SharedPreferences to pass to children.
  _readPrefs() async {
    // Check if this is our first app launch so we can init preferences.
    if (prefs.getBool('first_launch') ?? true) {
      _initPrefs();
    }
  }

  /// Initialize all needed preferences at first launch with defaults.
  _initPrefs() {
    prefs.setBool('has_ghost', false);
    prefs.setInt('ghost_id', 0);
    prefs.setString('cycle_value', null);
  }

  /// Should only be called from [Settings] when a ghost is released.
  ghostReleased() async {
    int id = prefs.getInt('ghost_id');

    if (id == 0) {
      throw Exception('Tried to release a ghost without having one.');
    }

    // Returns the amount of rows updated
    int updated = await db.unsetGhost(prefs.getInt('ghost_id'));
    if (updated != 1) {
      throw Exception('Less than or more than one ghost was chosen.');
    }

    prefs.setInt('ghost_id', 0);
    prefs.setBool('has_ghost', false);
    prefs.setString('cycle_value', null);

    timers.cancelTimers();
    timers.cancelDayNightTimer();

    _refresh();
  }
}