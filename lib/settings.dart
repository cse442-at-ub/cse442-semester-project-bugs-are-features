import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Settings modal that fades in when the Settings button is pressed.
///
/// This widget is pretty straightforward. The user can changed settings here.
/// This may need to be updated to a StatefulWidget in the future to reflect
/// any settings that a user has changed right away.
class Settings extends StatelessWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Called as a function when a ghost is chosen.
  final VoidCallback _ghostChosen;

  /// Called as a function when a ghost is released.
  final VoidCallback _ghostReleased;

  Settings(this._prefs, this._ghostReleased, this._ghostChosen);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
            maxHeight: 300.0,
            maxWidth: 250.0,
            minWidth: 250.0,
            minHeight: 150.0),
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // TODO: Styling & make dev-only section
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                child: Text(
                  "Settings",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 35.0,
                  ),
                ),
              ),
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {
                  _ghostChosen();
                },
                child: Text("Set has_ghost = true"),
              ),
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {
                  _ghostReleased();
                },
                child: Text("Set has_ghost = false"),
              ),
            ]));
  }
}
