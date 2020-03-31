import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ghost_app/models/ghost.dart';
import 'package:ghost_app/widgets/candle.dart';
import 'package:ghost_app/widgets/cycle_timer.dart';
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
  /// Will only be needed in this widget at the end of the game.
  final VoidCallback _ghostReleased;

  /// The database instance
  final DB _database;

  /// The current ghost instance
  final Ghost _ghost;

  bool _visibility;

  GhostMain(this._prefs, this._ghostReleased, this._database, this._ghost,
      this._visibility);

  @override
  _GhostMainState createState() => _GhostMainState();
}

class _GhostMainState extends State<GhostMain> {
  var _json;
  var _responseObjects = [];
  var _currentResponse = "Loading";

  bool _canInteract = true;

  void _setInteract(bool value) {
    dev.log("Setting canInteract to $value", name: "screens.ghost");
    setState(() {
      _canInteract = value;
    });
  }

  void _loadTwineData() {
    rootBundle
        .loadString("assets/data/Level${widget._ghost.level}.json")
        .then((data) {
      setState(() {
        var random = Random();
        _json = jsonDecode(data);
        var passages = _json["passages"];
        var len = passages.length;
        var ghostResponse = passages[random.nextInt(len)];
        int newLine = ghostResponse["text"].indexOf("\n");
        _currentResponse = newLine != -1
            ? ghostResponse["text"].substring(0, newLine)
            : ghostResponse["text"];
        var start = passages[0];
        var links = start["links"];
        _responseObjects.clear();
        for (var j = 0; j < 4; j++) {
          var i = random.nextInt(links.length - j);
          var message = links[i]["name"];
          int pid = int.parse(links[i]["pid"]);
          int value = int.parse(passages[pid - 1]["tags"][0]);
          Response responseObject = Response(message, pid, value);
          _responseObjects.add(responseObject);
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
    return Visibility(
      visible: widget._visibility,
      child: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).backgroundColor.withOpacity(0.8),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // The ghost image
              widget._ghost.image,
              //_canInteract ? widget._ghost.image : widget._ghost.opaqueImage,

              // The ghost's response
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    _canInteract
                        ? _currentResponse
                        : "The ghost doesn't like the candle",
                    style: Theme.of(context).textTheme.body1.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontStyle: _canInteract
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                    textAlign: TextAlign.center,
                  )),

              // The current progress text + meter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(child: Text("Level ${widget._ghost.level}")),
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
                                value: widget._ghost.progress,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).accentColor,
                                )))
                      ]))
                ],
              ),

              // The candle to be lit, or not
              Candle(widget._ghost, _setInteract),

              // The button responses
              GridView.count(
                  padding: EdgeInsets.all(20),
                  childAspectRatio: 2,
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: List.generate(4, (index) => makeGhostPicker(index)))
            ],
          )
        ],
      ),
    );
  }

  Container makeGhostPicker(int id) {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: RaisedButton(
          textColor: Theme.of(context).textTheme.body1.color,
          color: Theme.of(context).buttonColor,
          splashColor: Theme.of(context).accentColor.withOpacity(0.5),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(32.0)),
          onPressed:
              _canInteract ? () => buttonHandler(_responseObjects[id]) : null,
          child: Text(
            _responseObjects.length == 0
                ? "Loading"
                : _responseObjects[id].response,
            style: TextStyle(fontSize: 20.0),
          ),
        ));
  }

  void _updateProgress(int value) async {
    await widget._ghost.addScore(value);
    // Force a re-draw
    setState(() {});
  }
}
