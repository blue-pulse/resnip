# 0001. Rewrite AESnips with structs and one playback core

## About this document

This record decides that Resnip is a rewrite of AESnips that keeps its concepts and replaces its code. Read it before you add a feature that AESnips had, or before you ask why a behaviour differs from it. It covers what is kept, what changes, what is dropped, how the end types map, and what a person who knows AESnips will notice. It does not cover the detail of each change, which are records [0002](./0002-keep-playback-state-in-the-player-and-fix-the-snip.md) to [0011](./0011-run-a-callback-for-every-frame-entered.md), and it does not describe AESnips itself, which is [reference/aesnips.md](../reference/aesnips.md). Update it when a kept concept is dropped or a dropped one returns.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- Keep the concepts of AESnips and write the code again with structs, arrays and one playback core.
- Never copy AESnips code, and never add an AESnips feature unless it removes code from the person who uses it or allows what cannot be done otherwise.

## Context and problem statement

AESnips 0.1.4, by William Jones under the MIT licence, plays sprite animations with very little code. It was written before structs, arrays and method variables became the normal way to write GML. It keeps three `ds_list` per snip, adds `ae_snip_` variables to the calling instance, advances a float `image_index` with an epsilon, writes playback logic twice (instance and standalone player), reaches "what plays next" by three paths, and has about 60 accessors and a global pause variable. Reading its code found ten faults, listed in [reference/aesnips.md](../reference/aesnips.md). The maintainer considers upstream inactive, so there is nothing to merge back.

## Decision outcome

Resnip keeps these concepts: a snip as a definition apart from playback state, a speed per frame multiplied by the speed of the snip, loops with a repeat count that can change at run time, transitions found by from and to, a queue and a successor for what plays next, a script on a frame with an argument, a script on completion, backward playback, the speed type of the sprite, and a standalone player.

Resnip changes how they are built:

- Playback state lives in a player and the snip is fixed ([0002](./0002-keep-playback-state-in-the-player-and-fix-the-snip.md)).
- Time is an integer frame plus an accumulator ([0003](./0003-advance-time-with-an-integer-frame-and-an-accumulator.md)).
- The seven end types become five end modes and three completion rules ([0004](./0004-describe-the-end-of-a-snip-with-a-mode-and-a-completion-rule.md)).
- Queue, successor and transition target become one rule ([0005](./0005-decide-what-plays-next-with-one-rule.md)).
- Direction lives in the player ([0006](./0006-keep-direction-in-the-player.md)) and pause in a clock ([0007](./0007-share-pause-and-scale-through-a-clock.md)).
- Instance mode becomes one sync function ([0008](./0008-sync-an-instance-from-a-player.md)).

Resnip drops the accessors (read the struct field), the clones of loops and transitions (one `resnip_snip_clone`), `ds_list` and manual destruction, `snip_play_request` (the `restart` option of `resnip_play`), and the playback logic written twice.

### End types

| AESnips | Resnip |
| --- | --- |
| `end_stop` | HOLD |
| `end_stop_head` | REWIND |
| `end_stop_tail` | FASTFORWARD |
| `end_repeat` | REPEAT |
| `end_pingpong` | PINGPONG with EDGE |
| `end_pingpong_head` | PINGPONG with HEAD |
| `end_pingpong_tail` | PINGPONG with TAIL |

### What a person who knows AESnips will notice

- A loop plays its whole range on every pass. AESnips began each repeat on the second frame of the loop.
- A frame script runs on the step its frame appears, one step earlier than in AESnips, and the script of the last frame runs.
- A pingpong turn does not repeat the edge frame.
- A step that crosses frames uses the speed of each frame, and the rest of a step passes on.
- A direction belongs to the player. A snip that plays backward after another one carries the option in its `next`.
- Pausing, loop counts and frame speeds are set for one player or one clock, and never change a snip that others share.
- A speed of 0 holds a frame, as in AESnips, but a snip cannot be changed to release it. Use `resnip_set_frame_speed` ([0009](./0009-let-a-speed-of-zero-hold-a-frame.md)).

## Considered options

- Port the code file by file was refused, because it carries the faults, the `ds_list` and the duplicated playback logic.
- Keep instance mode as the main mode was refused, because it needs state on the calling instance and a second playback code.
- Fix AESnips upstream was refused, because the maintainer considers upstream inactive.

## Consequences

- A person who migrates from AESnips changes their calls. The function map is in the JSDoc of `resnip_play`, `resnip_snip_clone`, `resnip_snip_set_next`, `resnip_set_loop_repeats`, `resnip_set_frame_speed` and `resnip_transition_add`.
- The differences above are observed, not assumed. Both libraries ran 106 scenarios on 2026-10-14: AESnips 0.1.4 through its `SnipPlayer` on a 2024.14 runtime, and Resnip through a copy of the project. Thirty scenarios gave the same frames and events, 14 gave the same frames with scripts one step earlier in Resnip, and 62 differed. The scenarios and the catalogue that classifies each difference are kept outside the repository, in `.sandbox/`, so nobody else can repeat this measurement.
- Instance mode of AESnips was not run. Its behaviour depends on the order in which the runner advances `image_index` between the Step and Draw events, which is an unverified assumption.
