# Decisions

## About this document

This document records the design of Resnip and the reason for each choice. It is for the maintainer and for anyone who wants to know why the library works as it does. It holds the layers of the design, the decisions, what was settled while building, and the known limits. It leaves out function signatures, which the JSDoc of each function gives. Update it when a decision changes.

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
| Speed | Frame speeds are an array in the snip and are multiplied by the speed of the snip. The speed of a player is changed with a validated setter | Removes manual timing code and keeps the definition shared |
| Sprite speed type | The scale is read when the snip is created. The game speed comes in through `resnip_set_game_speed` | The library reads nothing from the game |
| Time model | An integer frame plus a time accumulator. The rest of a step passes to the next frame and to the next snip | Exact frames, no lost scripts, no drift |
| Frame numbers | Frames are relative to the snip everywhere. `resnip_frame_to_image` and `resnip_image_to_frame` convert | One convention |
| Loops | A loop plays once and then repeats its count, so a count of N gives N + 1 passes. A count below 0 skips the loop. The first matching loop in creation order is the active one | Simple rule that also covers a skipped loop |
| Loop count at runtime | A per-player override set with `resnip_player_set_loop_repeats`, keyed by the loop struct | The snip stays fixed and a name would collide between snips |
| End of a snip | `end_mode` is HOLD, REWIND, REPEAT or PINGPONG. `complete_on` is EDGE or CYCLE and only PINGPONG reads it | Separates what happens at the end from when the snip is complete |
| What plays next | One rule. The order is the player queue, then the target of a running transition, then the `next` of the snip. A transition is looked up when the queue or the `next` asks for one | One code path for all three |
| Transitions | A registry in the library state, found by from and to. A transition can play backward by an option | A snip points to no other snip and the registry can be replaced whole |
| Direction | Lives only in the player. Backward is an option of `play` | One place holds the truth |
| Pause | A clock struct with `paused` and `scale`, shared by players. A player has its own `paused` | The shared state is visible and can be grouped |
| Callbacks | Called as `callback(argument, player)` once for every frame the player enters, and for the completion of a snip | One calling form and no skipped frames at high speed |
| Standalone player | The player is the core and the only playback code | A fix is made once |
| Instance mode | `resnip_instance_sync` copies sprite and frame from a player to the calling instance and sets `image_speed` to 0. No state is added to the instance | Masks and `draw_self` keep working with no second playback code |
| Access | Read the struct fields. Setters exist only where input can be wrong | Less API to keep |
| Memory | Structs and arrays freed by the collector. `resnip_transition_remove` takes a transition out of the registry | No leaks and no stale references |
| Time in steps | The step takes an optional number of steps | Same result by default, delta time possible |
| Debug panel | A separate optional module that reads a player | The core carries no drawing code for debugging |
| Lookup table by frame for loops | Not built until a benchmark with many players shows the scan costs something | Rule of the project |

## Settled while building

- Four end modes and two completion rules are built.
- A pingpong turn does not repeat the edge frame.
- A skipped loop does not run the script of its first frame.
- A frame script runs on the step the frame is entered.
- A snip speed and a frame speed must be above 0. To freeze a player, set its speed to 0.
- A pingpong that completes only when it first reaches the tail is not covered.
- A hold that jumps to the last frame while playing backward is not covered.

## Known limits

- The transition registry holds its snips until `resnip_transition_remove` is called.
- The tests in the suite `known` describe faults that are not fixed yet. A loop below 0 that covers the whole snip never ends a repeating snip. A queued snip loses its direction. Stopping a player keeps the target of its transition. A pause set inside a callback does not end the step in progress.
