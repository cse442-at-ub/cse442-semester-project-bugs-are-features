library constants;

/// Database filename
const String DB_NAME = 'data.db';


/* GAME STATE TABLE */

/// Game State Table Name
const String GAME_TABLE = 'game';

/// Game state table id (will only be one)
const String GAME_TABLE_ID = 'id';

/// Current user energy
const String GAME_ENERGY = 'energy';

/// Saved candle timer amount
const String GAME_CANDLE_TIMER = 'candle_timer';

/// Saved day/night cycle timer amount
const String GAME_CYCLE_TIMER = 'cycle_timer';

/// Saved energy timer amount
const String GAME_ENERGY_TIMER = 'energy_timer';


/* GHOST TABLE */

/// Ghost Table Name
const String GHOST_TABLE = 'ghost';

/// Ghost ID column (autoincrements). INTEGER
const String GHOST_ID = 'id';

/// Ghost Temperament: 0 = Angry, 1 = Neutral, 2 = Friendly. INTEGER
const String GHOST_TEMPERAMENT = 'temperament';

/// Ghost Difficulty: Difficulty 0 - 2, 2 being hardest. INTEGER
const String GHOST_DIFFICULTY = 'difficulty';

/// Current Ghost Story Level: 0-10. 0 is a fresh game. INTEGER
const String GHOST_LEVEL = 'level';

/// Current Accumulated Points for the ghost. INTEGER
const String GHOST_SCORE = 'score';

/// If the ghost is "assigned" to user. BOOLEAN
const String GHOST_ACTIVE = 'active';

/// If the candle is lit the ghost is incommunicado
const String GHOST_CANDLE_LIT = 'candle_lit';



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
const String GHOST_RESP_RID = 'rid';

/// IDs of the response options : 4 options
const String GHOST_RESP_IDS = 'response_ids';

/// The text of the ghost's response
const String GHOST_RESP_TEXT = 'text';




/* USER RESPONSE TABLE */

/// Name of the table
const String USER_RESP_TABLE = 'user_responses';

/// User response Primary Key
const String USER_RESP_ID = 'id';

/// Ghost ID
const String USER_RESP_GHOST_ID = 'gid';

/// Current Level
const String USER_RESP_LEVEL = 'level';

/// ID of the chosen response
const String USER_RESP_RID = 'rid';

/// ID of the ghost response this response links to
const String USER_RESP_GRID = 'grid';

/// Message type. 0 = Normal text, 1 = action text.
const String USER_RESP_TYPE = 'type';

/// Effect this has on points. 0 = none, -1 = 20% slower, -2 = 40% slower
const String USER_RESP_EFFECT = 'effect';

/// The amount of points a response gives.
const String USER_RESP_POINTS = 'points';

/// The text of this response
const String USER_RESP_TEXT = 'text';



/* Default Interaction Table */

/// The default interaction responses table
const String DEFAULT_RESP_TABLE = 'interactions';

/// User response Primary Key
const String DEFAULT_RESP_ID = 'id';

/// The ghost these are for
const String DEFAULT_RESP_GHOST_ID = 'gid';

/// The level these are particular to (if any)
const String DEFAULT_RESP_LEVEL = 'level';

/// The user's question to the ghost
const String DEFAULT_RESP_USER = 'user_resp';

/// The ghost's response to the question
const String DEFAULT_RESP_GHOST = 'ghost_resp';

/// The amount of points asking this questions nets
const String DEFAULT_RESP_POINTS = 'points';