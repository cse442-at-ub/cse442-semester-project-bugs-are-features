import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ghost_main.dart';
import 'graveyard_main.dart';

/// Entry-point for the app.
void main() => runApp(App());

/// The base of the app.
///
/// This base widget is kept stateless for simplicity. The colors and styles
/// for our theme are set that this point and contextually passed down to all
/// children widgets. It designates [RootPage] as the home route.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: Set actual theme colors/styles. These are placeholders.
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.green,
        textTheme: TextTheme(body1: TextStyle(color: Colors.purple)),
      ),
      home: Material(
        child: RootPage()
      ),
    );
  }
}

/// RootPage is the "actual" root widget of the app. See also [_RootPageState].
///
/// This widget renders the two secondary main screens, [GraveyardMain] or the
/// [GhostMain], based upon preference values in SavedPreferences. In particular,
/// if the preferences show [_has_ghost] to be `true`, this widget will render
/// the [GhostMain] container. otherwise it will render [GraveyardMain].
///
/// It also displays a splash screen when the app is opened and is home to the
/// Settings widget, which is displayed persistently on the same layer as
/// [GhostMain] and [GraveyardMain]. This allows it to display a floating Settings
/// widget above either of those two screens.
class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

/// The state widget of [RootPage].
class _RootPageState extends State<RootPage> {
  /// Displays splash screen when false. True when assets are loaded.
  bool _assetsLoaded = false;
  /// Instance of app preferences. Is passed to children.
  SharedPreferences _prefs;
  /// Determines the container rendered.
  bool _hasGhost;

  @override
  Widget build(BuildContext context) {
    // Display splash screen until assets are loaded.
    if (!_assetsLoaded) {
      _loadAssets();

      return Center(
          child: Container(
            // TODO: Replace with an image/set style in theme.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Ghost App',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 60.0,
                  ),
                ),
                // TODO: Remove this button when it's no longer needed.
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _prefs.setBool('has_ghost', true);
                    });
                  },
                  child: Text(
                    "Set has_ghost = true",
                  ),
                ),
              ],
            ),
          ),
      );
    }

    // Select our main view container.
    if (_hasGhost) {
      return GhostMain(_prefs, ghostReleased);
    } else {
      return GraveyardMain(_prefs, ghostChosen);
    }
  }

  _loadAssets() async {
    // Currently the only asset.
    _readPrefs();

    // Hold splash screen.
    Timer(Duration(seconds: 2), () {
      setState(() {
        _assetsLoaded = true;
      });
    });
  }

  _readPrefs() async {
    _prefs = await SharedPreferences.getInstance();

    // Check if this is our first app launch so we can init preferences.
    if (_prefs.getBool('first_launch') ?? true) {
      _initPrefs();
    }

    // Force a re-render to display ghost or graveyard.
    setState(() {
      _hasGhost = _prefs.getBool('has_ghost');
    });
  }

  /// Initialize all needed preferences at first launch with defaults.
  _initPrefs() {
    // TODO: Delineate all the preferences we'll need.
    _prefs.setBool('first_launch', false);
    _prefs.setBool('has_ghost', false);
  }

  /// Call from [GraveyardMain] when a ghost is select to render [GhostMain].
  ghostChosen() {
    setState(() {
      _prefs.setBool('has_ghost', true);
    });
  }

  /// Call from [GhostMain] when a ghost is select to render [GraveyardMain].
  ghostReleased() {
    setState(() {
      _prefs.setBool('has_ghost', false);
    });
  }
}