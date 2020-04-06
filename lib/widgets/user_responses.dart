import 'package:flutter/material.dart';
import 'package:ghost_app/models/ghost.dart';
import 'package:ghost_app/db/db.dart';

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

  /// Called when we see that we've leveled up, to do a leveled sequence
  _startLevel() async {
    List<Map> map = await widget._db.getLevelingGhostResp(widget._ghost.id,
        widget._ghost.level, 1);

    setState(() {
      _leveling = true;
    });
  }

  /// This function is called when a user response button is pressed
  _onPress(int points, String resp) async {
    bool didLevel = await widget._ghost.addScore(points);
    if (didLevel) {
      _startLevel();
    }

    widget._setResponse(resp);
    setState(() {
      _loadingResponses = true;
    });
    _getInteractions();
  }

  /// Get another set of default interactions
  _getInteractions() async {
    await widget._db.getDefaultInteraction(widget._ghost.id,
        widget._ghost.level, 4).then((map) => _responses = map);

    setState(() {
      _loadingResponses = false;
    });
  }

  /// Returns a response button
  createRespButton(String userResp, String ghostResp, int points) {
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
              ? _loadingResponses ? null : () => _onPress(points, ghostResp)
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
    } else {
      for (var btn in _responses) {
        String userResp = btn["user_resp"];
        String ghostResp = btn["ghost_resp"];
        int points = btn["points"];

        buttons.add(createRespButton(userResp, ghostResp, points));
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