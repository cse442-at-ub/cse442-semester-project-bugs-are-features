import 'dart:async';

import 'package:Inspectre/models/game.dart';
import 'package:Inspectre/screens/tutorial.dart';
import 'package:flutter/material.dart';

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
  /// Displays splash screen when false. True when assets are loaded.
  bool _assetsLoaded = false;

  /// The game instance containing most of our important models/classes
  Game _game;

  // Create Audio PLayer
  static AudioPlayer player = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  static AudioCache cache = AudioCache(fixedPlayer: player);

  @override
  initState() {
    super.initState();
    _game = Game(_refresh);
    _loadAssets();
  }

  @override
  void dispose() {
    _game.db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Display splash screen until assets are loaded.
    if (!_assetsLoaded) {
      return SplashScreen();
    }

    if (_game.prefs.getBool('first_launch') ?? true) {
      return Tutorial(_showHome);
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
    var ghostChosen = _game.prefs.getBool('has_ghost');
    if (ghostChosen) {
      screen = GhostMain(_game);
    } else {
      cache.loop("soundeffects/GraveYard.mp3"); // Plays Background music
      screen = GraveyardMain(_ghostChosen);
    }
    view.add(screen);

    view.add(SettingsButton(_game));

    // Add Dev Settings button _only_ if in development
    assert(() {
      view.add(DevButton(_game));
      return true;
    }());

    return SafeArea(child: Stack(children: view));
  }

  /// For all future image, sound, and startup database calls.
  _loadAssets() async {
    await _game.init();

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

  _showHome() {
    setState(() {
      _game.prefs.setBool('has_ghost', false);
      _game.prefs.setBool('first_launch', false);
    });
  }

  /// Call from [GraveyardMain] when a ghost is selected to render [GhostMain].
  _ghostChosen(int id) async {
    player.stop(); // Stops playing Sound Effects when choosen a ghost
    // Returns the amount of rows updated
    int updated = await _game.db.setGhost(id);
    if (updated != 1) {
      throw Exception('Less than or more than one ghost was chosen.');
    }

    await _game.setGhost(id);

    setState(() {
      _game.prefs.setInt('ghost_id', id);
      _game.prefs.setBool('has_ghost', true);
      _game.prefs.setString('cycle_value', 'night');
    });
  }

  /// Should only be called from [Settings] when a ghost is released.
  _refresh() async {
    setState(() {});
  }
}
