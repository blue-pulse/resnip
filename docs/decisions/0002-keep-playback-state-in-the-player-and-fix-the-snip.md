# 0002. Keep playback state in the player and fix the snip

## About this document

This record decides where state lives. Read it before you add a field to a snip, a function that changes a snip, or a setting that must differ per user of one snip. It covers the split between snip and player, the per-player overrides of a loop count and of a frame speed, and `resnip_snip_clone`. It does not cover how time advances, which is [0003](./0003-advance-time-with-an-integer-frame-and-an-accumulator.md), and it does not cover what plays next, which is [0005](./0005-decide-what-plays-next-with-one-rule.md). Update it when a second kind of run-time override is added.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- A snip is plain data, fixed after creation. A player holds every piece of state that changes.
- Never write a field of a snip after setup, except through `resnip_snip_set_next`.

## Context and problem statement

In AESnips a snip is shared by every user, and it can also be changed by anyone through its accessors, so a change meant for one animation reaches all of them. A loop count or a frame speed changed in the demo applies to every runner that uses the snip.

## Decision outcome

A snip holds sprite, frame range, speeds, loops, scripts and end behaviour. A player holds the current snip, frame, direction, speed, progress and queue.

Run-time changes are overrides of one player:

- `resnip_player_set_loop_repeats` stores a count keyed by the loop struct, because a name would collide between snips. It applies at the next entry to the loop or the next loop edge, and it survives `resnip_player_play`.
- `resnip_player_set_frame_speed` copies the speeds of the snip into the player on the first change and writes the copy. It lasts while the player plays the same snip, and playing another snip drops it, because a frame index means nothing in another snip.

`resnip_snip_clone` builds a new snip from the options of another with some replaced. Loops of the clone get new identities, so overrides set for the source do not apply to it.

## Considered options

- Allow setters on the snip, as AESnips does, was refused, because a shared snip would change under its other users.
- Key a loop override by a name was refused, because two snips can use the same name.
- Keep the frame speed override across snips was refused, because the frame index has no meaning there.

## Consequences

- Many players share one snip with no copy. The test `players on one snip do not affect each other` and `playing never changes the snip` in the suite `properties` hold this over 200 seeded cases each.
- `snip.__options` is a shallow copy, so changing an array that was passed to `resnip_snip_create` after the call changes later clones. That is a gap and not a decision, read from the code and not run.
- `resnip_snip_set_next` can change a shared snip at any time, not only during setup. The JSDoc says setup only, and nothing enforces it. That is a gap and not a decision, read from the code and not run.
