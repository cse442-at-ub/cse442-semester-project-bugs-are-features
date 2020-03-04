import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


enum Temperament {Friendly, Neutral, Angry}  //Temperament of the ghost. Friendly: 0, Neutral: 1, Angry: 2
enum Level {Easy, Med, Hard}                 //Levels. Easy: 0, Medium: 1, Hard: 2

class Ghost extends StatefulWidget{

  final Temperament temperament;
  final String name;
  final Level level;
  final int score;
  final int progress;
  final String image; //path of the image file

  Ghost(this.temperament, this.name, this.level, this.score, this.progress, this.image);

  @override
  _GhostState createState() => _GhostState(this.temperament, this.name, this.level, this.score, this.progress, this.image);
}

class _GhostState extends State<Ghost>{

  final Temperament temperament;
  final String name;
  final Level level;
  final int score;
  final int progress;
  final String image;

  _GhostState(this.temperament, this.name, this.level, this.score, this.progress, this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(image)
    );
  }


}