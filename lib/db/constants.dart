library constants;

/// Database filename
const String DB_NAME = 'data.db';

/* GHOST TABLE */

/// Ghost Table Name
const String GHOST_TABLE = 'ghost';

/// Ghost ID column (autoincrements). INTEGER
const String GHOST_ID = 'id';

/// Ghost Temperament: 0 = Angry, 1 = Neutral, 2 = Friendly. INTEGER
const String GHOST_TEMPERAMENT = 'temperament';

/// Ghost Difficulty: Difficulty 0 - 2, 2 being hardest. INTEGER
const String GHOST_DIFFICULTY = 'difficulty';

/// Current Ghost Story Progress: 0-10. 0 is a fresh game. INTEGER
const String GHOST_PROGRESS = 'progress';

/// Current Accumulated Points for the ghost. FLOAT
const String GHOST_SCORE = 'score';

/// If the ghost is "assigned" to user. BOOLEAN
const String GHOST_ACTIVE = 'active';



/* GHOST RESPONSE TABLE */

/// Name of the table
const String GHOST_RESP_TABLE = 'ghost_responses';

/// Ghost response Primary Key
const String GHOST_RESP_ID = 'id';

/// Ghost ID
const String GHOST_RESP_GHOST_ID = 'gid';

/// Level of the response
const String GHOST_RESP_LEVEL = 'level';

/// ID of the response
const String GHOST_RESP_RESP_ID = 'rid';

/// IDs of the response options : 4 options
const String GHOST_RESP_IDS = 'response_ids';

/// The text of the ghost's response
const String GHOST_RESP_TEXT = 'text';




/* USER RESPONSE TABLE */

/// Name of the table
const String USER_RESP_TABLE = 'user_responses';

/// User response Primary Key
const String USER_RESP_ID = 'id';

/// ID of the chosen response
const String USER_RESP_PID = 'rid';

/// The text of this response
const String USER_RESP_TEXT = 'text';