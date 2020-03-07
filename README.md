# ghost_app

A spooky ghost game

## Documentation

### Current List of Preferences
| Name         | Type   | Default |
| ------------ | ------ | ------- |
| first_launch | `bool` | `true`  |
| has_ghost    | `bool` | `false` |
| ghost_id     | `int`  | `0`     |

## Database

### Tables
| Name        | Purpose                 |
| ----------- | ----------------------- |
| ghost       | Stores state info (score, progress, attitude) for the current ghost. |

#### ghost Table

Here are the current columns. Note that these are defined as constants in `db/constants.dart`. *Don't hardcode these.* `import 'constants.dart' as Constants` from the `db` library.

| Name        | Data Type | Purpose             |
| ----------- | --------- | ------------------- |
| id          | `INTEGER` | Primary key. Autoincrements. |
| temperament | `INTEGER` | Whether the ghost is Angry `0`, Neutral `1`, or Friendly `2`. |
| difficulty  | `INTEGER` | How obnoxious/difficult the ghost is. Easy `0`, Medium `1`, Hard `2` |
| progress    | `INTEGER` | How much progress you've made through the ghost's story. `0` is a fresh game, while `10` is learned cause of death. |
| score       | `INTEGER` | The "points" earned from good interactions with your ghost, giving them life force, and the like. Default is `0`, becomes `1` when a ghost is chosen. Determines progress made. |
| active      | `BOOLEAN` | Whether or not a ghost is currently selected and being played. May not strictly be necessary to store, but will likely be useful. |


## Twine

We will be using Twine. 