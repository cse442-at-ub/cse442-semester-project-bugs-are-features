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
  final int _id;
  final Temperament _temperament;
  final String _name;
  final Level _level;
  double _score; //between 0.0 and 1.0
  int _progress;
  final String _imageURI;

  final int _chatOptionScore;

  Ghost(this._id,
      this._temperament,
      this._name,
      this._level,
      this._imageURI,
      this._chatOptionScore);

  Map<String, dynamic> toMap() {
    int lvl;
    switch (_level) {
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

    int temp;
    switch (_temperament) {
      case Temperament.Friendly:
        {
          lvl = 0;
        }
        break;
      case Temperament.Neutral:
        {
          lvl = 1;
        }
        break;
      case Temperament.Angry:
        {
          lvl = 2;
        }
        break;
    }

    return {
      "id": _id,
      "temperament": temp,
      "name": _name,
      "difficulty": lvl,
      "progress": _progress,
      "score": _score,
      //TODO add columns in db for imageURI
    };
  }

  //Getters and Setters
  int get id => _id;

  Temperament get temperament => _temperament;

  String get name => _name;

  Level get level => level;

  double get score => _score;

  set score(double increment) => _score += increment;

  int get progress => _progress;

  set progress(int p) => progress = p;

  String get imageURI => _imageURI;

  int get chatOptionScore => _chatOptionScore;
}
