import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var response = ["Hi", "Ghost", "Bloo", "Bar"];
  var currentResponse = "Ghost comes here";

  void buttonHandler(int id) {
    setState(() {
      currentResponse = response[id];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            alignment: Alignment.topCenter,
            image: AssetImage("assets/ghost1.png"),
          ),
          Text(
            currentResponse,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.brown,
              fontSize: 42,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text(options[0]),
                color: Colors.red,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
                onPressed: () => buttonHandler(0),
              ),
              RaisedButton(
                onPressed: () => buttonHandler(1),
                child: Text(options[1]),
              ),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () => buttonHandler(2),
                child: Text(options[2]),
              ),
              RaisedButton(
                onPressed: () => buttonHandler(3),
                child: Text(options[3]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
