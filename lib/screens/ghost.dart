import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/models/ghostModel.dart';
import 'package:ghost_app/models/notification.dart';
import 'package:ghost_app/widgets/candle.dart';
import 'package:ghost_app/widgets/cycle_timer.dart';
import 'package:ghost_app/widgets/energy_bar.dart';
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

  GhostMain(this._db, this._ghostReleased, this._ghost, this._notifier);

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
  bool _canInteract = true;
  bool _isDayCycle = false;
  bool _stopTimer = false;
  String _curResp = "";

  ///Add energy widget

  void _setInteract(bool value) {
    dev.log("Setting canInteract to $value", name: "screens.ghost");
    // If setting to CAN'T interact
    if (!value) {
      widget._notifier.disable();
    } else {
      widget._notifier.enable();
    }

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

/*  void _cancelTimer() {
    setState(() {
      _stopTimer = true;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    var view = <Widget>[];

    view.add(CycleTimer(_setDayCycle, _stopTimer, widget._notifier));

    if (!_isDayCycle) {
      var col = <Widget>[];

      // The widget for Energy donation.
      col.add(EnergyBar(widget._ghost));
      // The current progress + health
      col.add(Progress(widget._ghost.progress, widget._ghost.level));
      // The candle to be lit, or not
      col.add(Candle(widget._ghost, _setInteract));
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
