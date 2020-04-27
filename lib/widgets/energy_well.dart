import 'dart:async';

import 'package:ghost_app/models/ghost_model.dart';
import 'package:ghost_app/models/timers.dart';
import 'package:quiver/async.dart';

import 'package:flutter/material.dart';
import 'package:ghost_app/models/energy.dart' as Energy;
import 'package:ghost_app/models/game.dart' as Game;

class EnergyWell extends StatefulWidget {
  /// Whether or not the user can interact with the ghost
  final bool _canInteract;

  /// Updates the energy on the main screen
  final VoidCallback _updateEnergy;

  /// The current Ghost instances
  final GhostModel _ghost;

  /// The Timers model containing all timers
  final Timers _timers;

  final GlobalKey _key;

  EnergyWell(this._canInteract, this._ghost, this._updateEnergy, this._timers,
      this._key);

  @override
  _EnergyWellState createState() => _EnergyWellState();
}

class _EnergyWellState extends State<EnergyWell> {
  /// Whether or not the user can press this button
  bool _active;

  /// How much score is added from giving energy
  int _scoreIncrease = 15;

  @override
  initState() {
    super.initState();

    if (widget._timers.energyWellTimer != null &&
        widget._timers.energyWellTimer.isActive) {
      _active = true;
      // TODO: Get time left stored in db
    } else {
      _reset();
    }
  }

  ///Gives energy to the ghost if player clicks on the give energy icon.
  ///Player energy: -40
  ///Player score: +75
  _donateEnergy() async {
    int newEnergy = Energy.energy - 40;
    if (newEnergy < 0) {
      return;
    }

    Energy.energy = newEnergy;
    widget._updateEnergy();
    await widget._ghost.addScore(_scoreIncrease);

    setState(() {
      _active = !_active;
      debugPrint("-40 Energy donated. Energy set to ${Energy.energyInit}");
      _startTimer();
    });
  }

  /// Resets states allowing user to hit button again
  _reset() {
    setState(() {
      _active = true;
      widget._timers.resetEnergyWellRemaining();
    });
  }

  /// Called on every tick second of the countdown
  _tick(Timer timer) {
    setState(() {
      widget._timers.energyWellRemaining -= 1;
      if (widget._timers.energyWellRemaining == 0) {
        widget._timers.cancelEnergyWellTimer();
        _reset();
      }
    });
  }

  /// Start the countdown timer for the energy well
  _startTimer() {
    widget._timers.energyWellTimer = Timer.periodic(Game.ONE_SECOND, _tick);
    setState(() {
      _active = false;
    });
  }

  /// Stack widget used to overlay text over image
  Widget _loadImage() {
    var img;
    if (_active) {
      img = Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Image.asset('assets/misc/GiveEnergyFull.png', height: 65, width: 65),
        ],
      );
    } else {
      img = Stack(alignment: Alignment.centerRight, children: <Widget>[
        Image.asset('assets/misc/GiveEnergyEmpty.png', height: 65, width: 65),
        Positioned(
            bottom: 24,
            left: 15,
            right: 15,
            child: Column(
              children: <Widget>[
                Text(
                  widget._timers.energyWellRemaining.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                )
              ],
            ))
      ]);
    }
    return img;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: widget._key,
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                onTap: _active && widget._canInteract ? _donateEnergy : null,
                child: _loadImage()),
          ],
        ));
  }
}
