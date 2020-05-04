import 'dart:developer' as dev;
import 'dart:math';

import 'package:Inspectre/db/debug.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart' as Constants;
import 'ghost1_story.dart' as Ghost1;

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
    await _pool.update(Constants.GHOST_TABLE, row,
        where: '${Constants.GHOST_ID} = ?',
        whereArgs: [id]).then((colsUpdated) => cols = colsUpdated);

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
    await _pool.update(Constants.GHOST_TABLE, row,
        where: '${Constants.GHOST_ID} = ?',
        whereArgs: [id]).then((updatedCols) => cols = updatedCols);

    return cols;
  }

  /// Returns a ghost's response while leveling
  getLevelingGhostResp(int gid, int level, int rid) async {
    return await _pool.query(Constants.GHOST_RESP_TABLE,
        columns: [Constants.GHOST_RESP_IDS, Constants.GHOST_RESP_TEXT],
        where: '${Constants.GHOST_RESP_GHOST_ID} = ? AND '
            '${Constants.GHOST_RESP_LEVEL} = ? AND '
            '${Constants.GHOST_RESP_RID} = ?',
        whereArgs: [gid, level, rid]);
  }

  /// Returns a ghost's response while leveling
  getLevelingUserResp(int gid, int level, int rid) async {
    return await _pool.query(Constants.USER_RESP_TABLE,
        columns: [
          Constants.USER_RESP_RID,
          Constants.USER_RESP_TYPE,
          Constants.USER_RESP_EFFECT,
          Constants.USER_RESP_POINTS,
          Constants.USER_RESP_TEXT
        ],
        where: '${Constants.USER_RESP_GHOST_ID} = ? AND '
            '${Constants.USER_RESP_LEVEL} = ? AND '
            '${Constants.USER_RESP_GRID} = ?',
        whereArgs: [gid, level, rid]);
  }

  getDefaultInteraction(int gid, int level, int qty) async {
    var rng = Random();
    // Random number of lvl 0 responses
    int defaultResps = rng.nextInt(2);
    // Number of responses relevant to this level. Always at least 1
    int lvlResps = 4 - defaultResps;

    // TODO: Make it select 2-4 random ones
    var defaultRows = await _pool.query(Constants.DEFAULT_RESP_TABLE,
        columns: [
          Constants.DEFAULT_RESP_USER,
          Constants.DEFAULT_RESP_GHOST,
          Constants.DEFAULT_RESP_POINTS
        ],
        where: '${Constants.DEFAULT_RESP_GHOST_ID} = ? AND '
            '${Constants.DEFAULT_RESP_LEVEL} = ?',
        whereArgs: [gid, 0],
        orderBy: 'RANDOM()',
        limit: defaultResps);

    var lvlRows = await _pool.query(Constants.DEFAULT_RESP_TABLE,
        columns: [
          Constants.DEFAULT_RESP_USER,
          Constants.DEFAULT_RESP_GHOST,
          Constants.DEFAULT_RESP_POINTS
        ],
        where: '${Constants.DEFAULT_RESP_GHOST_ID} = ? AND '
            '${Constants.DEFAULT_RESP_LEVEL} = ?',
        whereArgs: [gid, level],
        orderBy: 'RANDOM()',
        limit: lvlResps);

    return defaultRows + lvlRows;
  }

  /// Gets the user's current amount of energy
  getCurrentEnergy() async {
    var res = await _pool.query(Constants.GAME_TABLE,
        columns: [Constants.GAME_ENERGY],
        where: '${Constants.GAME_TABLE_ID} = ?',
        whereArgs: [1]);
    return res.isNotEmpty ? int.parse(res.first.values.first.toString()) : Null;
  }

  setCurrentEnergy(int energy) async {
    if (energy < 0 || energy > 100) {
      throw ArgumentError('The `energy` passed is likely invalid.');
    }

    Map<String, dynamic> row = {
      Constants.GAME_ENERGY: energy,
    };

    dev.log("Saving user's energy: $energy", name: "db.db");
    // Return the ID that was updated.
    int cols;
    await _pool.update(Constants.GAME_TABLE, row,
        where: '${Constants.GAME_TABLE_ID} = ?',
        whereArgs: [1]).then((updatedCols) => cols = updatedCols);

    return cols;
  }

  getStoredTimers() async {
    return await _pool.query(Constants.GAME_TABLE,
        columns: [
          Constants.GAME_CYCLE_TIMER,
          Constants.GAME_ENERGY_TIMER,
          Constants.GAME_CANDLE_TIMER,
        ],
        where: '${Constants.GAME_TABLE_ID} = ?',
        whereArgs: [1]);
  }

  storeTimers(int cycle, int energy, int candle) async {
    Map<String, dynamic> row = {
      Constants.GAME_CYCLE_TIMER: cycle,
      Constants.GAME_ENERGY_TIMER: energy,
      Constants.GAME_CANDLE_TIMER: candle,
    };

    dev.log(
        "Storing timer values: Day/Night: $cycle, "
        "Energy: $energy, Candle: $candle",
        name: "db.db");
    await _pool.update(Constants.GAME_TABLE, row,
        where: '${Constants.GAME_TABLE_ID} = ?', whereArgs: [1]);
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
    var batch = db.batch();

    // Create Game State table
    batch.execute("CREATE TABLE ${Constants.GAME_TABLE} ("
        "${Constants.GAME_TABLE_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${Constants.GAME_ENERGY} INTEGER DEFAULT 100,"
        "${Constants.GAME_ENERGY_TIMER} INTEGER DEFAULT 0,"
        "${Constants.GAME_CYCLE_TIMER} INTEGER DEFAULT 0,"
        "${Constants.GAME_CANDLE_TIMER} INTEGER DEFAULT 0"
        ")");
    // Create ghost state table
    batch.execute("CREATE TABLE ${Constants.GHOST_TABLE} ("
        "${Constants.GHOST_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${Constants.GHOST_TEMPERAMENT} INTEGER DEFAULT 1,"
        "${Constants.GHOST_DIFFICULTY} INTEGER NOT NULL,"
        "${Constants.GHOST_LEVEL} INTEGER DEFAULT 0,"
        "${Constants.GHOST_SCORE} INTEGER DEFAULT 0,"
        "${Constants.GHOST_ACTIVE} BOOLEAN DEFAULT false,"
        "${Constants.GHOST_CANDLE_LIT} BOOLEAN DEFAULT false"
        ")");
    // Create standard interactions table
    batch.execute("CREATE TABLE ${Constants.DEFAULT_RESP_TABLE} ("
        "${Constants.DEFAULT_RESP_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${Constants.DEFAULT_RESP_GHOST_ID} INTEGER NOT NULL,"
        "${Constants.DEFAULT_RESP_LEVEL} INTEGER NOT NULL,"
        "${Constants.DEFAULT_RESP_USER} STRING NOT NULL,"
        "${Constants.DEFAULT_RESP_GHOST} STRING NOT NULL,"
        "${Constants.DEFAULT_RESP_POINTS} INTEGER NOT NULL"
        ")");
    // Create LEVEL-UP ghost response table
    batch.execute("CREATE TABLE ${Constants.GHOST_RESP_TABLE} ("
        "${Constants.GHOST_RESP_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${Constants.GHOST_RESP_GHOST_ID} INTEGER NOT NULL,"
        "${Constants.GHOST_RESP_LEVEL} INTEGER NOT NULL,"
        "${Constants.GHOST_RESP_RID} INTEGER NOT NULL,"
        "${Constants.GHOST_RESP_IDS} STRING NOT NULL,"
        "${Constants.GHOST_RESP_TEXT} STRING NOT NULL"
        ")");
    // Create LEVEL-UP user response table
    batch.execute("CREATE TABLE ${Constants.USER_RESP_TABLE} ("
        "${Constants.USER_RESP_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${Constants.USER_RESP_GHOST_ID} INTEGER NOT NULL,"
        "${Constants.USER_RESP_LEVEL} INTEGER NOT NULL,"
        "${Constants.USER_RESP_RID} INTEGER NOT NULL,"
        "${Constants.USER_RESP_GRID} INTEGER NOT NULL,"
        "${Constants.USER_RESP_TYPE} INTEGER NOT NULL,"
        "${Constants.USER_RESP_EFFECT} INTEGER NOT NULL,"
        "${Constants.USER_RESP_POINTS} INTEGER NOT NULL,"
        "${Constants.USER_RESP_TEXT} STRING NOT NULL"
        ")");
    await batch.commit(noResult: true);

    Map<String, dynamic> game = {Constants.GAME_ENERGY: 100};
    dev.log("Inserting single game state row", name: "db.db");
    await db.insert(Constants.GAME_TABLE, game);

    // Insert a default row for each ghost
    for (var i = 0; i < 3; i++) {
      Map<String, dynamic> row = {Constants.GHOST_DIFFICULTY: i ~/ 3};
      dev.log("Inserted ghost id ${i + 1}", name: "db.db");
      await db.insert(Constants.GHOST_TABLE, row);
    }

    // Seed ghost 1's story
    Ghost1.seed(db);
  }
}
