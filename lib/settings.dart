library settings;

const Duration ONE_SECOND = Duration(seconds: 1);

/// Length of day/night cycle: 2 hours
const int DAY_NIGHT_LENGTH = 7200;

/// Length of day/night cycle in dev: 30 seconds
const int DAY_NIGHT_LENGTH_DEV = 30;

/// Length of the energy well timer
const int ENERGY_WELL_LENGTH = DAY_NIGHT_LENGTH ~/ 2;

/// Length of the energy well timer in dev
const int ENERGY_WELL_LENGTH_DEV = DAY_NIGHT_LENGTH_DEV ~/ 2;

/// Length of the candle timer
const int CANDLE_LENGTH = DAY_NIGHT_LENGTH ~/ 4;

/// Length of the candle timer in dev
const int CANDLE_LENGTH_DEV = DAY_NIGHT_LENGTH_DEV ~/ 4;
