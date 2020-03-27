import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:ghost_app/db/db.dart';
import 'package:ghost_app/db/constants.dart' as Constants;

const List<int> LEVEL_POINTS = [0, 10, 20, 40, 80, 160, 320, 640, 1280, 2560, 5120];
/// Returns the current level based upon a given score
int getLevel(int score) {
  if (score >= LEVEL_POINTS[10])      return 10;
  else if (score >= LEVEL_POINTS[9])  return 9;
  else if (score >= LEVEL_POINTS[8])  return 8;
  else if (score >= LEVEL_POINTS[7])  return 7;
  else if (score >= LEVEL_POINTS[6])  return 6;
  else if (score >= LEVEL_POINTS[5])  return 5;
  else if (score >= LEVEL_POINTS[4])  return 4;
  else if (score >= LEVEL_POINTS[3])  return 3;
  else if (score >= LEVEL_POINTS[2])  return 2;
  else if (score >= LEVEL_POINTS[1])  return 1;
  else if (score >= LEVEL_POINTS[0])  return 0;
  else throw Exception('Ghost score is negative!');
}

enum Temperament {
  Friendly,
  Neutral,
  Angry
} // Temperament of the ghost. Friendly: 0, Neutral: 1, Angry: 2

enum Difficulty {
  Easy,
  Med,
  Hard
} // Difficulty. Easy: 0, Medium: 1, Hard: 2


class Ghost {
  /// The current ghost id
  final int _id;

  /// The database instance
  final DB _database;

  /// The ghost's current temperament
  Temperament _temperament;

  /// The ghost's difficulty
  Difficulty _difficulty;

  /// The ghost's name
  String _name;

  /// The ghost's current level
  int _level;

  /// The current score points the player has reached
  int _score;

  /// The ghost's current level progress
  double _progress; // between 0.0 and 1.0

  /// ???
  int _chatOptionScore;

  Ghost(this._id, this._database);

  init() async {
    var maps = await _database.pool.query(
        Constants.GHOST_TABLE,
        columns: null,
        where: '${Constants.GHOST_ID} = ?',
        whereArgs: [id]
    );

    if (maps.length != 1) {
      throw Exception('Querying ghost id `$id` failed: ${maps.length} rows.');
    }

    var map = maps.first;

    _temperament = Temperament.values[map['${Constants.GHOST_TEMPERAMENT}']];
    _name = "Ronaldo";
    _difficulty = Difficulty.values[map['${Constants.GHOST_DIFFICULTY}']];
    _level = map['${Constants.GHOST_LEVEL}'];
    _score = map['${Constants.GHOST_SCORE}'];
    _chatOptionScore = 0;
    print(_level);
  }

  addScore(int score) async {
    _score += score;
    print('Score: $_score, Added pts: $score');

    int checkLevel = getLevel(_score);
    bool leveledUp = _level < checkLevel;
    print('Level: $_level, levelUp: $checkLevel');
    // Check if additional points have leveled us up
    if (leveledUp) {
      dev.log("Leveled up from $_level to $checkLevel", name: "models.ghost");

      _level = checkLevel;
    }

    Map<String, dynamic> columns = {
      Constants.GHOST_SCORE: _score,
      Constants.GHOST_LEVEL: _level
    };

    int cols;
    await _database.pool.update(
        Constants.GHOST_TABLE,
        columns,
        where: '${Constants.GHOST_ID} = ?',
        whereArgs: [_id]
    ).then((colsUpdated) => cols = colsUpdated);

    return cols;
  }

  /// Returns the ghost's id
  int get id => _id;

  /// Returns the ghost's current temperament
  Temperament get temperament => _temperament;
  /// Sets the ghost's current temperament
  set temperament(Temperament t) {
    this._temperament = t;
  }

  /// Returns the ghost's difficulty level
  Difficulty get difficulty => _difficulty;

  /// Returns the ghost's name
  String get name => _name;

  /// Returns the ghost's current level
  int get level => _level;

  /// Gets the ghost's current score
  int get score => _score;

  /// Gets the ghost's progress to the next level
  double get progress {
    int top = _score - LEVEL_POINTS[_level];
    int btm = LEVEL_POINTS[_level + 1] - LEVEL_POINTS[_level];

    return top.toDouble() / btm.toDouble();
  }

  /// Returns the ghost's chat option score
  int get chatOptionScore => _chatOptionScore;

  /// Returns the Image icon of the ghost
  Image get icon => Image.asset("assets/ghosts/ghost$_id.png");
}
