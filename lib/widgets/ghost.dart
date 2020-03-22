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
      this._score,
      this._progress,
      this._imageURI,
      this._chatOptionScore);

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "temperament": _temperament.index,
      "name": _name,
      "difficulty": _level.index,
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
