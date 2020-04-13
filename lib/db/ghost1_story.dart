import 'dart:developer' as dev;

import 'package:sqflite/sqlite_api.dart';

seed(Database db) async {
  dev.log("Seeding ghost 1's story", name: "db.ghost1");
  var batch = db.batch();
  // Level 2
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 2, 1, \"2,3,4,5\", \"Hello, human...\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 2, -1, 3, 1, -1, 2, \"you scream in fear\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 2, -1, 2, 0, 0, 5, \"Hello\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 2, -1, 5, 0, 0, 5, \"What's your name?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 2, -1, 4, 0, -2, 0, \"Go away!\")");
  // Level 3
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 3, 6, \"\", \"Too bad, huh? We'll see about that...\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 3, 9, \"\", \"That's... a good question. Sort of. But my human home was London.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 3, 1, \"2,3,4,5\", \"I wish I could go home\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 3, 8, \"\", \"You think being a ghost is fun? I miss London.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 3, 7, \"\", \"London was home. My old home.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 3, 8, 4, 0, 0, 3, \"Why?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 3, 7, 3, 0, 0, 5, \"Where's home?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 3, 6, 2, 0, -1, 0, \"Too bad.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 3, 9, 5, 0, 0, 2, \"Do ghosts have homes?\")");
  // Level 4
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 4, 6, \"8,9,10,11\", \"Keeping track of time was my job.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 4, 12, \"13,14,15,11\", \"I was a clock maker, and among the best of them, too.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 4, 7, \"\", \"Then I don't have time for you. Which is ironic because I used to be a clock-maker.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 4, 1, \"2,3,4,5\", \"I used to care a lot about time. Not so much anymore.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 4, 7, 3, 0, -1, 0, \"I don't have time for this.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 4, 12, 9, 0, 0, 5, \"What was your job?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 4, 6, 2, 0, 0, 3, \"Why?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 4, 6, 5, 0, 0, 2, \"Oh, okay.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 4, 12, 8, 0, 0, 3, \"How so?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 4, -1, 15, 0, 0, 5, \"That's a cool job.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 4, 6, 4, 0, 0, 5, \"What's so good about time?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 4, 7, 11, 0, -1, 0, \"I don't care.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 4, -1, 14, 0, 0, 2, \"Okay.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 4, 12, 10, 0, 0, 2, \"You had a job?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 4, -1, 13, 0, 0, 3, \"Neat!\")");
  // Level 5
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 5, 22, \"\", \"Likewise.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 5, 14, \"9,10,11,12\", \"I wish it was. But try again.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 5, 6, \"9,10,11,12\", \"Oh really now? Then what is it?\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 5, 20, \"\", \"No, never.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 5, 8, \"2,3,4,5\", \"And you're just a human. I'll ask again. Do you want to know my name?\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 5, 21, \"\", \"I know how you're going to die.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 5, 7, \"16,17,18,19\", \"My name is Samuel Tomlins. Or it used to be, at least.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 5, 1, \"2,3,4,5\", \"I'm a ghost, so I know your name. Do you want to know mine?\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 5, 15, \"9,10,11,12\", \"... seriously?\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 5, 13, \"9,10,11,12\", \"Uhh, no. Try again.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 5, -1, 19, 0, 0, 2, \"Good to know.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 5, 7, 3, 0, 0, 5, \"Yes, absolutely.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 5, 7, 5, 0, 0, 3, \"Sure, why not.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 5, 13, 9, 0, 0, 0, \"Bilbo Baggins\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 5, 20, 17, 0, 0, 3, \"Can I call you Sam?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 5, 7, 12, 0, 0, 3, \"Samuel Tomlins\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 5, 6, 2, 0, 0, 2, \"I already know it.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 5, 22, 16, 0, 0, 5, \"Pleased to meet you, Samuel!\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 5, 14, 10, 0, 0, 0, \"Ghosty McGhost\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 5, 21, 18, 0, 0, 0, \"You're still just a ghost.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 5, 8, 4, 0, -1, 0, \"You're just a ghost, I don't really care.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 5, 15, 11, 0, -1, 0, \"Dead Guy\")");
  // Level 6
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 6, 8, \"10,11,12,13\", \"No...? Anyway, it's a guess the number game. How old do you think I am?\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 6, 1, \"2,3,4,5\", \"I want to play a game.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 6, 16, \"17,21,19,20\", \"I'll give you a hint: I am ... was ... 20 years old, plus six.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 6, 15, \"17,18,19,20\", \"Wrong. I died young at 26, so I can never be too old!\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 6, 6, \"9,3,5,4\", \"It's easy, don't worry.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 6, 7, \"10,11,12,13\", \"It's a simple guessing game. Guess the number, in fact. How old do you think I am?\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 6, 23, \"\", \"Yes. Thanks for reminding me.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 6, 22, \"\", \"That was over 400 years ago. I was born in 1608 and ... became a ghost in 1634.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 6, 14, \"17,18,19,20\", \"I guess that's sort of right. I ... became a ghost ... when I was 26, but that was a long time ago.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 8, 9, 0, 0, 1, \"Alright Ghosty McGhost, I believe you.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 22, 19, 0, 0, 5, \"How long ago?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 14, 11, 0, 0, 5, \"In your twenties\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 22, 20, 0, 0, 5, \"So how old are you actually?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 7, 3, 0, 0, 3, \"What kind of game?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 22, 21, 0, 0, 2, \"But that's not your real age, right?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 23, 18, 0, -1, 0, \"You mean died?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 14, 10, 0, 0, 5, \"Over 300\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 16, 13, 0, 0, 1, \"I have no clue\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 15, 12, 0, -1, 0, \"Too old\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 8, 4, 0, 0, 1, \"Aren't we already playing one?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 22, 17, 0, 0, 3, \"You're younger than I thought.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 7, 5, 0, 0, 5, \"Let's play!\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 6, 6, 2, 0, 0, 2, \"... I've heard this before. Nope.\")");
  // Level 7
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 7, 1, \"2,3,4,5\", \"You know what the worst part of being a ghost is?\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 7, 8, \"\", \"Double-click this passage to edit it.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 7, 7, \"9,10,11,12\", \"Maybe I can help you become one.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 7, 14, \"\", \"Double-click this passage to edit it.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 7, 6, \"15,16,17,18\", \"Well, yeah. But I miss my wife.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 7, 13, \"\", \"...\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 7, 19, \"\", \"I don't know. But as long as I'm stuck as a ghost, I won't be able to find out.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 7, 20, \"\", \"Thanks. I hope that if I can be released from being a ghost, I'll be able to see her again.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 7, 8, 5, 0, 0, 5, \"The lack of company?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 7, 19, 15, 0, 0, 5, \"Isn't there some way to see her?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 7, 7, 3, 0, 0, 0, \"Seems kind of cool to me, actually.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 7, 1, 11, 0, 0, 0, \"Uhh... I think I'll pass.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 7, 13, 16, 0, -2, 0, \"Oh yeah, she's long gone.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 7, 13, 10, 0, -2, 0, \"Please do.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 7, 6, 4, 0, 0, 2, \"It must be boring.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 7, 14, 12, 0, 0, 1, \"... what's the worst part?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 7, 20, 17, 0, 0, 5, \"I'm sorry to hear that.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 7, 6, 2, 0, 0, 3, \"You're dead?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 7, 1, 9, 0, 0, 1, \"Sorry, I didn't mean that.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 7, 19, 18, 0, 0, 5, \"Is there anything I can do?\")");
  // Level 8
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 8, 1, \"2,3,4,5\", \"Back in my time, clockmaking was considered a high-tech job where I'm from.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 8, 14, \"17,10,11,12\", \"Yes, I had my own shop for 5 years.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 8, 16, \"10,17,9,11\", \"... really?\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 8, 13, \"17,9,10,12\", \"I was an apprentice as a child.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 8, 6, \"\", \"Take a trip to Londo and try your hand at making one then!\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 8, 8, \"\", \"The King of Britain cared.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 8, 15, \"17,9,11,12\", \"It may not seem like a lot, but I made 42 clocks in total.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 8, 7, \"9,10,11,12\", \"I was living in London, and clockmakers weren't all that common.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 8, -1, 17, 0, 0, 5, \"I don't have more questions.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 8, 7, 4, 0, 0, 5, \"Were there a lot of clockmakers where you're from?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 8, 6, 2, 0, 0, 0, \"It doesn't seem too hard to me.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 8, 13, 11, 0, 0, 0, \"How did you learn?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 8, 16, 12, 0, 0, 0, \"What's a clock?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 8, 8, 5, 0, -1, 0, \"I don't really care.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 8, 14, 9, 0, 0, 0, \"Did you have your own shop?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 8, 15, 10, 0, 0, 0, \"How many clocks did you make?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 8, 7, 3, 0, 0, 5, \"Where was this?\")");
  // Level 9
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 9, 1, \"2,3,4,5\", \"I still think back to when it happened. If only I had been a little more to the left...\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 9, 6, \"8,9\", \"I was in my shop working on a very important clock. The clock was gold and jeweled, ordered by a very important person.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 9, 7, \"2,3,4,5\", \"The moment I ... become a ghost.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 9, 10, \"\", \"Well... I don't think I'm ready to talk about it yet.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 9, 10, 9, 0, 0, 5, \"What exactly happened?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 9, 7, 3, 0, 0, 0, \"What are you talking about?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 9, 6, 4, 0, 0, 5, \"What were you doing?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 9, 7, 5, 0, 0, 0, \"When what happened?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 9, 10, 8, 0, 0, 5, \"Who was the clock for?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 9, 6, 2, 0, 0, 5, \"A little to the left of what?\")");
  // Level 10
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 10, 17, \"18\", \"It sprung out ... directly into my eye at a high velocity! I was watching too closely.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 10, 6, \"8\", \"Charles I, King of Britain had ordered a clock from me. This was to be a life-changing order.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 10, 7, \"8\", \"Well, I'm going to tell you anyway. The King of Britain had ordered a clock from me. This was to be a life-changing order.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 10, 23, \"24\", \"I was doing what I loved, but failed to achieve what would have been the greatest accomplishment of my life.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 10, 19, \"20\", \"If only that had killed me. But I didn't die right away. My eye became infected and I lost sight from it.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 10, 21, \"22\", \"And then the infection overcame me and I died. It was as simple and undignified as that.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 10, 9, \"10\", \"He ordered a jewel-encrusted, gold-plated grandfather clock. It was to be of the highest quality, and the payment offered for it reflected that as well.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 10, 25, \"\", \"And that is how Samuel Tomlins, the best clockmaker in London, died.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 10, 11, \"12\", \"This was a very great honor, and one that was sure to bring me business for the rest of my life. The King only orders from the best.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 10, 13, \"14\", \"I had nearly finished making the clock. I had the back casing open to watch the gears as the clock struck midnight and played its chime, to make sure it worked properly.\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 10, 15, \"16\", \"But alas, I had used the wrong spring. The tension was too high. And when it struck midnight, the spring sprung out!\")");
  batch.execute("INSERT INTO ghost_responses (gid, level, rid, response_ids, text) VALUES (1, 10, 1, \"2,3,4,5\", \"Do you want to hear the story of how I died?\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 6, 4, 0, 0, 3, \"I've been DYING to hear this.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 13, 12, 0, 0, 0, \"Continue\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 19, 18, 0, 0, 0, \"Continue\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 21, 20, 0, 0, 0, \"Continue\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 6, 2, 0, 0, 3, \"Yes.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 7, 3, 0, 0, 0, \"Not really, honestly.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 15, 14, 0, 0, 0, \"Continue\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 6, 5, 0, 0, 5, \"Yes, if you feel like telling me.\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 17, 16, 0, 0, 0, \"Continue\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 11, 10, 0, 0, 0, \"Continue\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 23, 22, 0, 0, 0, \"Continue\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 25, 24, 0, 0, 0, \"Continue\")");
  batch.execute("INSERT INTO user_responses (gid, level, rid, grid, type, effect, points, text) VALUES (1, 10, 9, 8, 0, 0, 0, \"Continue\")");

  // Store everything
  await batch.commit(noResult: true);
}