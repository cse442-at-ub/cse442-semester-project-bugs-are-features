import 'package:flutter/material.dart';
import 'package:ghost_app/models/ghost.dart';
import 'package:ghost_app/db/db.dart';

import 'package:ghost_app/db/constants.dart' as Constants;

/// The Candle class that sets the ghost away to be away, or not
class UserResponses extends StatefulWidget {
  /// The database instance.
  final DB _db;

  /// The current ghost instance
  final Ghost _ghost;

  /// Whether or not the user can currently interact with the ghost
  final bool _canInteract;

  final ValueSetter<String> _setResponse;

  UserResponses(this._db, this._ghost, this._canInteract, this._setResponse);

  @override
  _UserResponsesState createState() => _UserResponsesState();
}

class _UserResponsesState extends State<UserResponses> {
  /// If we're currently in a leveling sequence or not
  bool _leveling = false;

  List<Map> _responses;

  bool _loadingResponses = true;

  @override
  initState() {
    super.initState();
    _getInteractions();
  }

  _stopLeveling() {
    setState(() {
      _leveling = false;
      _loadingResponses = true;
    });
    _getInteractions();
  }
  /// Called when we see that we've leveled up, to do a leveled sequence
  _getLevelingInteraction(int rid) async {
    if (rid == -1) {
      _stopLeveling();
      return;
    }

    setState(() {
      _loadingResponses = true;
    });

    List<Map> ghostResp = await widget._db.getLevelingGhostResp(widget._ghost.id,
        widget._ghost.level, rid);

    if (!_leveling) {
      setState(() {
        _leveling = true;
      });
    }

    // Set ghost's response
    widget._setResponse(ghostResp[0]["${Constants.GHOST_RESP_TEXT}"]);

    String stringRids = ghostResp[0]["${Constants.GHOST_RESP_IDS}"];
    // We're not linking to anything else
    if (stringRids == "") {
      _stopLeveling();
      return;
    }

    List<String> rids = stringRids.split(",");
    // Get the user responses attached to this ghost statement
    var map = <Map>[];
    for (String urid in rids) {
      await widget._db.getLevelingUserResp(widget._ghost.id,
          widget._ghost.level, int.parse(urid))
          .then((row) => map.add(row[0]));
    }
    _responses = map;
    setState(() {
      _loadingResponses = false;
    });
  }

  /// This function is called when a user response button is pressed
  _onPress(int points, String resp, int rid) async {
    bool didLevel = await widget._ghost.addScore(points);
    if (didLevel) {
      _getLevelingInteraction(1);
      return;
    } else if (_leveling) {
      _getLevelingInteraction(rid);
      return;
    }

    widget._setResponse(resp);
    _getInteractions();
  }

  /// Get another set of default interactions
  _getInteractions() async {
    setState(() {
      _loadingResponses = true;
    });

    await widget._db.getDefaultInteraction(widget._ghost.id, 2, 4)
        .then((map) => _responses = map);
    // TODO: Change this when default stuff is added
    //await widget._db.getDefaultInteraction(widget._ghost.id,
    //    widget._ghost.level, 4).then((map) => _responses = map);

    setState(() {
      _loadingResponses = false;
    });
  }

  /// Returns a response button
  createRespButton(String userResp, String ghostResp, int points, int rid) {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: RaisedButton(
          textColor: Theme.of(context).textTheme.body1.color,
          color: Theme.of(context).buttonColor,
          splashColor: Theme.of(context).accentColor.withOpacity(0.5),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(32.0)
          ),
          onPressed: widget._canInteract
              ? _loadingResponses
                  ? null
                  : () => _onPress(points, ghostResp, rid)
              : null,
          child: Text(userResp, style: TextStyle(fontSize: 20.0),
          ),
        )
    );
  }

  /// Creates an empty button for when responses are loading
  createEmptyButton() {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: RaisedButton(
          textColor: Theme.of(context).textTheme.body1.color,
          color: Theme.of(context).buttonColor,
          splashColor: Theme.of(context).accentColor.withOpacity(0.5),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(32.0)
          ),
          onPressed: null,
          child: Text("", style: TextStyle(fontSize: 20.0)),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    var buttons = <Widget>[];

    if (_loadingResponses) {
      List.generate(4, (index) => buttons.add(createEmptyButton()));
    } else if (_leveling) {
      for (var btn in _responses) {
        String userResp = btn["${Constants.USER_RESP_TEXT}"];
        String ghostResp = "";
        int points = btn["${Constants.USER_RESP_POINTS}"];
        int rid = btn["${Constants.USER_RESP_RID}"];
        buttons.add(createRespButton(userResp, ghostResp, points, rid));
      }
    } else {
      for (var btn in _responses) {
        String userResp = btn["${Constants.DEFAULT_RESP_USER}"];
        String ghostResp = btn["${Constants.DEFAULT_RESP_GHOST}"];
        int points = btn["${Constants.DEFAULT_RESP_POINTS}"];
        int rid = 0;
        buttons.add(createRespButton(userResp, ghostResp, points, rid));
      }
    }

    buttons.shuffle();
    // The button responses
    return GridView.count(
        padding: EdgeInsets.all(20),
        childAspectRatio: 2,
        shrinkWrap: true,
        crossAxisCount: 2,
        children: buttons
    );
  }
}