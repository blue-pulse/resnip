# Decisions

## About this document

This document records what Resnip does with each idea of AESnips 0.1.4. It is for the maintainer, who approves it before any code is written. It holds the layers of the design, one row per idea with a verdict and a reason, and the points that still need an answer. It leaves out function signatures, which are written once the rows are approved. Update it when a row changes.

Verdicts are **Keep**, **Change** and **Drop**. A row marked **Proposed** needs the maintainer to confirm it.

## Layers

Each layer depends only on the ones above it in this list.

| Layer | Holds | Depends on |
| --- | --- | --- |
| Definitions | Snip and transition. Plain data, fixed after creation | Nothing |
| Core | Clock and player. All playback state and the single step that changes it | Definitions |
| Adapters | Instance sync, drawing and debug panel. Optional | Core |

The game hands values in through functions. The library never reads a global, an asset or a setting of the game.

## Decisions

| Idea in AESnips | Verdict | What Resnip does | Why |
| --- | --- | --- | --- |
| Snip as a definition apart from playback state | Keep | Same split. A snip holds sprite, frame range, speeds, loops, scripts and end behaviour | Many players share one snip with no copy |
| Snips that anyone can modify | Drop | A snip is fixed after creation. Changes live in the player | A shared snip never changes under another user |
| Speed per frame times speed of the snip | Keep | Frame speeds are an array in the snip. The snip speed is a field | Removes manual timing code |
| Speed of the snip changed while playing | Change | A validated setter on the player | The definition stays shared |
| Respect the speed type of the sprite | Keep | The scale is read when the snip is created. The game speed comes in through a setup function | The scale no longer goes stale and the library reads nothing from the game |
| Float `image_index` with epsilon | Drop | Integer frame plus a time accumulator | Exact frames, no lost scripts, no drift |
| Frame numbers relative to the snip mixed with sub-images | Drop | Frames are relative to the snip everywhere. Two helpers convert to and from sub-images | One convention |
| Loops with a repeat count, `repeat + 1` passes, below 0 skips | Keep | Same meaning. The first matching loop in creation order is the active one | The demo depends on this order |
| Loop repeat changed while the game runs | Change | A per-player override set with the loop struct, read from `snip.loops` | The snip stays fixed and the demo case still works. A name would collide between snips |
| Seven end types | Change | **Proposed.** `end_mode` with HOLD, REWIND, REPEAT and PINGPONG. `complete_on` with EDGE or CYCLE, read only by PINGPONG | Splits what happens at the end from when the snip is complete |
| Successor, queued snip and transition target | Change | One rule for what plays next. Order: player queue, then the `next` of the snip, then a transition if one is found | Replaces three code paths with one |
| Transitions found by from and to | Keep | A registry in the library state, not lists inside snips | A snip points to no other snip and the registry can be replaced whole |
| Reverse clone of a transition | Drop | A transition can be played backward by an option | The same snip serves both ways |
| Direction on the snip and on the instance | Change | Direction lives only in the player | One place holds the truth |
| Backward playback | Keep | An option of `play` | Needed by transitions |
| Global pause as a global variable | Change | A clock struct passed to players, with pause and scale | The shared state is visible and can be grouped |
| Script on a frame with an argument | Keep | Called as `callback(argument, player)`, once for every frame the player enters | One calling form and no skipped frames at high speed |
| Script when a snip completes | Keep | Same call form | Same reason |
| Queue for the next snip | Keep | Part of the rule for what plays next | See above |
| Standalone player | Keep | It is the core | It is the only playback code |
| Instance mode as the main mode | Change | **Proposed.** One function copies sprite and frame from a player to the calling instance and sets `image_speed` to 0. No state is added to the instance | Keeps masks and `draw_self` working, with no second playback code |
| About 60 getters and setters | Drop | Read the struct fields. Setters only where input can be wrong | Less API to keep |
| `snip_clone_loops`, `snip_clone_transitions` | Drop | None | The clone covers it |
| `snip_clone` | Change | One `clone` that accepts overrides | The way to vary a fixed snip |
| `ds_list`, `delete`, `snip_destroy_*` | Drop | Structs and arrays freed by the collector. One function removes a transition from the registry | No leaks and no stale references |
| `snip_play_request` | Drop | An option of `play` that skips the call if the snip already plays | Same operation |
| Playback logic written twice | Drop | One core | A fix is made once |
| Time in steps, as `image_speed` | Keep | The player step takes an optional number of steps | Same result by default, delta time possible |
| Debug panel | Change | A separate optional module that reads a player | The core carries no drawing code for debugging |
| Lookup table by frame for loops | Drop for now | Not built until a benchmark with many players shows the scan costs something | Rule of the project |

## Equivalence of end types

**Proposed.** How the seven original end types map to the new options, with forward playback and a whole-frame position.

| Original | New |
| --- | --- |
| `end_stop`, `end_stop_tail` | HOLD |
| `end_stop_head` | REWIND |
| `end_repeat` | REPEAT |
| `end_pingpong` | PINGPONG with EDGE |
| `end_pingpong_head` | PINGPONG with CYCLE, starting forward |
| `end_pingpong_tail` | Not equal. See below |

`end_pingpong_tail` completes the first time the snip reaches the tail, and CYCLE completes when it returns to where it started. A third value of `complete_on` is added only if the maintainer needs this case.

## Settled while building

- The instance function stays, as `resnip_instance_sync`.
- Four end modes and two completion rules are built. The `end_pingpong_tail` case is not covered.
- `next` is set once after creation with `resnip_snip_set_next`, the only change allowed to a snip.
- Library state is one static struct in `__resnip_system`. The default clock lives there and `resnip_clock_default` returns it.
- Pause is the `paused` field of a player or a clock, so there are no pause and resume functions.
- A pingpong turn does not repeat the edge frame, which the original did.
- A skipped loop does not run the script of its first frame, which the original did.
- A loop wraps back at its end each pass, so the free pass after the last repeat plays once more, as in the original.

## Known limits

- A loop that covers the whole snip with a count below 0 never ends in REPEAT or PINGPONG, because every cycle skips it again.
- The transition registry holds its snips until `resnip_transition_remove` is called.
- A sprite set in frames per game frame is read by the same code as one in frames per second, but no test covers it.
