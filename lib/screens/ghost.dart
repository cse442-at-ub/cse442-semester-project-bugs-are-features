import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/content_target.dart';
import 'package:tutorial_coach_mark/target_focus.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:ghost_app/models/values.dart';

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

  final SharedPreferences _prefs;
  final Energy _energy;

  GhostMain(this._db, this._ghostReleased, this._ghost, this._notifier,
      this._energy, this._prefs);

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
  String _curResp = "...";

  List<TargetFocus> targets = List();
  GlobalKey uiElementsKey = GlobalKey();
  GlobalKey timerKey = GlobalKey();
  GlobalKey ghostResponseKey = GlobalKey();
  GlobalKey userResponseKey = GlobalKey();

  @override
  initState() {
    super.initState();
    _timers = Timers(widget._db);
    initTargets();
    if (widget._prefs.get("ghost_first_select") ?? true) {
      WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    }
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

    view.add(CycleTimer(
        _switchDayNightCycle, _isDayCycle, _timers, widget._energy, timerKey));

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
        // The ghost image
        widget._ghost.image,
        Column(
          key: uiElementsKey,
          children: col,
          crossAxisAlignment: CrossAxisAlignment.center,
        )
      ];

      view.add(Row(
        children: row,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ));

      // The ghost's response to the user
      view.add(GhostResponse(_curResp, _canInteract, ghostResponseKey));

      // The user response buttons
      view.add(UserResponses(widget._db, widget._ghost, _canInteract,
          _setResponse, widget._energy, _updateEnergy, userResponseKey));
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
      Column(children: view, mainAxisAlignment: MainAxisAlignment.center),
    ]);
  }

  void initTargets() {
    targets.add(TargetFocus(
        identify: "Target 1",
        keyTarget: timerKey,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Day/Night Cycle Timer",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        cycleDescription,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
        shape: ShapeLightFocus.RRect));
    targets.add(TargetFocus(
        identify: "Target 2",
        keyTarget: uiElementsKey,
        contents: [
          ContentTarget(
              align: AlignContent.left,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Energy Well, Energy & Progress Bar and Candle",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        uiElementsDescription,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
        shape: ShapeLightFocus.RRect));
    targets.add(TargetFocus(
        identify: "Target 3",
        keyTarget: ghostResponseKey,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Ghost Resonses will be shown here",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        ghostResponseDescription,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
        shape: ShapeLightFocus.RRect));
    targets.add(TargetFocus(
        identify: "Target 4",
        keyTarget: userResponseKey,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Your four available responses are here",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        playerResponseDescription,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
        shape: ShapeLightFocus.RRect));
  }

  void showTutorial() {
    TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.black,
        textSkip: "Skip",
        paddingFocus: 10,
        opacityShadow: 0.9, finish: () {
      print("finished");
      widget._prefs.setBool("ghost_first_select", false);
    })
      ..show();
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      showTutorial();
    });
  }
}
