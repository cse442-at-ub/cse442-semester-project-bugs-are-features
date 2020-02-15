import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ghost_app/ghost_button.dart';

class GhostMain extends StatefulWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Called as a function when a ghost is released.
  final VoidCallback _ghostReleased;
  GhostMain(this._prefs, this._ghostReleased);

  @override
  _GhostMainState createState() => _GhostMainState(_prefs, _ghostReleased);
}

class _GhostMainState extends State<GhostMain> {
  _GhostMainState(this._prefs, this._ghostReleased);

  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Called as a function when a ghost is released.
  final VoidCallback _ghostReleased;

  var options = ["Hello", "What is your name?", "Blah", "Foo"];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 180),
        child: Column(
          children: <Widget>[
            Button(options[0]),
            Button(options[1]),
            Button(options[2]),
            Button(options[3]),
          ],
        ),
        /*        
        child: Text(
          "GhostMain",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 60.0,
          ),
          */
      ),
    );
  }
  /*
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  */
}
