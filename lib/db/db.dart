import 'dart:developer' as dev;

import 'package:ghost_app/db/debug.dart';
import 'package:ghost_app/widgets/ghost.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart' as Constants;

/// The database class, which is our point of contact for all database transactions.
///
/// This class will also create the schema for the database if the database is not
/// yet created yet. The close() method must be called
class DB {
  /// The database path.
  String _path;

  /// The database singleton instance.
  Database _pool;

  /// Some debugging utilities in a DbDebug class for the database.
  DbDebug _debug;

  DB() {
    _init();
  }

  /// Opens the database connection, storing to the pool.
  _init() async {
    dev.log("Called _init", name: "db.db");
    // These aren't in the constructor because they're asynchronous
    var databasesPath = await getDatabasesPath();
    _path = join(databasesPath, Constants.DB_NAME);
    _pool = await openDatabase(_path, version: 1, onCreate: _seed);
    _debug = DbDebug(this);
  }

  /// Returns the database connection singleton.
  get pool {
    return _pool;
  }

  /// Returns the debugging class for the database.
  get debug {
    return _debug;
  }

  Future<Ghost> getGhost(int id) async {
    List<Map> maps = await _pool.query(Constants.GHOST_TABLE,
        columns: null, where: '${Constants.GHOST_ID} = ?', whereArgs: [id]);
    if (maps.length > 0) {
      var map = maps.first;
      Level lvl;
      switch (map['${Constants.GHOST_DIFFICULTY}']) {
        case 0:
          {
            lvl = Level.Easy;
          }
          break;

        case 1:
          {
            lvl = Level.Med;
          }
          break;

        case 2:
          {
            lvl = Level.Hard;
          }
          break;
      }
      return Ghost(
          id: map['${Constants.GHOST_ID}'],
          temperament: map['${Constants.GHOST_TEMPERAMENT}'],
          //map['${Constants.GHOST_PROGRESS}'],
          name: "Ronaldo",
          level: lvl,
          score: map['${Constants.GHOST_SCORE}'],
          progress: map['${Constants.GHOST_PROGRESS}'], //
          imageURI: null //TODO add image path to database
          );
    } else {
      return null;
    }
  }

  /// Sets a particular ghost id as chosen and active.
  Future<int> setGhost(int id) async {
    if (id < 0 || id > 9) {
      throw ArgumentError('The `id` passed is likely invalid.');
    }

    Map<String, dynamic> row = {
      Constants.GHOST_PROGRESS: 0,
      Constants.GHOST_SCORE: 1,
      Constants.GHOST_ACTIVE: true
    };

    dev.log("Set ghost id $id", name: "db.db");
    // Return the ID that was updated.
    int res = await _pool.update(Constants.GHOST_TABLE, row,
        where: '${Constants.GHOST_ID} = ?', whereArgs: [id]);

    return res;
  }

  /// Unsets a particular ghost id as chosen and active.
  ///
  /// This resets the ghost's data to the default.
  Future<int> unsetGhost(int id) async {
    if (id < 0 || id > 9) {
      throw ArgumentError('The `id` passed is likely invalid.');
    }

    Map<String, dynamic> row = {
      Constants.GHOST_TEMPERAMENT: 1,
      Constants.GHOST_DIFFICULTY: id ~/ 3,
      Constants.GHOST_PROGRESS: 0,
      Constants.GHOST_SCORE: 0,
      Constants.GHOST_ACTIVE: false
    };

    dev.log("Unset ghost id $id", name: "db.db");
    // Return the ID that was updated.
    int res = await _pool.update(Constants.GHOST_TABLE, row,
        where: '${Constants.GHOST_ID} = ?', whereArgs: [id]);

    return res;
  }

  /// Closes the database connection. Should only be called when app is killed.
  close() async {
    dev.log("Closed DB Connection", name: "db.db");
    await _pool.close();
    _pool = null;
  }

  /// Deletes the database and creates a new one. THIS DELETES ALL DATA!
  delete() async {
    close();
    dev.log("Deleted DB", name: "db.db");
    await deleteDatabase(_path);
    _init();
  }

  /// Creates the database tables and initializes the data.
  _seed(Database db, int version) async {
    dev.log("Seeding DB", name: "db.db");
    await db.execute("CREATE TABLE ${Constants.GHOST_TABLE} ("
        "${Constants.GHOST_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${Constants.GHOST_TEMPERAMENT} INTEGER NOT NULL,"
        "${Constants.GHOST_DIFFICULTY} INTEGER NOT NULL,"
        "${Constants.GHOST_PROGRESS} INTEGER NOT NULL,"
        "${Constants.GHOST_SCORE} INTEGER NOT NULL,"
        "${Constants.GHOST_ACTIVE} BOOLEAN NOT NULL"
        ")");
    
    await db.execute("CREATE TABLE ${Constants.GHOST_RESPONSES_TABLE} ("
        "${Constants.GRESPONSE_PK} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${Constants.PIB} INTEGER NOT NULL,"
        "${Constants.LEVEL} INTEGER NOT NULL,"
        "${Constants.RESPONSE_IDS} STRING NOT NULL,"
        "${Constants.ENCR_GHOST_ID} STRING NOT NULL"
        ")");

    await db.execute("CREATE TABLE ${Constants.USER_RESPONSES_TABLE} ("
        "${Constants.URESPONSE_PK} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${Constants.UID} INTEGER NOT NULL"
        ")");

    // Insert a default row for each ghost
    for (var i = 0; i < 9; i++) {
      Map<String, dynamic> row = {
        Constants.GHOST_TEMPERAMENT: 1,
        Constants.GHOST_DIFFICULTY: i ~/ 3,
        Constants.GHOST_PROGRESS: 0,
        Constants.GHOST_SCORE: 0,
        Constants.GHOST_ACTIVE: false
      };
      dev.log("Inserted ghost id ${i + 1}", name: "db.db");
      await db.insert(Constants.GHOST_TABLE, row);
    }
  }
}

