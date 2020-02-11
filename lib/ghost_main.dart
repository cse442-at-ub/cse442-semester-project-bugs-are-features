import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GhostMain extends StatelessWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Called as a function when a ghost is released.
  final VoidCallback _ghostReleased;

  GhostMain(this._prefs, this._ghostReleased);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          "GhostMain",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 60.0,
          ),
        ),
      ),
    );
  }
}
