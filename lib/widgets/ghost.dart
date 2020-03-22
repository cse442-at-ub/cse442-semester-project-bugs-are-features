enum Temperament {
  Friendly,
  Neutral,
  Angry
} //Temperament of the ghost. Friendly: 0, Neutral: 1, Angry: 2

enum Level {
  Easy,
  Med,
  Hard
} //Levels. Easy: 0, Medium: 1, Hard: 2

class Ghost {
  final int id;
  final Temperament temperament;
  final String name;
  final Level level;
  double score; //between 0.0 and 1.0
  int progress;
  final String imageURI;

  final int chatOptionScore;

  Ghost(
      {this.id,
      this.temperament,
      this.name,
      this.level,
      this.score,
      this.progress,
      this.imageURI,
      this.chatOptionScore});

  Map<String, dynamic> toMap() {
    int lvl;
    switch (level) {
      case Level.Easy:
        {
          lvl = 0;
        }
        break;
      case Level.Med:
        {
          lvl = 1;
        }
        break;
      case Level.Hard:
        {
          lvl = 2;
        }
        break;
    }
    return {
      "id": id,
      "temperament": temperament,
      "name": name,
      "difficulty": lvl,
      "progress": progress,
      "score": score,
      //TODO add columns in db for imageURI
    };
  }
}

//Getters and Setters
int get id => id;
set id(int gNo)  => id = gNo;

Temperament get temperament => temperament;
set temperament(Temperament t) => temperament = t;

String get name => name;
set name(String n) => name = n;

Level get level => level;
set level(Level l) => level = l;

int get score => score;
set score(int s) => score = s + chatOptionScore;

int get progress => progress;
set progress(int p) => progress = p;

String get imageURI => imageURI;
set imageURI(String img) => imageURI = img;

int get chatOptionScore => chatOptionScore;
set chatOptionScore(int cos) => chatOptionScore = cos;


