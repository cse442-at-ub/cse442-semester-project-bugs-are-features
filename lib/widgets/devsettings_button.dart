import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ghost_app/db/db.dart';

import 'devsettings.dart';

/// The Development Settings menu button.
///
/// This button is only visible during development, and scarcely so in the
/// upper left hand corner of the screen. As you might expect, it opens the
/// [DevSettings] widget in a modal.
class DevButton extends StatelessWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// The DB instance.
  final DB _database;

  /// Called as a function when a ghost is released.`
  final VoidCallback _ghostReleased;
  final VoidCallback _showNotification;

  DevButton(
      this._prefs, this._ghostReleased, this._database, this._showNotification);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: FlatButton(
          color: Theme.of(context).buttonColor,
          textColor: Theme.of(context).textTheme.body1.color,
          child: Text(
            "Dev Settings",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            showGeneralDialog(
                barrierColor:
                    Theme.of(context).backgroundColor.withOpacity(0.5),
                transitionBuilder: (context, a1, a2, widget) {
                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 350),
                    child: Opacity(
                      opacity: a1.value,
                      child: Center(
                        child: Material(
                          child: DevSettings(_prefs, _ghostReleased, _database,
                              _showNotification),
                        ),
                      ),
                    ),
                  );
                },
                transitionDuration: Duration(milliseconds: 350),
                barrierDismissible: true,
                barrierLabel: 'Development Settings',
                context: context,
                // pageBuilder isn't needed because we used transitionBuilder
                // However, it's still required by the showGeneralDialog widget
                pageBuilder: (context, animation1, animation2) => null);
          },
        ));
  }
}
