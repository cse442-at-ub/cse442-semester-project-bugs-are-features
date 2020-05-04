import 'dart:async';

import 'package:Inspectre/models/game.dart';
import 'package:Inspectre/settings.dart' as Settings;
import 'package:flutter/material.dart';

class EnergyWell extends StatefulWidget {
  /// The Game model instance
  final Game _game;

  /// Whether or not the user can interact with the ghost
  final bool _canInteract;

  /// Refresh the UI
  final VoidCallback _updateEnergy;

  EnergyWell(this._game, this._canInteract, this._updateEnergy);

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

    if (widget._game.timers.energyWellTimer != null &&
        widget._game.timers.energyWellTimer.isActive) {
      _active = true;
      this.widget._game.energy.energy = widget._game.db.getCurrentEnergy();
    } else {
      _reset();
    }
  }

  ///Gives energy to the ghost if player clicks on the give energy icon.
  ///Player energy: -40
  ///Player score: +75
  _donateEnergy() async {
    int newEnergy = widget._game.energy.energy - 40;
    if (newEnergy < 0) {
      return;
    }

    widget._game.energy.energy = newEnergy;
    if (_scoreIncrease == 0) {
      widget._game.energy.energy -= 10;
    }
    await widget._game.ghost.addScore(_scoreIncrease);

    setState(() {
      _active = !_active;
      debugPrint("-40 Energy donated. Energy: ${widget._game.energy.energy}");
      _startTimer();
    });
    widget._updateEnergy();
  }

  /// Resets states allowing user to hit button again
  _reset() {
    setState(() {
      _active = true;
      widget._game.timers.resetEnergyWellRemaining();
    });
  }

  /// Called on every tick second of the countdown
  _tick(Timer timer) {
    setState(() {
      widget._game.timers.energyWellRemaining -= 1;
      if (widget._game.timers.energyWellRemaining == 0) {
        widget._game.timers.cancelEnergyWellTimer();
        _reset();
      }
    });
  }

  /// Start the countdown timer for the energy well
  _startTimer() {
    widget._game.timers.energyWellTimer =
        Timer.periodic(Settings.ONE_SECOND, _tick);
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
                  widget._game.timers.energyWellRemaining.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(fontSize: 15.0),
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
        alignment: Alignment.centerRight,
//        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 60),
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
