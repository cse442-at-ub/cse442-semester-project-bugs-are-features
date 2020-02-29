import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// The database class, which is our point of contact for all database transactions.
///
/// This class will also create the schema for the database if the database is not
/// yet created yet. The close() method must be called
class DB {
  /// The database path.
  String _path;

  /// The database singleton instance.
  Database _pool;

  DB() {
    init();
  }

  /// Opens the database connection, storing to the pool.
  init() async {
    // These aren't in the constructor because they're asynchronous
    var databasesPath = await getDatabasesPath();
    String _path = join(databasesPath, 'data.db');
    _pool = await openDatabase(_path, version: 1, onCreate: _seed);
  }

  /// Returns the database connection singleton.
  get pool {
    return _pool;
  }

  /// Closes the database connection. Should only be called when app is killed.
  close() async {
    await _pool.close();
    _pool = null;
  }

  /// Deletes the database and creates a new one. THIS DELETES ALL DATA!
  delete() async {
    _pool = null;
    await deleteDatabase(_path);
    init();
  }

  /// Creates the database tables and initializes the data.
  _seed(Database db, int version) async {
    await db.execute(
        "CREATE TABLE ghost ("
            "id INTEGER PRIMARY KEY,"
            "temperament INTEGER,"  // 0 = Friendly, 1 = Neutral, 2 = Angry
            "difficulty INTEGER,"   // Difficulty 0 - 2, 2 being hardest
            "progress INTEGER,"     // 0-10 Story Progress
            "score INTEGER,"        // Accumulated Points
            "active BOOLEAN"        // If the ghost is "assigned" to user
        ")");
  }
}