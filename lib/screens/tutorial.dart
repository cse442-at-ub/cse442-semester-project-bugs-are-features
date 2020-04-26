import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Tutorial extends StatefulWidget {
  final VoidCallback _showHome;

  Tutorial(this._showHome);
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  final introKey = GlobalKey<IntroductionScreenState>();
  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.black,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
        key: introKey,
        pages: [
          PageViewModel(
            title: "Cool App Name here",
            body:
                "Welcome to our amazing app which lets you talk to ghost and other fun stuff!",
            image: _buildImage('assets/ghosts/ghost1.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Your Ghost awaits You...",
            body: "Right after this you will enter a graveyard where" +
                " you would be able to choose your ghost and continue your adventure!",
            image: _buildImage('assets/misc/Graveyard.png'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => widget._showHome(),
        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeColor: Colors.red,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ));
  }

  Widget _buildImage(String assetPath) {
    return Container(
      child: Image.asset(assetPath, width: 350.0),
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(top: 50, bottom: 20),
    );
  }
}
