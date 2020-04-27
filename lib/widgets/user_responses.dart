import 'package:flutter/material.dart';
import 'package:ghost_app/db/constants.dart' as Constants;
import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/models/energy.dart';
import 'package:ghost_app/models/ghost_model.dart';

/// The Candle class that sets the ghost away to be away, or not
class UserResponses extends StatefulWidget {
  /// The database instance.
  final DB _db;

  /// The current ghost instance
  final GhostModel _ghost;

  /// Whether or not the user can currently interact with the ghost
  final bool _canInteract;

  final ValueSetter<String> _setResponse;

  final Energy _energy;

  final GlobalKey _userResponseKey;

  final VoidCallback _refresh;

  UserResponses(this._db, this._ghost, this._canInteract, this._setResponse,
      this._energy, this._refresh, this._userResponseKey);

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

    List<Map> ghostResp = await widget._db
        .getLevelingGhostResp(widget._ghost.id, widget._ghost.level, rid);

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
      await widget._db
          .getLevelingUserResp(
              widget._ghost.id, widget._ghost.level, int.parse(urid))
          .then((row) => map.add(row[0]));
    }
    _responses = map;
    setState(() {
      _loadingResponses = false;
    });
  }

  /// This function is called when a user response button is pressed
  _onPress(int points, String resp, int rid, int effect) async {
    // Add negative ghost effect if one is present.
    if (effect < 0) {
      widget._ghost.addEffect(effect);
    }

    bool didLevel = await widget._ghost.addScore(points);
    if (!didLevel) {
      // If Chose wrong
      this.widget._energy.badResponse();
      debugPrint("Called UPDATE ENERGY BAR");
      widget._refresh();
    }
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

    await widget._db
        .getDefaultInteraction(widget._ghost.id, 2, 4)
        .then((map) => _responses = map);
    // TODO: Change this when default stuff is added
    //await widget._db.getDefaultInteraction(widget._ghost.id,
    //    widget._ghost.level, 4).then((map) => _responses = map);

    setState(() {
      _loadingResponses = false;
    });
  }

  /// Returns a response button
  createRespButton(
      String userResp, String ghostResp, int points, int rid, int effect) {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: RaisedButton(
          textColor: Theme.of(context).textTheme.body1.color,
          color: Theme.of(context).buttonColor,
          splashColor: Theme.of(context).accentColor.withOpacity(0.5),
          shape: BeveledRectangleBorder(
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              side: BorderSide(color: Theme.of(context).backgroundColor)),
          onPressed: widget._canInteract
              ? _loadingResponses
                  ? null
                  : () => _onPress(points, ghostResp, rid, effect)
              : null,
          child: Text(
            userResp,
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20.0),
          ),
        ));
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
              borderRadius: BorderRadius.circular(32.0)),
          onPressed: null,
          child: Text("",
              style:
                  Theme.of(context).textTheme.body1.copyWith(fontSize: 20.0)),
        ));
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
        int effect = btn["${Constants.USER_RESP_EFFECT}"];
        int rid = btn["${Constants.USER_RESP_RID}"];
        buttons.add(createRespButton(userResp, ghostResp, points, rid, effect));
      }
    } else {
      for (var btn in _responses) {
        String userResp = btn["${Constants.DEFAULT_RESP_USER}"];
        String ghostResp = btn["${Constants.DEFAULT_RESP_GHOST}"];
        int points = btn["${Constants.DEFAULT_RESP_POINTS}"];
        int rid = 0;
        buttons.add(createRespButton(userResp, ghostResp, points, rid, 0));
      }
    }

    buttons.shuffle();
    // The button responses
    return GridView.count(
        key: widget._userResponseKey,
        padding: EdgeInsets.all(10),
        childAspectRatio: 2,
        shrinkWrap: true,
        crossAxisCount: 2,
        children: buttons);
  }
}
