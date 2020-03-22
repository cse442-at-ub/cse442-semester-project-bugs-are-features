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

///Name of the table
const String GHOST_RESPONSES_TABLE = 'ghost-responses';

///Ghost response Primary Key
const String GRESPONSE_PK = 'ghost-response-PK';

///Level of the response
const String LEVEL = 'level';

///Id of the response
const String PIB = 'pib';

///Id of the response options : 4 options
const String RESPONSE_IDS = 'response-ids';

///Encrypted ghost id
const String ENCR_GHOST_ID = 'encr-ghost-id';


/* USER RESPONSE TABLE */

///Name of the table
const String USER_RESPONSES_TABLE = 'user-responses';

///User response Primary Key
const String URESPONSE_PK = 'user-response-PK';

///Id of the chosen response
const String UID = 'user-response-id';