# 0011. Run a callback for every frame entered

## About this document

This record decides when and how a frame script and a completion script run. Read it before you change `__resnip_playback_enter`, `__resnip_playback_complete` or the arguments a callback receives. It covers the calling form, the moment a script runs, and what a callback may do to the playback. It does not cover the order of the end of a snip, which is [0004](./0004-describe-the-end-of-a-snip-with-a-mode-and-a-completion-rule.md). Update it when the calling form changes.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- Every callback is called as `callback(argument, playback)`. A frame script runs once for every frame the playback enters, on the step the frame appears.
- Never skip the script of a frame the playback crossed.

## Context and problem statement

AESnips runs a frame script one step after the frame appears, only for the frame where a step lands, and calls a script either as a method or through `script_execute` with a different argument list. The script of the last frame never runs when that frame lasts one step, and with a start image of 0 the script of the first frame does not run again when the snip restarts (observed in AESnips 0.1.4, 2026-10-14).

## Decision outcome

`callback(argument, playback)` is the only calling form, for a frame script and for the completion script. A frame script runs when the frame is entered, including the first frame of a snip, which runs inside `resnip_play`, and the frame `resnip_play_from` starts on ([0019](./0019-start-a-snip-on-a-chosen-frame.md)). One script is allowed per frame, and a second one is an error. A callback may stop the playback, change its speed, pause it or play another snip. A callback that plays another snip replaces the current one, and the completion that started it does not start a second one.

## Considered options

- Run the script one step after the frame appears, as AESnips does, was refused, because the script and the picture then disagree.
- Run only the script of the frame where a step lands was refused, because a high speed would lose scripts.
- Keep both calling forms was refused, because one form removes the choice from the user.

## Consequences

- Pinned by tests in the suite `callbacks`, among them `a frame script receives its argument`, `a frame script receives the playback that entered the frame`, `completion runs before the script of the frame it wraps to`, `the script of the last frame runs when it is entered`, `the frames a large step crosses run their scripts in order`, `scripts run in reverse order while playing backward`, `a callback that stops the playback holds it on that frame`, `a callback that plays another snip replaces the current one` and `the rest of a step runs at the speed of the snip a callback started`.
- User code runs inside `resnip_play` and `resnip_step`, so it can re-enter them. The tests above cover play, stop, speed and pause, and a callback that throws is not covered, which is a gap.
- A person who knows AESnips sees scripts one step earlier, as [0001](./0001-rewrite-aesnips-with-structs-and-one-playback-core.md) says.
