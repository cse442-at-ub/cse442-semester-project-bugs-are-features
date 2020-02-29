import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Settings modal that fades in when the Settings button is pressed.
///
/// This widget is pretty straightforward. The user can changed settings here.
/// This may need to be updated to a StatefulWidget in the future to reflect
/// any settings that a user has changed right away.
class DevSettings extends StatelessWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Called as a function when a ghost is chosen.
  final VoidCallback _ghostChosen;

  /// Called as a function when a ghost is released.
  final VoidCallback _ghostReleased;

  DevSettings(this._prefs, this._ghostReleased, this._ghostChosen);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: 300.0,
          maxWidth: 250.0,
          minWidth: 250.0,
          minHeight: 150.0),
      color: Theme.of(context).backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // TODO: Styling & make dev-only section
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: Text(
              "Dev Settings",
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 35.0)
            ),
          ),
          !(_prefs.getBool('has_ghost')) ?
            FlatButton(
              color: Theme.of(context).buttonColor,
              textColor: Theme.of(context).textTheme.body1.color,
              onPressed: () {
                _ghostChosen();
              },
              child: Text("Set has_ghost = true"),
            ) :
            FlatButton(
              color: Theme.of(context).buttonColor,
              textColor: Theme.of(context).textTheme.body1.color,
              onPressed: () {
                _ghostReleased();
              },
              child: Text("Set has_ghost = false"),
            ),
        ]
      )
    );
  }
}
