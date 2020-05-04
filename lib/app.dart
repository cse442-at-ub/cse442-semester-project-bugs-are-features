import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/models/ghost_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/notification.dart';
import 'screens/ghost.dart';
import 'screens/graveyard.dart';
import 'screens/splash.dart';
import 'widgets/devsettings_button.dart';
import 'widgets/settings_button.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

/// RootPage is the "actual" root widget of the app. See also [_RootPageState].
///
/// This widget renders the two secondary main screens, [GraveyardMain] or the
/// [GhostMain], based upon preference values in SavedPreferences. In particular,
/// if the preferences show [has_ghost] to be `true`, this widget will render
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
  /// The Database instance
  final DB _db = DB();

  /// Displays splash screen when false. True when assets are loaded.
  bool _assetsLoaded = false;

  /// An instance of our ghost, if we have one
  GhostModel _ghost;

  /// Instance of the local notifications builder
  final Notifier _notifier = Notifier();

  /// Instance of app preferences. Is passed to children.
  SharedPreferences _prefs;

  // Create Audio PLayer
  static AudioPlayer player = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  static AudioCache cache = AudioCache(fixedPlayer: player);

  @override
  initState() {
    super.initState();
    _loadAssets();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Display splash screen until assets are loaded.
    if (!_assetsLoaded) {
      return SplashScreen();
    }

    var view = <Widget>[];

    // Set the app-wide background image
    var bg = Image.asset(
      'assets/misc/Graveyard.png',
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.fill,
    );
    view.add(bg);

    Widget screen;
    // Select our main view container.
    var ghostChosen = _prefs.getBool('has_ghost');
    if (ghostChosen) {
      screen = GhostMain(_db, _ghostReleased, _ghost, _notifier);
    } else {
      cache.loop("soundeffects/GraveYard.mp3"); // Plays Background music
      screen = GraveyardMain(_ghostChosen);
    }
    view.add(screen);

    view.add(SettingsButton(_prefs, _ghostReleased));

    // Add Dev Settings button _only_ if in development
    assert(() {
      view.add(DevButton(_prefs, _ghostReleased, _db, _notifier));
      return true;
    }());

    return SafeArea(child: Stack(children: view));
  }

  /// Sets the current ghost via id
  _setGhost(int gid) async {
    _ghost = GhostModel(gid, _db);
    await _ghost.init();
    dev.log("Current ghost ID = $gid", name: "app.init");
  }

  /// For all future image, sound, and startup database calls.
  _loadAssets() async {
    _readPrefs();
    await _db.init();

    int gid = _prefs.getInt('ghost_id');
    if (gid > 0) {
      await _setGhost(gid);
    }
    // Pre-load all images
    precacheImage(AssetImage('assets/misc/Graveyard.png'), context);
    precacheImage(AssetImage('assets/misc/Graveyard2.png'), context);
    precacheImage(AssetImage('assets/misc/GrimReaper.png'), context);
    precacheImage(AssetImage('assets/misc/MainIcon.png'), context);
    precacheImage(AssetImage('assets/misc/Candle.png'), context);
    precacheImage(AssetImage('assets/misc/UnlitCandle.png'), context);
    precacheImage(AssetImage('assets/misc/Sun.png'), context);
    precacheImage(AssetImage('assets/misc/Moon.png'), context);
    precacheImage(AssetImage('assets/ghosts/ghost1.png'), context);
    precacheImage(AssetImage('assets/ghosts/ghost2.png'), context);

    // Hold splash screen.
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _assetsLoaded = true;
    });
  }

  /// Creates our instance of SharedPreferences to pass to children.
  _readPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    // Check if this is our first app launch so we can init preferences.
    if (_prefs.getBool('first_launch') ?? true) {
      _initPrefs();
    }
  }

  /// Initialize all needed preferences at first launch with defaults.
  _initPrefs() {
    // TODO: Delineate all the preferences we'll need.
    _prefs.setBool('first_launch', false);
    _prefs.setBool('has_ghost', false);
    _prefs.setInt('ghost_id', 0);
    _prefs.setString('cycle_value', null);
  }

  /// Call from [GraveyardMain] when a ghost is selected to render [GhostMain].
  _ghostChosen(int id) async {
    player.stop(); // Stops playing Sound Effects when choosen a ghost
    // Returns the amount of rows updated
    int updated = await _db.setGhost(id);
    if (updated != 1) {
      throw Exception('Less than or more than one ghost was chosen.');
    }

    await _setGhost(id);

    setState(() {
      _prefs.setInt('ghost_id', id);
      _prefs.setBool('has_ghost', true);
      _prefs.setString('cycle_value', 'night');
    });
  }

  /// Should only be called from [Settings] when a ghost is released.
  _ghostReleased() async {
    int id = _prefs.getInt('ghost_id');

    if (id == 0) {
      throw Exception('Tried to release a ghost without having one.');
    }

    // Returns the amount of rows updated
    int updated = await _db.unsetGhost(_prefs.getInt('ghost_id'));
    if (updated != 1) {
      throw Exception('Less than or more than one ghost was chosen.');
    }

    setState(() {
      _prefs.setInt('ghost_id', 0);
      _prefs.setBool('has_ghost', false);
      _prefs.setString('cycle_value', null);
    });
  }
}
