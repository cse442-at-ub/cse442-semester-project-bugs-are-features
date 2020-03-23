import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';

class SettingsButton extends StatelessWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;
  final VoidCallback _ghostReleased;

  SettingsButton(this._prefs, this._ghostReleased);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
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
                        child: Settings(_prefs, _ghostReleased),
                      ),
                    ),
                  ),
                );
              },
              transitionDuration: Duration(milliseconds: 350),
              barrierDismissible: true,
              barrierLabel: 'Settings',
              context: context,
              // pageBuilder isn't needed because we used transitionBuilder
              // However, it's still required by the showGeneralDialog widget
              pageBuilder: (context, animation1, animation2) => null);
          },
          child: Container(
            //margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top - 20, right: 60),
            width: 70,
            height: 150,
            child: Image.asset(
              "assets/misc/GrimReaper.png",
              fit: BoxFit.fitHeight,
            ),
          ),
        ));
  }
}
