library constants;

/// Database filename
const String DB_NAME = 'data.db';


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

/// Current Accumulated Points for the ghost. INTEGER
const String GHOST_SCORE = 'score';

/// If the ghost is "assigned" to user. BOOLEAN
const String GHOST_ACTIVE = 'active';