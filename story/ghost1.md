# Ghost 1
- Name: Samuel Tomlins 
- Born: 1608
- Died: 1634
- Age: 26
- Gender: Male
- Marital Status: Married
- Children: 0
- Country: England
- Cause of Death: Finished building a grandfather clock for Charles I, the King of England. When the clock struck midnight, a spring broke and shot out into his eye, and this killed him (somehow...). 

He was a clockmaker in 1634. At this time clockmaking was considered the most technically advanced trade out there.

## Level 0 User Question Pool
| Question | Progress |
| -------- | -------- |
| `Hello?` | `1`     |
| `Is anyone there?` | `1` |
| `Show yourself` | `0` |
| `Make a sound if you're there` | `0` |
| `I can sense a presence` | `1` |
| `Why are you here?` | `1` |
| `What would you like me to know?` | `1` |
| `Who are you?` | `1` |
| `Is there anything I can do for you?` | `0` |

## Level 0 Ghost Response Pool
| Responses |
| --------- |
| `...` |
| `<you feel cold>` |
| `<you hear nothing>` |
| `<you feel apprehensive>` |
| `<your neck tingles>` |

----

## Level 1 Level-Up Event
The ghost becomes more visible.

## Level 1 User Question Pool
| Question | Progress |
| -------- | -------- |
| `Hello?` | `1`     |
| `Is anyone there?` | `1` |
| `Show yourself` | `0` |
| `Make a sound if you're there` | `0` |
| `I can sense a presence` | `1` |
| `Why are you here?` | `1` |
| `What would you like me to know?` | `1` |
| `Who are you?` | `1` |
| `Is there anything I can do for you?` | `1` |

## Level 1 Ghost Response Pool
| Responses |
| --------- |
|`...` |
| `<you feel a slight breeze>` |
| `<you feel cold>` |
| `<you hear nothing>` |
| `<you hear a snap>` |
| `<you feel apprehensive>` |
| `<your neck tingles>` |

----

## Level 2 Level-Up Event
The ghost now becomes fully visible. This interaction is super-short and brief: just the ghost saying something and the player's response.

0. **Ghost**: `Hello, human...`
| Response | pid | Progress | Effect |
| -------- | --- | -------- | ------ |
| `Hello` | None | `5` |  None |
| `<you scream in fear>` | None | `2` | 20% slower progress |
| `Go away!` | None | `0` | 40% slower progress |
| `What's your name?` | None | `5` | None |

## Level 2 User Question Pool
| Question | Progress |
| -------- | -------- |
| `Hello`  | `1`     |
| `I can sense a presence` | `1` |
| `<you scream at the sight of a ghost>` | `0` |
| `Why are you here?` | `1` |
| `What would you like me to know?` | `1` |
| `Who are you?` | `1` |
| `Is there anything I can do for you?` | `1` |

## Level 2 Ghost Response Pool
| Response |
| -------- |
| `...` |
| `<the ghost stares at you>` |
| `<you feel cold>` |
| `<you hear a snap>` |
| `<you feel apprehensive>` |
| `<your neck tingles>` |

---

## Level 3 Level-Up Event

0. **Ghost**: `I wish I could go home...`
| Response | pid | Progress |
| -------- | --- | -------- |
| `Too bad.` | `1` | `0` |
| `Where's home?` | `2` | `10` |
| `Why?` | `3` | `5` |
| `Do ghosts have homes?` | `4` | `5` |

1. **Ghost**: `Too bad, huh? We'll see about that...` 
- Effect: 20% slower progress

2. **Ghost**: `London was home. My old home.`
- Effect: None

3. **Ghost**: `You think being a ghost is fun? I miss London.`
- Effect: None

4. **Ghost**: `That's... a good question. Sort of. But my human home was London.`
- Effect: None

## Level 3 User Question Pool
| Question | Progress |
| -------- | -------- |
| `Hello`  | `1`     |
| `I can sense a presence` | `1` |
| `<you scream at the sight of a ghost>` | `0` |
| `Why are you here?` | `1` |
| `What would you like me to know?` | `1` |
| `Who are you?` | `1` |
| `Is there anything I can do for you?` | `1` |

## Level 3 Ghost Response Pool
| Response |
| -------- |
| `...` |
| `<the ghost stares at you>` |
| `<you feel cold>` |
| `<you hear a snap>` |
| `<you feel apprehensive>` |
| `<your neck tingles>` |

---

## Level 4 Level-Up Event

0. **Ghost**: `I used to care a lot about time. Not so much anymore...`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Why?` | `1` | `5` |
| `I don't have time for this.` | `2` | `0` |
| `What's so good about time?` | `1` | `10` |
| `Oh, okay.` | `1` | `5` |

1. **Ghost**: `Keeping track of time was my job.` 

| Response | pid | Progress |
| -------- | --- | -------- |
| `How so?` | `3` | `5`      |
| `What was your job?` | `3` | `10` |
| `You had a job?` | `3` | `5` |
| `I don't care.` | `4` | `0` |

2. **Ghost**: `Then I don't have time for you. Which is ironic because I used to be a clock-maker.`

3. **Ghost**: `I was a clock maker, and among the best of them, too.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Neat!` | None | `5`      |
| `Okay.` | None | `5` |
| `That's a cool job.` | None | `10` |
| `I don't care` | None | `0` |

---

## Level 5 Level-Up Event

0. **Ghost**: `We have not formally introduced ourselves. I'm a ghost, so I know your name. Do you want to know mine?`

| Response | pid | Progress |
| -------- | --- | -------- |
| `I already know it.` | `2` | `5` |
| `Yes, absolutely!` | `1` | `10` |
| `You're just a ghost, who cares?` | `3` | `0` |
| `Sure, why not.` | `1` | `5` |

1. **Ghost**: `My name is Samuel Tomlins. Or it used to be, at least.` 

| Response | pid | Progress |
| -------- | --- | -------- |
| `Pleased to meet you, Samuel!` | `2` | `10` |
| `Can I call you Sam?` | `3` | `5` |
| `You're still just a ghost.` | `4` | `0` |
| `Good to know.` | None | `5` |

2. **Ghost**: `Likewise.`

3. **Ghost**: `No, never.`

4. **Ghost**: `That's true. And you're just a dumb human.`

---

## Level 6 Level-Up Event

0. **Ghost**: `How old do you think I am?`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Over 300 years old.` | `1` | `10` |
| `In your twenties.` | `1` | `10` |
| `Too old.` | `2` | `0` |
| `I have no clue.` | `3` | `5` |

1. **Ghost**: `I guess that's sort of right. I ... became a ghost when I was 26, but that was a long time ago.` 

| Response | pid | Progress |
| -------- | --- | -------- |
| `You're younger than I thought.` | `4` | `5` |
| `You mean died?` | `5` | `0` |
| `How long ago?` | `4` | `10` |
| `So how old are you actually?` | `4` | `5` |

2. **Ghost**: `Wrong. I died young, at 26, so I can never be too old!`

| Response | pid | Progress |
| -------- | --- | -------- |
| `You're younger than I thought.` | `4` | `5` |
| `That's up for debate.` | `5` | `0` |
| `When did you pass?` | `4` | `10` |
| `So how old are you actually?` | `4` | `5` |

3. **Ghost**: `I'll give you a hint: I am ... was ... 20 years old, plus six.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `You're younger than I thought.` | `4` | `5` |
| `You mean died?` | `5` | `0` |
| `How long ago?` | `4` | `10` |
| `So how old are you actually?` | `4` | `5` |

4. **Ghost**: `That was over 400 years ago. I was born in 1608 and ... became a ghost in 1634.`

5. **Ghost**: `Yes. Thanks for reminding me.`

---

## Level 7 Level-Up Event

0. **Ghost**: `You know what the worst part of being a ghost is?`

| Response | pid | Progress |
| -------- | --- | -------- |
| `You're dead?` | `1` | `5` |
| `It seems kind of cool to me, actually.` | `2` | `0` |
| `It must be boring.` | `1` | `5` |
| `The lack of company?` | `3` | `10` |

1. **Ghost**: `Well, yeah. But I miss my wife.` 

| Response | pid | Progress |
| -------- | --- | -------- |
| `Isn't there some way to see her?` | `5` | `10` |
| `Oh yeah, she's long gone.` | `4` | `0` |
| `I'm sorry to hear that.` | `5` | `5` |
| `Is there anything I can do?` | `5` | `5` |

2. **Ghost**: `Maybe I can help you become one.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Sorry, I didn't mean that.` | `0` | `0` |
| `Please do.` | `4` | `0` |
| `Uhh... I think I'll pass.` | `0` | `0` |
| `... what's the worst part?` | `3` | `0` |

3. **Ghost**: `Yes, exactly. I miss my wife.` 

| Response | pid | Progress |
| -------- | --- | -------- |
| `Isn't there some way to see her?` | `5` | `10` |
| `Oh yeah, she's long gone.` | `4` | `0` |
| `I'm sorry to hear that.` | `6` | `10` |
| `Is there anything I can do?` | `5` | `5` |

4. **Ghost**: `...`

5. **Ghost**: `I don't know. But as long as I'm stuck as a ghost, I won't be able to find out.`

6. **Ghost**: `Thanks. I hope that if I can be released from being a ghost, I'll be able to see her again.`

---

## Level 8 Level-Up Event

0. **Ghost**: `Back in my time, clockmaking was considered a high-tech job where I'm from.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `It doesn't seem too hard to me.` | `2` | `0` |
| `Where was this?` | `1` | `5` |
| `Were there a lot of clockmakers where you're from?` | `1` | `10` |
| `I don't really care.` | `3` | `0` |

1. **Ghost**: `I was living in London, and clockmakers weren't all that common.` 

| Response | pid | Progress |
| -------- | --- | -------- |
| `Did you have your own shop?` | `4` | `5` |
| `How many clocks did you make?` | `4` | `5` |
| `How did you learn?` | `4` | `5` |
| `What's a clock?` | `5` | `0` |

2. **Ghost**: `Take a trip to Londo and try your hand at making one then!`

3. **Ghost**: `Oh really? The King of Britain cared.`

4. **Ghost**: `I was an apprentice as a child. I had my own shop for 5 years and made 11 clocks within in it.

---

## Level 9 Level-Up Event

0. **Ghost**: `I still think back to when it happened. If only I had been a little more to the left...`

| Response | pid | Progress |
| -------- | --- | -------- |
| `A little to the left of what?` | `2` | `5` |
| `What are you talking about?` | `1` | `0` |
| `What were you doing?` | `2` | `5` |
| `When what happened?` | `1` | `0` |

1. **Ghost**: `The moment I ... become a ghost.` 

| Response | pid | Progress |
| -------- | --- | -------- |
| `A little to the left of what?` | `2` | `5` |
| `What were you doing?` | `2` | `5` |

2. **Ghost**: `I was in my shop working on a very important clock. The clock gold and jeweled, ordered by a very important person.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Who was the clock for?` | `3` | `5` |
| `What exactly happened?` | `3` | `5` |

3. **Ghost**: `Well... let me think about whether or not I want to tell you.`

---

## Level 10 Level-Up Event

0. **Ghost**: `Do you want to hear how I ... died?`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Yes.` | `1` | `5` |
| `Not really, honestly.` | `2` | `5` |
| `I've been DYING to hear this.` | `1` | `5` |
| `Yes, if you feel like telling me.` | `1` | `10` |

1. **Ghost**: `Charles I, King of Britain had ordered a clock from me. This was to be a life-changing order.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Continue` | 3 | `5` |

2. **Ghost**: `Well, I'm going to tell you anyway. The King of Britain had ordered a clock from me. This was to be a life-changing order.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Continue` | 3 | `0` |

3. **Ghost**: `He ordered a jewel-encrusted, gold-plated grandfather clock. It was to be of the highest quality, and the payment offered for it reflected that as well.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Continue` | 4 | `0` |

4. **Ghost**: `This was a very great honor, and one that was sure to bring me business for the rest of my life. The King only orders from the best.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Continue` | 5 | `0` |

5. **Ghost**: `I had nearly finished making the clock. I had the back casing open to watch the gears as the clock struck midnight and played its chime, to make sure it worked properly.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Continue` | 6 | `0` |

6. **Ghost**: `But alas, I had used the wrong spring. The tension was too high. And when it struck midnight, the spring sprung out!`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Continue` | 7 | `0` |

7. **Ghost**: `It sprung out ... directly into my eye at a high velocity! I was watching too closely.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Continue` | 8 | `0` |

8. **Ghost**: `If only that had killed me. But I didn't die right away. My eye became infected and I lost sight from it.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Continue` | 9 | `0` |

9. **Ghost**: `And then the infection overcame me and I died. It was as simple and undignified as that. I was doing what I loved, but failed to achieve what would have been the greatest accomplishment of my life.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Continue` | 10 | `0` |

10. **Ghost**: `And that is how Samuel Tomlins, the best clockmaker in London, died.`

| Response | pid | Progress |
| -------- | --- | -------- |
| `Continue` | 10 | `0` |

