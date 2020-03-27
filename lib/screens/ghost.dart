import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ghost_app/models/ghost.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../db/db.dart';

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

  /// The database instance
  final DB _database;

  /// The current ghost instance
  final Ghost _ghost;

  GhostMain(this._prefs, this._ghostReleased, this._database, this._ghost);

  @override
  _GhostMainState createState() =>
      _GhostMainState(_prefs, _ghostReleased, _database, _ghost);
}

class _GhostMainState extends State<GhostMain> {

  /// The app wide preferences.
  final SharedPreferences _prefs;

  /// Instance of the current ghost
  Ghost _currentGhost;

  /// The database instance
  final DB _database;

  /// Called as a function when a ghost is released.
  final VoidCallback _ghostReleased;

  var json;
  var currentState;

  /// The level of progression currently attained
  var _currentLevel = 2;

  double _progressValue = 0;
  int startState = 0;

  var responseObjects = [];
  var currentResponse = "Loading";

  _GhostMainState(
      this._prefs, this._ghostReleased, this._database, this._currentGhost);

  void _loadTwineData() {
    rootBundle.loadString("assets/data/Level$_currentLevel.json").then((data) {
      setState(() {
        var random = Random();
        json = jsonDecode(data);
        var passages = json["passages"];
        var len = passages.length;
        var ghostResponse = passages[random.nextInt(len)];
        int newLine = ghostResponse["text"].indexOf("\n");
        currentResponse = newLine != -1
            ? ghostResponse["text"].substring(0, newLine)
            : ghostResponse["text"];
        var start = passages[0];
        var links = start["links"];
        responseObjects.clear();
        for (var j = 0; j < 4; j++) {
          var i = random.nextInt(links.length - j);
          var message = links[i]["name"];
          int pid = int.parse(links[i]["pid"]);
          int value = int.parse(passages[pid - 1]["tags"][0]);
          Response responseObject = Response(message, pid, value);
          responseObjects.add(responseObject);
        }
      });
    });
  }

  @override
  initState() {
    super.initState();
    _loadTwineData();
  }

  void buttonHandler(var response) {
    _updateProgress(response.value);
    _loadTwineData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // The ghost image
            _currentGhost.icon,

            // The ghost's response
            Text(
              currentResponse,
              style: Theme.of(context).textTheme.body1.copyWith(
                  fontSize: 30, fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),

            // The current progress text + meter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                    child: Text("Current Progress (Level $_currentLevel)")),
                Container(
                    width: 128,
                    child: LinearProgressIndicator(
                        value: _progressValue,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor,
                        )))
              ],
            ),

            // The button responses
            GridView.count(
                childAspectRatio: 2,
                shrinkWrap: true,
                crossAxisCount: 2,
                children: List.generate(4, (index) => makeGhostPicker(index))
            )
          ],
        )
      ],
    );
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
          onPressed: () => buttonHandler(responseObjects[id]),
          child: Text(
            responseObjects.length == 0
                ? "Loading"
                : responseObjects[id].response,
            style: TextStyle(fontSize: 20.0),
          ),
        ));
  }

  void _updateProgress(int value) {
    double increasedValue = value * 0.1;
    setState(() {
      _progressValue += increasedValue;
      if (_progressValue >= 1) {
        _progressValue = 0;
        _currentLevel = 3;
      } else if (_progressValue <= 0) {
        _progressValue = 0;
        _currentLevel = 2;
      }
      _database.updateGhost(_currentGhost);
    });
  }
}
