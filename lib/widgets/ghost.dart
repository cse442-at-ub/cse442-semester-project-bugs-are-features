


enum Temperament {Friendly, Neutral, Angry}  //Temperament of the ghost. Friendly: 0, Neutral: 1, Angry: 2
enum Level {Easy, Med, Hard}                 //Levels. Easy: 0, Medium: 1, Hard: 2

class Ghost {

  final Temperament temperament;
  final String name;
  final Level level;
  final int score;
  final double progress; //between 0.0 and 1.0
  final String imageURI;

  Ghost(
      {this.temperament, this.name, this.level, this.score, this.progress, this.imageURI});

}