import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/widgets/cycle_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/ghost.dart';
import 'screens/graveyard.dart';
import 'screens/splash.dart';

import 'models/ghost.dart';

import 'widgets/devsettings_button.dart';
import 'widgets/settings_button.dart';

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
  final DB _database = DB();

  /// Displays splash screen when false. True when assets are loaded.
  bool _assetsLoaded = false;

  /// An instance of our ghost, if we have one
  Ghost _ghost;

  /// Instance of the local notifications builder
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  /// Instance of app preferences. Is passed to children.
  SharedPreferences _prefs;

  bool _isDayCycle = false;
  bool _stopTimer = false;

  @override
  initState() {
    super.initState();
    _loadAssets();
    _initNotification();
  }

  @override
  void dispose() {
    _database.close();
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
    var bg = _isDayCycle
        ? Image.asset(
            'assets/misc/Graveyard2.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          )
        : Image.asset(
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
      screen =
          GhostMain(_prefs, _ghostReleased, _database, _ghost, !_isDayCycle);
      // Day/Night cycle switch
    } else {
      screen = GraveyardMain(_prefs, _ghostChosen);
    }
    view.add(screen);

    if (ghostChosen) {
      ///Timer for Day and Night cycle switch
      view.add(CycleTimer(_setDayCycle, _stopTimer));
    }

    if (!_isDayCycle) {
      view.add(SettingsButton(_prefs, _ghostReleased));
    }

    // Add Dev Settings button _only_ if in development
    assert(() {
      view.add(DevButton(_prefs, _ghostReleased, _database, _showNotification));
      return true;
    }());

    return Stack(children: view);
  }

  void _setDayCycle(bool value) {
    setState(() {
      _isDayCycle = value;
    });
  }

  _setGhost(int gid) async {
    _ghost = Ghost(gid, _database);
    await _ghost.init();
    dev.log("Current ghost ID = $gid", name: "app.init");
  }

  /// For all future image, sound, and startup database calls.
  _loadAssets() async {
    _readPrefs();
    await _database.init();

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

  /// Initialize the settings needed to send a notification
  void _initNotification() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, ios);
    _flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  /// Used to specify the page which will open after notification is selected.
  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.maybePop(
      context,
      MaterialPageRoute(builder: (context) => RootPage()),
    );
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
    // Returns the amount of rows updated
    int updated = await _database.setGhost(id);
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
    int updated = await _database.unsetGhost(_prefs.getInt('ghost_id'));
    if (updated != 1) {
      throw Exception('Less than or more than one ghost was chosen.');
    }

    setState(() {
      _isDayCycle = false;
      _prefs.setInt('ghost_id', 0);
      _prefs.setBool('has_ghost', false);
      _prefs.setString('cycle_value', null);
    });
  }

  Future _showNotification() async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DISCRIPTION',
        importance: Importance.Max, priority: Priority.High, playSound: false);
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android, ios);
    await _flutterLocalNotificationsPlugin.show(
        0, "Ghost is calling you!", null, platform);
  }

  Future _hideNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
  }

  void _cancelTimer() {
    setState(() {
      _stopTimer = true;
    });
  }
}
