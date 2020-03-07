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

We used [Twine](https://twinery.org/) to generate the story-based gamely in the application.

### Initial Setup

To export it to JSON format after creating the sotry you would have to add it manually as Twine does not support JSON export by default (Credits: [Twison](https://github.com/lazerwalker/twison)). If you have already added the JSON export format, skip to [Creating a Story](#creating-a-story).

1. Open the [Twine 2](https://twinery.org/2/#!/stories) online editor.
2. Click on 'Formats' button location on the right-hand side of the screen.
3. Select the 'Add a New Format.
4. Copy the following `https://lazerwalker.com/twison/format.js`and paste it into add a story format input field and press Add.
5. Select 'Twison 0.0.1 by Mike Lazer-Walker' at the end of the story formats list.

#### Note
* If you want to test your story in the browser you can change the export format to 'Harlowe 3.1.0' and click 'Play'. Then you will be able to test your story in the browser iteself.
* Twine does not have user accounts and cloud storage. It works on local browser cookies. It saves your stories by default in your browser cookies but you can also click on 'Publish to File' in the bottom bar in the menu which pops up after clicking on the name of your story. You can then import this file later in a different browser using Twine and continue your work!

You are all set to start creating an awesome ghost story!

### Creating a Story 

1. Click on the 'new story' button on the right, give your story a name and click on 'Add'.
2. You will be directed to a new screen similar to the one shown below. This is your workspace for Twine where you can edit and add new elements to your story. 
<div align="center">
<img src="/twine/Step2.png"></img> 
</div>
3. Each box, as shown in the picture below, can be treated as an interaction scene between the player and the ghost. The green rocket symbol on the top left indicates that this is the starting point of the story. You get various options after clicking on the box like delete, edit and play. 
<div align="center">
<img src="/twine/Step3.png"></img> 
</div>
4. Go ahead and click on the 'pencil icon' shown in the image above. This will open up the edit window of the box. 
5. The edit window will look like the image shown below. It has a heading on top and a message/interaction space in its body. 
<div align="center">
<img src="/twine/Step5.png"></img> 
</div>
6. Make sure to give a meaningful heading/title to the scene boxes which would describe the conversation that would take place in that particular scene. A good practice should be to keep it short. 
7. Next step is to add interaction links which will create more scene boxes and progress the story further. In the picture below I have filled out the starting scene box with some example interaction with the ghost and the player.
<div align="center">
<img src="/twine/Step7.png"></img> 
</div>
8. As shown in the picture above, you should follow these writing conventions while making an interaction:
   * The message that the ghost is saying/replying to the user choice should always be on the first line.
   * Enter each subsequent user reply to that message should be in a new line.
   * To link a user reply to a new/existing scene box, use the following format `[[Reply to the ghost->Name of the scene box to link]]`.
9. This is what your workspace should look like after you have added three replies to the ghost message in the 'Start' scene box.
<div align="center">
<img src="/twine/Step9.png"></img> 
</div>
10. After you are satisfied by the story you can export it to JSON simply by clicking on the play button on the bottom left part of the screen. This will open up a new tab with the JSON representation of the story you just created.
<br><br>
These are the basic functionalities you need to create complex non-linear stories and export it to JSON for integration in the application. The next section will have more information of the generated JSON format.

### Story JSON Format 

Below is the JSON object for the story we just created in the section above. 

```json
{
  "passages": [
    {
      "text": "Booo! This is the ghost of your past! How are you?\n[[I am doing well->Interaction 1]]\n[[I am doing ok->Interaction 2]]\n[[I am doing bad->Interaction 3]]",
      "links": [
        {
          "name": "I am doing well",
          "link": "Interaction 1",
          "pid": "2"
        },
        {
          "name": "I am doing ok",
          "link": "Interaction 2",
          "pid": "3"
        },
        {
          "name": "I am doing bad",
          "link": "Interaction 3",
          "pid": "4"
        }
      ],
      "name": "Start",
      "pid": "1",
      "position": {
        "x": "735",
        "y": "487.5"
      }
    },
    {
      "text": "",
      "name": "Interaction 1",
      "pid": "2",
      "position": {
        "x": "574",
        "y": "692.5"
      }
    },
    {
      "text": "",
      "name": "Interaction 2",
      "pid": "3",
      "position": {
        "x": "727",
        "y": "652.5"
      }
    },
    {
      "text": "",
      "name": "Interaction 3",
      "pid": "4",
      "position": {
        "x": "894",
        "y": "692.5"
      }
    }
  ],
  "name": "Ghost",
  "startnode": "1",
  "creator": "Twine",
  "creator-version": "2.3.5",
  "ifid": "203045F5-2FFF-443B-8320-987CA95FEC15"
}
```

The JSON object consists of the following elements:
1. The top level keys that are important for us to implement in the application are: `passages`, `startnode`. You can add more information in the top level to customize user experience and keep track of various things. 
2. The `passages` is the most important array of objects as it contains all the scene boxes and interactions that you created in Twine for our story.
3. Each passage object represents the scene box in twine and the important elements inside that object are:
   * `text`: Contains the message from the ghost.
   * `name`: Title/Heading of the scene box from Twine.
   * `pid`: Unique integer for every scene box object.
   * `links`: Array of objects containing the links to user reply scene boxes.
4. The format for each link object is described below:
   * `name`: The reply that the player can select 
   * `link`: The name of the next interaction scene box this reply links to.
   * `pid`: The pid of the next interaction scene box this reply links to.

While parsing the JSON file, you should ignore the objects that are not listed in the explanation above. Another thing to note is that, inside the `text` key of each passage object the ghost message is follow by `\n[[user replies]]`. As you can see from the JSON object that those user replies are already present in the `links` section so you should parse the `text` key of each passage object till `\n` to get the ghost message! 
