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
  var currentResponse = "Touch a button to change";

  void buttonHandler(int id) {
    setState(() {
      currentResponse = response[id];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Image.asset(
          'assets/misc/Graveyard.png',
          width: size.width,
          height: size.height,
          fit: BoxFit.fill,
        ),
        Container(
          color: const Color(0xFF0E3311).withOpacity(0.8),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // TODO: Fix the ghost image alignemnt
            Image(
              image: AssetImage(
                  "assets/ghosts/ghost${_prefs.getInt("ghost_id").toString()}.png"),
            ),
            Text(
              currentResponse,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
                fontSize: 20,
              ),
            ),
            GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: List.generate(4, (index) {
                  return makeGhostPicker(index);
                })),
          ],
        )
      ],
    ));
  }

  Container makeGhostPicker(int id) {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          splashColor: Colors.blueAccent,
          shape: new ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(32.0)),
          onPressed: () => buttonHandler(id),
          child: Text(
            options[id],
            style: TextStyle(fontSize: 20.0),
          ),
        ));
  }
}
