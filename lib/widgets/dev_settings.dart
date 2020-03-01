import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/db/debug.dart';

/// The Dev Settings modal that fades in when the Dev Settings button is pressed.
///
/// This widget is pretty straightforward. Developers can change settings here.
/// This may need to be updated to a StatefulWidget in the future to reflect
/// any settings that a user has changed right away.
class DevSettings extends StatelessWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// The DB instance.
  final DB _database;

  /// Called as a function when a ghost is released.
  final VoidCallback _ghostReleased;

  DevSettings(this._prefs, this._ghostReleased, this._database);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: 300.0,
          maxWidth: 250.0,
          minWidth: 250.0,
          minHeight: 150.0
      ),
      color: Theme.of(context).backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          // Header Menu Text
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: Text(
              "Dev Settings",
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 35.0)
            ),
          ),

          // Set has_ghost = false
          FlatButton(
            color: Theme.of(context).buttonColor,
            textColor: Theme.of(context).textTheme.body1.color,
            onPressed: () {
              _ghostReleased();
            },
            child: Text("Release ghost"),
          ),

          // Reset Database
          FlatButton(
            color: Theme.of(context).buttonColor,
            textColor: Theme.of(context).textTheme.body1.color,
            onPressed: () {
              _database.debug.printGhostTable();
            },
            child: Text("Print `ghost` table."),
          ),

          // Reset Database
          FlatButton(
            color: Theme.of(context).buttonColor,
            textColor: Theme.of(context).textTheme.body1.color,
            onPressed: () {
              _database.delete();
              _ghostReleased();
            },
            child: Text("!! Reset database !!"),
          ),
        ]
      )
    );
  }
}
