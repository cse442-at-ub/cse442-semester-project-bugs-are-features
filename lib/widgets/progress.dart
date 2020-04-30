import 'package:flutter/material.dart';
import 'package:ghost_app/models/game.dart';

/// Displays the user's progress on the main ghost screen.
class Progress extends StatelessWidget {
  /// The Game model instance
  final Game _game;

  Progress(this._game);

  Widget _storyProgress(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
            width: 128,
            child: Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text("Level ${_game.ghost.level - 1}",
                    style: Theme
                        .of(context)
                        .textTheme
                        .body1),
              ),
              // Flexible required because in a row
              Flexible(
                  child: LinearProgressIndicator(
                      backgroundColor: Colors.blueGrey,
                      value: _game.ghost.progress,
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
                child: Text("Energy",
                    style: Theme
                        .of(context)
                        .textTheme
                        .body1),
              ),
              // Flexible required because in a row
              Flexible(
                  child: LinearProgressIndicator(
                      backgroundColor: Color.fromRGBO(110, 0, 0, 1),
                      value: (_game.energy.energy / 100).toDouble(),
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
