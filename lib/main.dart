import 'package:flutter/material.dart';

import 'app.dart';

/// Entry-point for the app.
void main() => runApp(App());

/// The base of the app.
///
/// This base widget is kept stateless for simplicity. The colors and styles
/// for our theme are set at this point and contextually passed down to all
/// children widgets. It designates [RootPage] as the home route.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Color.fromRGBO(0x1c, 0x15, 0x1e, 1),
        primaryColor: Color.fromRGBO(0x4a, 0x4c, 0x52, 1),
        buttonColor: Color.fromRGBO(0xa1, 0xa6, 0xb4, 1),
        accentColor: Color.fromRGBO(0xd1, 0xcc, 0xdc, 1),
        textTheme: TextTheme(
            body1: TextStyle(color: Color.fromRGBO(0xf9, 0xf8, 0xf8, 1))),
      ),
      home: Material(child: RootPage()),
    );
  }
}
