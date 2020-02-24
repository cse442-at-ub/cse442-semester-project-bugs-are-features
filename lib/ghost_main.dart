import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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

  var json;
  var currentState;
  int startState = 0;

  var options = ["Hello", "What is your name?", "Blah", "Foo"];
  var response = ["Hi", "Ghost", "Bloo", "Bar"];
  var btnLinks = [0, 0, 0, 0]; // Set all btn links to state 0
  var btnText = ["Loading...", "Loading...", "Loading...", "Loading..."];
  var currentResponse = "Loading";

  @override
  initState() {
    super.initState();
    rootBundle.loadString("assets/data/DummyData.json").then((data) => {
      setState(() {
        json = jsonDecode(data);
        currentState = json['states'][startState];
        print("Hello : " + currentState['prompt']);
        update();
      })
    });
  }

  void update() {
    for (int i = 0; i < 4; i++) {
      setState(() {
        if (currentState['options'][i]['link'] != null) {
          btnLinks[i] =
              int.parse(currentState['options'][i]['link'].toString());
        } else {
          btnLinks[i] = -1;
        }
        if (currentState['options'][i]['value'] != null) {
          btnText[i] = currentState['options'][i]['value'];
        } else {
          btnText[i] = "";
        }

        currentResponse = currentState['prompt'];
      });
    }
  }

  void buttonHandler(int id) {
    if (btnLinks[id] != -1) {
      setState(() {
        currentState = json['states'][btnLinks[id]];
      });
      update();
    } else {
      print("DONEEEEEEEEEEE");
    }
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
              color: Theme
                  .of(context)
                  .backgroundColor
                  .withOpacity(0.8),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // TODO: Fix the ghost image alignemnt
                Image.asset(
                    "assets/ghosts/ghost${_prefs.getInt("ghost_id").toString()}.png"),
                Text(
                  currentResponse,
                  style: Theme
                      .of(context)
                      .textTheme
                      .body1
                      .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                GridView.count(
                    childAspectRatio: 2,
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
          textColor: Theme
              .of(context)
              .textTheme
              .body1
              .color,
          color: Theme
              .of(context)
              .buttonColor,
          splashColor: Theme
              .of(context)
              .accentColor
              .withOpacity(0.5),
          shape: new ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(32.0)),
          onPressed: () => buttonHandler(id),
          child: Text(
            btnText[id],
            style: TextStyle(fontSize: 20.0),
          ),
        ));
  }
}
