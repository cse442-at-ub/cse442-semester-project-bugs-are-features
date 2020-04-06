import 'package:flutter/material.dart';

/// Displays the user's progress on the main ghost screen.
class Progress extends StatelessWidget {
  /// The current progress through the ghost's level
  final double _progress;

  /// The ghost's current level
  final int _level;

  Progress(this._progress, this._level);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(child: Text("Level $_level")),
        Container(
            width: 128,
            child: Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text("Progress"),
              ),
              // Flexible required because in a row
              Flexible(
                  child: LinearProgressIndicator(
                      backgroundColor: Colors.blueGrey,
                      value: _progress,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor,
                      )
                  )
              )
            ])
        )
      ],
    );
  }
}