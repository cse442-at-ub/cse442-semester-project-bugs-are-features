import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

/// The database class, which is our point of contact for all database transactions.
///
/// This class will also create the schema for the database if the database is not
/// yet created yet. The close() method must be called
class DB {

  /// The database singleton instance.
  Database pool;

  /// Opens the database connection, storing to the pool.
  void init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    pool = await openDatabase(path, version: 1, onCreate: _seed);
  }

  /// Closes the database connection.
  void close() async {
    await pool.close();
    pool = null;
  }

  /// Creates the database tables and initializes the data.
  _seed(Database db, int version) async {
    await db.execute(
        "CREATE TABLE ghost ("
            "id INTEGER PRIMARY KEY,"
            "nature INTEGER,"   // 0 = Friendly, 1 = Neutral, 2 = Angry
            "level INTEGER,"    // Difficulty
            "progress INTEGER," // 0-10 Story Progress
            "score INTEGER,"    // Accumulated Points
            "engaged BOOLEAN"  // If the ghost is "assigned" to user
        ")");
  }
}