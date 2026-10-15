# Decisions

## About this document

This document records the design of Resnip and the reason for each choice. It is for the maintainer and for anyone who wants to know why the library works as it does. It holds the layers of the design, the decisions, what was settled while building, the known limits, and a guide for people who come from AESnips, the library Resnip is based on. It leaves out function signatures, which the JSDoc of each function gives. Update it when a decision changes.

## Layers

Each layer depends only on the ones above it in this list.

| Layer | Holds | Depends on |
| --- | --- | --- |
| Definitions | Snip and transition. Plain data, fixed after creation | Nothing |
| Core | Clock and player. All playback state and the single step that changes it | Definitions |
| Adapters | Instance sync, drawing and debug panel. Optional | Core |

The game hands values in through functions. The library never reads a global, an asset or a setting of the game.

## Decisions

| Topic | What Resnip does | Why |
| --- | --- | --- |
| Definition and state | A snip holds sprite, frame range, speeds, loops, scripts and end behaviour. A player holds all playback state | Many players share one snip with no copy |
| Fixed snips | A snip is fixed after creation. Changes live in the player. `resnip_snip_clone` accepts overrides to make a variation, and `resnip_snip_set_next` is the only change allowed to a snip | A shared snip never changes under another user |
| Speed | Frame speeds are an array in the snip and are multiplied by the speed of the snip. A speed of 0 holds a frame or a snip. The speed of a player and the speed of one of its frames are changed with validated setters | Removes manual timing code and keeps the definition shared |
| Sprite speed type | The scale is read when the snip is created. The game speed comes in through `resnip_set_game_speed` | The library reads nothing from the game |
| Time model | An integer frame plus a time accumulator. The rest of a step passes to the next frame and to the next snip | Exact frames, no lost scripts, no drift |
| Frame numbers | Frames are relative to the snip everywhere. `resnip_frame_to_image` and `resnip_image_to_frame` convert | One convention |
| Loops | A loop plays once and then repeats its count, so a count of N gives N + 1 passes. A count below 0 skips the loop. The first matching loop in creation order is the active one | Simple rule that also covers a skipped loop |
| Changes at runtime | The loop count and the speed of a frame are overrides of one player, set with `resnip_player_set_loop_repeats` and `resnip_player_set_frame_speed` | The snip stays fixed and a name would collide between snips |
| End of a snip | `end_mode` is HOLD, REWIND, FASTFORWARD, REPEAT or PINGPONG. `complete_on` is EDGE, HEAD or TAIL and only PINGPONG reads it | Separates what happens at the end from when the snip is complete |
| What plays next | One rule. The order is the player queue, then the target of a running transition, then the `next` of the snip. Each one carries its own transition setting and direction. A transition is looked up when the queue or the `next` asks for one | One code path for all three |
| Transitions | A registry in the library state, found by from and to. A transition can play backward by an option | A snip points to no other snip and the registry can be replaced whole |
| Direction | Lives only in the player. Backward is an option of `play` and of the `next` of a snip | One place holds the truth |
| Pause | A clock struct with `paused` and `scale`, shared by players. A player has its own `paused`. A pause set inside a callback ends the step in progress | The shared state is visible and can be grouped |
| Callbacks | Called as `callback(argument, player)` once for every frame the player enters, and for the completion of a snip | One calling form and no skipped frames at high speed |
| Standalone player | The player is the core and the only playback code | A fix is made once |
| Instance mode | `resnip_instance_sync` copies sprite and frame from a player to the calling instance and sets `image_speed` to 0. No state is added to the instance | Masks and `draw_self` keep working with no second playback code |
| Access | Read the struct fields. Setters exist only where input can be wrong | Less API to keep |
| Memory | Structs and arrays freed by the collector. `resnip_transition_remove` takes a transition out of the registry | No leaks and no stale references |
| Time in steps | The step takes an optional number of steps | Same result by default, delta time possible |
| Debug panel | A separate optional module that reads a player | The core carries no drawing code for debugging |
| Lookup table by frame for loops | Not built until a benchmark with many players shows the scan costs something | Rule of the project |

## Settled while building

- A pingpong turn does not repeat the edge frame.
- A skipped loop does not run the script of its first frame.
- A frame script runs on the step the frame is entered.
- A snip speed and a frame speed must not be negative. A speed of 0 holds, and the player moves again when the speed of that frame changes for the player or the player plays another snip.
- A change to the speed of a frame lasts while the player plays the same snip.
- Stopping a player forgets the target of its transition.
- A snip whose every frame is skipped by loops with a count below 0 holds its last frame and prints a warning, since it would otherwise end again and again without playing a frame.

## Known limits

- The transition registry holds its snips until `resnip_transition_remove` is called.
- A snip with a frame speed of 0 never completes by itself, so a snip that follows it must be played by the game.

## Coming from AESnips

Resnip keeps the concepts of AESnips and changes how they are written. This table maps its seven end types.

| AESnips | Resnip |
| --- | --- |
| `end_stop` | HOLD |
| `end_stop_head` | REWIND |
| `end_stop_tail` | FASTFORWARD |
| `end_repeat` | REPEAT |
| `end_pingpong` | PINGPONG with EDGE |
| `end_pingpong_head` | PINGPONG with HEAD |
| `end_pingpong_tail` | PINGPONG with TAIL |

What a person who knows AESnips will notice.

- A loop plays its whole range on every pass. AESnips started each repeat on the second frame of the loop.
- A frame script runs on the step its frame appears, one step earlier than in AESnips, and the script of the last frame runs.
- A pingpong turn does not repeat the edge frame.
- A step that crosses frames uses the speed of each frame, and the rest of a step passes on instead of being lost.
- A direction belongs to the player and is asked for with the `backward` option, not set on the snip. A snip that plays backward after another one carries the option in its `next`.
- The successor, the queued snip and the target of a transition are one rule. `snip_play_request` is the `restart` option of `resnip_player_play`.
- Pausing, loop counts and frame speeds are set for one player or one clock. They never change a snip that others share.
- Instance mode is `resnip_instance_sync` on top of a player.
