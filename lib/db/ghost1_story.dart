import 'dart:developer' as dev;

import 'package:sqflite/sqlite_api.dart';

seed(Database db) async {
  dev.log("Seeding ghost 1's story", name: "db.ghost1");
  var batch = db.batch();
  // Level 2
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 2, 1, \"2,3,4,5\", \"Hello, human...\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 2, -1, 0, -2, 0, \"Go away!\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 2, -1, 0, 0, 5, \"What's your name?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 2, -1, 1, -1, 2, \"you scream in fear\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 2, -1, 0, 0, 5, \"Hello\")");
  // Level 3
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 3, 6, \"\", \"Too bad, huh? We'll see about that...\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 3, 9, \"\", \"That's... a good question. Sort of. But my human home was London.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 3, 7, \"\", \"London was home. My old home.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 3, 8, \"\", \"You think being a ghost is fun? I miss London.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 3, 1, \"2,3,4,5\", \"I wish I could go home\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 3, 6, 0, -1, 0, \"Too bad.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 3, 9, 0, 0, 2, \"Do ghosts have homes?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 3, 8, 0, 0, 3, \"Why?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 3, 7, 0, 0, 5, \"Where's home?\")");
  // Level 4
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 4, 7, \"\", \"Then I don't have time for you. Which is ironic because I used to be a clock-maker.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 4, 6, \"8,9,10,11\", \"Keeping track of time was my job.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 4, 1, \"2,3,4,5\", \"I used to care a lot about time. Not so much anymore.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 4, 12, \"13,14,15,11\", \"I was a clock maker, and among the best of them, too.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 4, 7, 0, -1, 0, \"I don't care.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 4, -1, 0, 0, 3, \"Neat!\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 4, 12, 0, 0, 2, \"You had a job?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 4, 12, 0, 0, 3, \"How so?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 4, -1, 0, 0, 2, \"Okay.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 4, 7, 0, -1, 0, \"I don't have time for this.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 4, -1, 0, 0, 5, \"That's a cool job.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 4, 6, 0, 0, 5, \"What's so good about time?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 4, 6, 0, 0, 2, \"Oh, okay.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 4, 6, 0, 0, 3, \"Why?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, type, effect, points, text) VALUES (1, 4, 12, 0, 0, 5, \"What was your job?\")");

  // Store everything
  await batch.commit(noResult: true);
}