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

  final VoidCallback _ghostReleased;

  Settings(this._prefs, this._ghostReleased);

  @override
  Widget build(BuildContext context) {
    bool pressAttention = false; //toggled when release ghost is pressed

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
          // TODO: Add settings!
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: Text(
              "Settings",
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 35.0)
            ),
          ),

          FlatButton(
            color: pressAttention ? Theme.of(context).buttonColor : Colors.red[700],
            textColor: Theme.of(context).textTheme.body1.color,
            onPressed: () {
              _setState(pressAttention);
              _showAlertOnRelease(context);
            },
            child: Text("Release ghost"),
          ),
        ]
      )
    );
  }

  ///Shows the Alert dialogue on pressing Release ghost
  void _showAlertOnRelease(BuildContext context) {
    // set up the buttons
    Widget noButton =
    FlatButton(
      color: Colors.deepPurple,
      textColor: Colors.white,
      child: Text("No, I miss the ghost."),
      onPressed:  () {
        _closeDialog(context);
      },
    );

    Widget yesButton =
    FlatButton(
      color: Colors.deepPurple,
      textColor: Colors.white,
      child: Text("Yes, Release the ghost"),
      onPressed:  () {
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
  void _setState(bool pressAttention){
    pressAttention = true;
  }

  ///C;oses the dialog
  void _closeDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
