import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dev_settings.dart';

class DevButton extends StatelessWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Called as a function when a ghost is chosen.
  final VoidCallback _ghostChosen;

  /// Called as a function when a ghost is released.
  final VoidCallback _ghostReleased;

  DevButton(this._prefs, this._ghostReleased, this._ghostChosen);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: () {
            showGeneralDialog(
              barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                return AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(milliseconds: 350),
                  child: Opacity(
                    opacity: a1.value,
                    child: Center(
                      child: Material(
                        child: DevSettings(_prefs, _ghostReleased, _ghostChosen),
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
          child: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top - 20, right: 70),
            child: FlatButton(
              color: Theme.of(context).buttonColor,
              textColor: Theme.of(context).textTheme.body1.color,
              child: Text("DEV SETTINGS"),
            )
          ),
        ));
  }
}
