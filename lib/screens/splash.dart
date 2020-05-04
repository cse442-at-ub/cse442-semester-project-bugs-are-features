import 'package:flutter/material.dart';

/// The Splash Screen that appears when the app first launches.
///
/// This doesn't do anything except display the app logo and name.
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: Text(
          'Ghost App',
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: Theme.of(context).textTheme.body1.copyWith(fontSize: 60.0),
        ));
  }
}
