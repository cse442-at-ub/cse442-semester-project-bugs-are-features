import 'dart:developer' as dev;

import 'package:ghost_app/db/debug.dart';
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

  /// Opens the database connection, storing to the pool.
  init() async {
    dev.log("Called init", name: "db.db");
    // These aren't in the constructor because they're asynchronous
    var databasesPath = await getDatabasesPath();
    _path = join(databasesPath, Constants.DB_NAME);
    _pool = await openDatabase(_path, version: 1, onCreate: _seed);
    _debug = DbDebug(this);
  }

  /// Returns the database connection singleton.
  get pool => _pool;

  /// Returns the debugging class for the database.
  get debug => _debug;

  /// Sets a particular ghost id as chosen and active.
  setGhost(int id) async {
    if (id < 0 || id > 9) {
      throw ArgumentError('The `id` passed is likely invalid.');
    }

    Map<String, dynamic> row = {
      // TODO: Change this later when starting from level 0 for tutortial
      Constants.GHOST_LEVEL: 2,
      Constants.GHOST_SCORE: 20,
      Constants.GHOST_ACTIVE: 'true'
    };

    dev.log("Set ghost id $id", name: "db.db");
    // Return the ID that was updated.
    int cols;
    await _pool.update(
        Constants.GHOST_TABLE,
        row,
        where: '${Constants.GHOST_ID} = ?',
        whereArgs: [id]
    ).then((colsUpdated) => cols = colsUpdated);

    return cols;
  }

  /// Unsets a particular ghost id as chosen and active.
  ///
  /// This resets the ghost's data to the default.
  unsetGhost(int id) async {
    if (id < 0 || id > 9) {
      throw ArgumentError('The `id` passed is likely invalid.');
    }

    Map<String, dynamic> row = {
      Constants.GHOST_TEMPERAMENT: 1,
      Constants.GHOST_DIFFICULTY: id ~/ 3,
      Constants.GHOST_LEVEL: 0,
      Constants.GHOST_SCORE: 0,
      Constants.GHOST_ACTIVE: 'false',
      Constants.GHOST_CANDLE_LIT: 'false'
    };

    dev.log("Unset ghost id $id", name: "db.db");
    // Return the ID that was updated.
    int cols;
    await _pool.update(
        Constants.GHOST_TABLE,
        row,
        where: '${Constants.GHOST_ID} = ?',
        whereArgs: [id]
    ).then((updatedCols) => cols = updatedCols);

    return cols;
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
    print(_path);
    await deleteDatabase(_path);
    init();
  }

  /// Creates the database tables and initializes the data.
  _seed(Database db, int version) async {
    dev.log("Seeding DB", name: "db.db");
    await db.execute(
        "CREATE TABLE ${Constants.GHOST_TABLE} ("
          "${Constants.GHOST_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${Constants.GHOST_TEMPERAMENT} INTEGER DEFAULT 1,"
          "${Constants.GHOST_DIFFICULTY} INTEGER NOT NULL,"
          "${Constants.GHOST_LEVEL} INTEGER DEFAULT 0,"
          "${Constants.GHOST_SCORE} INTEGER DEFAULT 0,"
          "${Constants.GHOST_ACTIVE} BOOLEAN DEFAULT false,"
          "${Constants.GHOST_CANDLE_LIT} BOOLEAN DEFAULT false"
        ")"
    );
    
    await db.execute(
        "CREATE TABLE ${Constants.GHOST_RESP_TABLE} ("
          "${Constants.GHOST_RESP_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${Constants.GHOST_RESP_GHOST_ID} INTEGER NOT NULL,"
          "${Constants.GHOST_RESP_LEVEL} INTEGER NOT NULL,"
          "${Constants.GHOST_RESP_RESP_ID} INTEGER NOT NULL,"
          "${Constants.GHOST_RESP_IDS} STRING NOT NULL,"
          "${Constants.GHOST_RESP_TEXT} STRING NOT NULL"
        ")"
    );

    await db.execute(
        "CREATE TABLE ${Constants.USER_RESP_TABLE} ("
          "${Constants.USER_RESP_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${Constants.USER_RESP_PID} INTEGER NOT NULL,"
          "${Constants.USER_RESP_TEXT} STRING NOT NULL"
        ")"
    );

    // Insert a default row for each ghost
    for (var i = 0; i < 9; i++) {
      Map<String, dynamic> row = { Constants.GHOST_DIFFICULTY: i ~/ 3 };
      dev.log("Inserted ghost id ${i + 1}", name: "db.db");
      await db.insert(Constants.GHOST_TABLE, row);
    }
  }
}

