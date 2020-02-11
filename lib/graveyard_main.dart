import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraveyardMain extends StatelessWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Called as a function when a ghost is chosen.
  final VoidCallback _ghostChosen;

  GraveyardMain(this._prefs, this._ghostChosen);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          "GraveyardMain",
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
