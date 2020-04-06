import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/models/ghost.dart';
import 'package:ghost_app/widgets/candle.dart';
import 'package:ghost_app/widgets/cycle_timer.dart';
import 'package:ghost_app/widgets/ghost_response.dart';
import 'package:ghost_app/widgets/progress.dart';
import 'package:ghost_app/widgets/user_responses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GhostMain extends StatefulWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Called as a function when a ghost is released.
  /// Will only be needed in this widget at the end of the game.
  final VoidCallback _ghostReleased;

  /// The current ghost instance
  final Ghost _ghost;

  /// The database instance.
  final DB _db;

  GhostMain(this._prefs, this._db, this._ghostReleased, this._ghost);

  @override
  _GhostMainState createState() => _GhostMainState();
}

class _GhostMainState extends State<GhostMain> {
  bool _canInteract = true;
  bool _isDayCycle = false;
  bool _stopTimer = false;
  String _curResp = "";

  void _setInteract(bool value) {
    dev.log("Setting canInteract to $value", name: "screens.ghost");
    setState(() {
      _canInteract = value;
    });
  }

  void _setResponse(String resp) async {
    setState(() {
      _curResp = resp;
    });
  }

  @override
  initState() {
    super.initState();
  }

  void _setDayCycle(bool value) {
    setState(() {
      _isDayCycle = value;
    });
  }

  void _cancelTimer() {
    setState(() {
      _stopTimer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var view = <Widget>[];
    if (!_isDayCycle) {
      // The current progress + health
      view.add(Progress(widget._ghost.progress, widget._ghost.level));
    }
    view.add(CycleTimer(_setDayCycle, _stopTimer));

    if (!_isDayCycle) {
      // The ghost image
      view.add(widget._ghost.image);
      // The ghost's response to the user
      view.add(GhostResponse(_curResp, _canInteract));
      // The candle to be lit, or not
      view.add(Candle(widget._ghost, _setInteract));
      // The user response buttons
      view.add(
          UserResponses(widget._db, widget._ghost, _canInteract, _setResponse));
    }

    return Stack(children: <Widget>[
      _isDayCycle
          ? Image.asset(
              'assets/misc/Graveyard2.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            )
          : Container(
              color: Theme.of(context).backgroundColor.withOpacity(0.8)),

      // The main elements of the view
      Column(
          children: view,
          mainAxisAlignment:
              _isDayCycle ? MainAxisAlignment.center : MainAxisAlignment.end),
    ]);
  }
}
