# ghost_app [![Build Status](https://travis-ci.org/cse442-spring-2020-offering/cse442-semester-project-bugs-are-features.svg?branch=development)](https://travis-ci.org/cse442-spring-2020-offering/cse442-semester-project-bugs-are-features)

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
| Name  | Purpose                                                              |
| ----- | -------------------------------------------------------------------- |
| ghost | Stores state info (score, progress, attitude) for the current ghost. |

#### ghost Table

Here are the current columns. Note that these are defined as constants in `db/constants.dart`. *Don't hardcode these.* `import 'constants.dart' as Constants` from the `db` library.

| Name        | Data Type | Purpose                                                                                                                                                                         |
| ----------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id          | `INTEGER` | Primary key. Autoincrements.                                                                                                                                                    |
| temperament | `INTEGER` | Whether the ghost is Angry `0`, Neutral `1`, or Friendly `2`.                                                                                                                   |
| difficulty  | `INTEGER` | How obnoxious/difficult the ghost is. Easy `0`, Medium `1`, Hard `2`                                                                                                            |
| level       | `INTEGER` | The ghost's current level through the story. Starts at 2 if not a first-time player. Maximum is 10.
| score       | `INTEGER` | The "points" earned from good interactions with your ghost, giving them life force, and the like. Default is `0`, becomes `1` when a ghost is chosen. Determines progress made. |
| active      | `BOOLEAN` | Whether or not a ghost is currently selected and being played. May not strictly be necessary to store, but will likely be useful.                                               |
| candle_lit  | `BOOLEAN` | Whether or not the candle is currently lit. When the candle is lit, the ghost in inaccessible.

#### ghost_responses Table

This table houses all story responses a ghost might say to a user *during a level-up event*. They should be queried by `gid, level, rid`.
See: `lib/db/db.dart : getLevelingGhostResp`

| Name        | Data Type | Purpose                                                                                                                                                                         |
| ----------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id          | `INTEGER` | Primary key. Autoincrements.                                                                                                                                                    |
| gid         | `INTEGER` | The current ghost's id. Begins at `1` |
| level       | `INTEGER` | The story level to which this response belongs to. |
| rid         | `INTEGER` | The response id. The `rid` is unique to a given `gid, level`. It's the node id in a level's story graph. |
| response_ids| `STRING`  | May also be referred to as `rids`. This string is in the format of `"1,2,3,4"` where each number corresponds to a response response id. |
| text        | `STRING`  | The actual ghost response displayed to the user.

#### user_responses Table

This table houses all user response options a user may give to a ghost *during a level-up event*. They should be queried with `gid, level, grid`.
See: `lib/db/db.dart : getLevelingUserResp`

| Name        | Data Type | Purpose                                                                                                                                                                         |
| ----------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id          | `INTEGER` | Primary key. Autoincrements.                                                                                                                                                    |
| gid         | `INTEGER` | The current ghost's id. Begins at `1` |
| level       | `INTEGER` | The story level to which this response belongs to. |
| rid         | `INTEGER` | The **ghost's** response id. This is the `rid` *in the `ghost_responses` table* that this user response links to and prompts. The names of `rid` and `grid` should be switched. |
| grid        | `INTEGER` | This is the unique response id of *this, the user's* response option to the ghost. It's the unique node in the level's story tree belonging to this user response. |
| type        | `INTEGER` | This determines the *type* of response this is. In almost every case this should be `0`, which is a normal response. `1` types are reserved for action responses, like "you hear a ghost sneeze" |
| effect      | `INTEGER` | This determines whether or not choosing a given user response causes ill-effects, or not. In almost every case this will be `0` for no effect, but bad effects (e.g. slower progression) should be `-1` for bad and `-2` for very bad.|
| points      | `INTEGER` | The amount of points a response gives. Should range from 0 - 5. |
| text        | `STRING`  | The user response text displayed on the button. |

#### interactions Table

This table is currently unpopulated and contains only 4 dummy data. These are the `user-response`->`ghost-response` interaction pairs available at all times (when not leveling).


| Name        | Data Type | Purpose                                                                                                                                                                         |
| ----------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id          | `INTEGER` | Primary key. Autoincrements.                                                                                                                                                    |
| gid         | `INTEGER` | The ghost that this particular interaction belongs to. |
| level       | `INTEGER` | The *minimum* ghost level this particular interaction belongs to. |
| user_resp   | `STRING`  | The user's question or statement to the ghost. The text on the button. |
| ghost_resp  | `STRING`  | The ghost's response to the user's prompt. |
| points      | `INTEGER` | The number of points this interaction gives. Should range from 0 - 5. |
