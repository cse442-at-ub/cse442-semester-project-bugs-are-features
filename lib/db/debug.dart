import 'package:ghost_app/db/db.dart';

import 'constants.dart' as Constants;

/// The DbDebug class is mainly a utility class to print out debugging information.
///
/// The methods in this class don't have any effect on the data in the database.
/// The methods in this class also don't print to the dev logger: they print
/// straight to console. More than likely they will just print raw query results.
class DbDebug {
  /// Holds an instance of our DB to querying.
  final DB _database;

  DbDebug(this._database);

  /// Prints all 9 rows of the ghosts.
  printGhostTable() async {
    List<Map> res;
    res = await _database.pool.rawQuery("SELECT * FROM ${Constants.GHOST_TABLE}");
    res.forEach((row) => print(row));
  }

  printUserRespTable() async {
    List<Map> res;
    res = await _database.pool.rawQuery("SELECT * FROM ${Constants.GHOST_TABLE}");
    res.forEach((row) => print(row));
  }
}