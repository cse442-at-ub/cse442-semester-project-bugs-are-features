import 'package:flutter/material.dart';
import 'package:ghost_app/models/energy.dart' as Energy;

/// Displays the user's progress on the main ghost screen.
class Progress extends StatelessWidget {
  /// The current progress through the ghost's level
  final double _progress;

  /// The ghost's current level
  final int _level;

  Progress(this._progress, this._level);

  Widget _storyProgress(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
            width: 128,
            child: Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text("Level $_level"),
              ),
              // Flexible required because in a row
              Flexible(
                  child: LinearProgressIndicator(
                      backgroundColor: Colors.blueGrey,
                      value: _progress,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor,
                      )))
            ]))
      ],
    );
  }

  Widget _lifeBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
            width: 128,
            child: Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 17),
                child: Text("Energy"),
              ),
              // Flexible required because in a row
              Flexible(
                  child: LinearProgressIndicator(
                      backgroundColor: Color.fromRGBO(110, 0, 0, 1),
                      value: (Energy.energy / 100).toDouble(),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(255, 0, 0, 1))))
            ]))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(left: MediaQuery.of(context).size.width - 200),
      child: Column(
        children: <Widget>[
          _lifeBar(context),
          SizedBox(height: 10),
          _storyProgress(context)
        ],
      ),
    );
  }
}
