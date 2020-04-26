import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/models/notification.dart';

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

  /// The Notifier instance
  final Notifier _notifier;

  DevSettings(
      this._prefs,
      this._ghostReleased,
      this._database,
      this._notifier,
  );

  @override
  Widget build(BuildContext context) {
    bool pressAttention = false; //toggled when release ghost is pressed
    int ghostId = _prefs.getInt('ghost_id');

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
              // Header Menu Text
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                child: Text("Dev Settings",
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontSize: 35.0)),
              ),

              // Set has_ghost = false
              Visibility(
                visible: ghostId == 0 ? false : true,
                child: FlatButton(
                  color: pressAttention
                      ? Theme.of(context).buttonColor
                      : Colors.red[700],
                  textColor: Theme.of(context).textTheme.body1.color,
                  onPressed: () {
                    _setState(pressAttention);
                    _showAlertOnRelease(context);
                  },
                  child: Text("Release ghost"),
                ),
              ),

              // Print Database
              FlatButton(
                color: Theme.of(context).buttonColor,
                textColor: Theme.of(context).textTheme.body1.color,
                onPressed: () {
                  _database.debug.printGhostTable();
                },
                child: Text("Print `ghost` table."),
              ),

              // Print Game State Table
              FlatButton(
                color: Theme.of(context).buttonColor,
                textColor: Theme.of(context).textTheme.body1.color,
                onPressed: () {
                  _database.debug.printGameTable();
                },
                child: Text("Print game state table."),
              ),

              // Reset Database
              FlatButton(
                color: Theme.of(context).buttonColor,
                textColor: Theme.of(context).textTheme.body1.color,
                onPressed: () {
                  _ghostReleased();
                  _database.delete();
                },
                child: Text("!! Reset database !!"),
              ),

              FlatButton(
                color: Theme.of(context).buttonColor,
                textColor: Theme.of(context).textTheme.body1.color,
                onPressed: () => _notifier.testNotification(),
                child: Text("Show Notification"),
              ),

              FlatButton(
                color: Theme.of(context).buttonColor,
                textColor: Theme.of(context).textTheme.body1.color,
                onPressed: () => null,
                child: Text("Stop Day/Night Cycle"),
              )
            ]));
  }

  ///Shows the Alert dialogue on pressing Release ghost
  void _showAlertOnRelease(BuildContext context) {
    // set up the buttons
    Widget noButton = FlatButton(
      color: Colors.deepPurple,
      textColor: Colors.white,
      child: Text("No, I miss the ghost."),
      onPressed: () {
        _closeDialog(context);
      },
    );

    Widget yesButton = FlatButton(
      color: Colors.deepPurple,
      textColor: Colors.white,
      child: Text("Yes, Release the ghost"),
      onPressed: () {
        _ghostReleased();
        _closeDialog(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      backgroundColor: Colors.purple,
      content: Text("Are you sure you wanna release the ghost?"),
      actions: [
        noButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ///set state of presAttention to true when Release ghost is pressed.
  void _setState(bool pressAttention) {
    pressAttention = true;
  }

  ///Closes the dialog
  void _closeDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
