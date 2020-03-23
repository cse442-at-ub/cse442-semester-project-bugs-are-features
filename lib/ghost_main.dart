import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ghost_app/widgets/ghost.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'db/db.dart';

class Response {
  final String response;
  final int pid;
  final int value;

  Response(this.response, this.pid, this.value);
}

class GhostMain extends StatefulWidget {
  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Called as a function when a ghost is released.
  final VoidCallback _ghostReleased;

  final DB _database;

  GhostMain(this._prefs, this._ghostReleased, this._database);

  @override
  _GhostMainState createState() =>
      _GhostMainState(_prefs, _ghostReleased, _database);
}

class _GhostMainState extends State<GhostMain> {
  _GhostMainState(this._prefs, this._ghostReleased, this._database);

  /// The app wide preferences.
  final SharedPreferences _prefs;
  Ghost currentGhost;
  final DB _database;

  /// Called as a function when a ghost is released.
  final VoidCallback _ghostReleased;

  var json;
  var currentState;
  double _progressValue = 0;
  int startState = 0;

  var options = ["Hello", "What is your name?", "Blah", "Foo"];
  var response = ["Hi", "Ghost", "Bloo", "Bar"];
  var btnLinks = [0, 0, 0, 0]; // Set all btn links to state 0
  var btnText = ["Loading...", "Loading...", "Loading...", "Loading..."];
  var respObjects = [];
  var currentResponse = "Loading";

  void _loadDummyData() {
    rootBundle.loadString("assets/data/DummyData.json").then((data) {
      json = jsonDecode(data);
      currentState = json['states'][startState];
      print("Hello : " + currentState['prompt']);
      update();
    });
  }

  void _loadDatabase() {
    _database.getGhost(_prefs.getInt('ghost_id')).then((dbGhost) {
      print("current id of ghost = " + _prefs.getInt('ghost_id').toString());
      currentGhost = dbGhost;
      print("Ghost is called " + currentGhost.name);
    });
  }

  void _loadTwineData() {
    rootBundle.loadString("assets/data/Twine.json").then((data) {
      setState(() {
        json = jsonDecode(data);
        var passages = json["passages"];
        var start = passages[0];
        int newLine = start["text"].indexOf("\n");
        currentResponse = start["text"].substring(0, newLine);
        var links = start["links"];
        for (var i = 0; i < links.length; i++) {
          var message = links[i]["name"];
          int pid = int.parse(links[i]["pid"]);
          int value = int.parse(passages[pid - 1]["tags"][0]);
          Response responseObject = Response(message, pid, value);
          respObjects.add(responseObject);
        }
      });
    });
  }

  @override
  initState() {
    print("Init");
    super.initState();
    _loadDatabase();
    _loadTwineData();
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

  void buttonHandler(var response) {
    _updateProgress(response.value);
    // if (btnLinks[id] != -1) {
    //   setState(() {
    //     currentState = json['states'][btnLinks[id]];
    //   });
    //   update();
    // } else {
    //   _ghostReleased == _ghostReleased
    //       ? print("a")
    //       : print("b"); //temp code for analysis clearing up
    //   print("DONEEEEEEEEEEE");
    // }
  }

  @override
  Widget build(BuildContext context) {
    print("Now Building");
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
          color: Theme.of(context).backgroundColor.withOpacity(0.8),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // TODO: Fix the ghost image alignemnt
            Image.asset(
                "assets/ghosts/ghost${_prefs.getInt("ghost_id").toString()}.png"),
            Text(
              currentResponse,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(child: Text("Current Progress")),
                Container(
                    width: 128,
                    child: LinearProgressIndicator(
                        value: (currentGhost != null) ? _progressValue : .0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor,
                        )))
              ],
            ),
            GridView.count(
                childAspectRatio: 2,
                shrinkWrap: true,
                crossAxisCount: 2,
                children: List.generate(4, (index) {
                  return makeGhostPicker(index);
                }))
          ],
        )
      ],
    ));
  }

  Container makeGhostPicker(int id) {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: RaisedButton(
          textColor: Theme.of(context).textTheme.body1.color,
          color: Theme.of(context).buttonColor,
          splashColor: Theme.of(context).accentColor.withOpacity(0.5),
          shape: new ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(32.0)),
          onPressed: () => buttonHandler(respObjects[id]),
          child: Text(
            respObjects.length == 0 ? "Loading" : respObjects[id].response,
            style: TextStyle(fontSize: 20.0),
          ),
        ));
  }

  void _updateProgress(int value) {
    double increasedValue = value * 0.1;
    setState(() {
      _progressValue += increasedValue;
      if (_progressValue > 1) {
        _progressValue = 0;
      }
    });
  }
}
