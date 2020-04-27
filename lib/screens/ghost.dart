import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/models/energy.dart';
import 'package:ghost_app/models/ghost_model.dart';
import 'package:ghost_app/models/notification.dart';
import 'package:ghost_app/models/timers.dart';
import 'package:ghost_app/widgets/candle.dart';
import 'package:ghost_app/widgets/cycle_timer.dart';
import 'package:ghost_app/widgets/energy_well.dart';
import 'package:ghost_app/widgets/ghost_response.dart';
import 'package:ghost_app/widgets/progress.dart';
import 'package:ghost_app/widgets/user_responses.dart';

class GhostMain extends StatefulWidget {
  /// Called as a function when a ghost is released.
  /// Will only be needed in this widget at the end of the game.
  final VoidCallback _ghostReleased;

  /// The current ghost instance
  final GhostModel _ghost;

  /// The database instance.
  final DB _db;

  /// The Notifier notifications instances
  final Notifier _notifier;

  final Energy _energy;

  GhostMain(
      this._db, this._ghostReleased, this._ghost, this._notifier, this._energy);

  @override
  _GhostMainState createState() => _GhostMainState();

  /*
   * below is temp code for getting rid the unused
   * _ghostReleased analysis error
   * TODO delete the debugFillProperties method after using _ghostReleased
   */

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        ObjectFlagProperty<VoidCallback>.has('_ghostReleased', _ghostReleased));
  }

//delete above
}

class _GhostMainState extends State<GhostMain> {
  /// The Timers instance
  Timers _timers;

  /// Whether or not the user can interact with the ghost
  bool _canInteract = true;

  /// Whether or not the current day/night cycle is day
  bool _isDayCycle = false;

  /// The ghost's current response to the user
  String _curResp = "";

  @override
  initState() {
    super.initState();
    _timers = Timers(widget._db);
  }

  @override
  dispose() {
    _timers.storeTimers();
    super.dispose();
  }

  ///Add energy widget
  void _setInteract(bool value) {
    dev.log("Setting canInteract to $value", name: "screens.ghost");
    // If setting to CAN'T interact
    if (!value) {
      widget._notifier.disable();
    } else {
      // Once candle lights off
      widget._energy.turnOffCandle();
      this._updateEnergy();
      widget._notifier.enable();
    }

    setState(() {
      _canInteract = value;
    });
  }

  /// Sets the ghost's response to the user
  void _setResponse(String resp) async {
    setState(() {
      _curResp = resp;
    });
  }

  /// Sets whether it's day or not
  void _switchDayNightCycle() {
    setState(() {
      //_energy = _energy.energy;        UPDATESDDDDD
      _isDayCycle = !_isDayCycle;
      _curResp = "";
      _canInteract = true;
    });

    if (_isDayCycle) {
      widget._notifier.dayNotification();
      // Cancel all non-day/night timers
      _timers.cancelTimers();
    } else {
      widget._notifier.nightNotification();
    }
  }

  /// Update's the user's energy
  void _updateEnergy() {
    setState(() {
      if (widget._energy.energy <= 0) {
        widget._energy.resetEnergy();
        widget._ghostReleased();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var view = <Widget>[];
    view.add(
        CycleTimer(_switchDayNightCycle, _isDayCycle, _timers, widget._energy));

    if (!_isDayCycle) {
      var col = <Widget>[];

      // The widget for Energy donation.
      col.add(EnergyWell(_canInteract, widget._ghost, widget._energy, _timers,
          widget._db, _updateEnergy));
      // The current progress + health
      col.add(Progress(
          widget._ghost.progress, widget._ghost.level, widget._energy));
      // The candle to be lit, or not
      col.add(Candle(widget._ghost, _setInteract, _timers, widget._energy));
      var row = <Widget>[
        widget._ghost.image,
        Column(
          children: col,
          crossAxisAlignment: CrossAxisAlignment.center,
        )
      ];
      // The ghost image
      view.add(Row(
        children: row,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ));
      // The ghost's response to the user
      view.add(GhostResponse(_curResp, _canInteract));

      // The user response buttons
      view.add(UserResponses(widget._db, widget._ghost, _canInteract,
          _setResponse, widget._energy, _updateEnergy));
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
