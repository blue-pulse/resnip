# 0009. Let a speed of zero hold a frame

## About this document

This record decides what a speed of 0 means. Read it before you validate a speed or change what `resnip_step` does with a rate of 0. It covers the speed of a snip, the speed of a frame, and the per-playback frame speed. It does not cover the speed formula, which is [0003](./0003-advance-time-with-an-integer-frame-and-an-accumulator.md), or the playback speed, which is a validated setter. Update it when a speed gets a new limit.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- A speed of a snip or a frame is 0 or above. A rate of 0 holds the playback on its frame and spends no time.
- Never reject 0 in a definition, and never let a snip release a held frame, because a snip is shared.

## Context and problem statement

AESnips allows a speed of 0 for a frame and for a snip, and a script can release a held frame with `snip_set_frame_speed`. That function changes the snip for everyone ([0002](./0002-keep-the-state-in-the-playback-and-fix-the-snip.md)). A snip with a frame at 0 never moves past it in AESnips, and a snip at speed 0 reaches its end handler every step (read from the code of AESnips 0.1.4, not run).

## Decision outcome

`resnip_snip_create` accepts a `speed` and a frame speed of 0 or above and rejects a negative one with a message that points at the `backward` option. `resnip_step` ends the step when a rate is 0 or below. `resnip_set_frame_speed(playback, frame, speed)` changes a frame for one playback, accepts 0 and `undefined`, and rejects a negative speed, a frame outside the snip and a playback with no snip.

## Considered options

- Reject 0 in a definition was refused, because AESnips allows it as the way to hold a frame, and a held frame is a real use.
- Let the snip release a held frame was refused, because it changes the snip for every user.

## Consequences

- Pinned by tests in the suite `speed`: `a snip speed of zero holds the first frame`, `a frame speed of zero holds that frame`, `changing the speed of a held frame releases it`, `a frame speed set on a playback leaves the snip and other playbacks alone`, `restarting the same snip keeps the frame speeds of a playback` and `playing another snip drops the frame speeds of a playback`. Ignoring the playback's speeds in the step fails four tests (checked on 2026-10-15).
- A snip with a frame at 0 never completes by itself. The game must play something else. That is accepted.
