import 'package:flutter/material.dart';
import 'package:ghost_app/models/game.dart';

import 'devsettings.dart';

/// The Development Settings menu button.
///
/// This button is only visible during development, and scarcely so in the
/// upper left hand corner of the screen. As you might expect, it opens the
/// [DevSettings] widget in a modal.
class DevButton extends StatelessWidget {
  /// The Notifier instance
  final Game _game;

  DevButton(this._game);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: FlatButton(
          color: Color.fromRGBO(0, 0, 0, 0.3),
          textColor: Theme.of(context).textTheme.body1.color,
          child: Text(
            "Dev Settings",
            style: Theme
                .of(context)
                .textTheme
                .body1
                .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
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
                          child: DevSettings(_game),
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
