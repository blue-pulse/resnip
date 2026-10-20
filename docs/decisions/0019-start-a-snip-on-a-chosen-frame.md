# 0019. Start a snip on a chosen frame

## About this document

This record decides how a snip starts on a frame other than its first or its last. Read it before you change `resnip_play_from`, the arguments of `__resnip_playback_start`, or before you add a way to move a playback to a frame. It covers the function, what it does with loops, scripts, direction, the queue and transitions, the errors, how the start is shared with `resnip_play`, and what was refused. It does not cover what plays next, which is [0005](./0005-decide-what-plays-next-with-one-rule.md), or loops that skip every frame, which is [0010](./0010-hold-a-snip-whose-every-frame-is-skipped.md). Update it when another way to choose where a snip starts is added.

- Status: accepted
- Date: 2026-10-19
- Decision-makers: the maintainer

## Summary

- `resnip_play_from(playback, snip, frame, [backward])` starts the snip now on that frame of the snip, at the beginning of the frame, and enters it like any other frame.
- Never move a playback to a frame without starting the snip again, and never keep a second copy of what a start resets.

## Context and problem statement

A snip always started on its first frame, or on its last when played backward. Two uses need another frame: resuming an animation where it was left, and starting many copies of one animation on different frames so they do not move in step. A third use was weighed: a character with one sprite per direction that turns without starting its walk again.

The maintainer asked that what works today keep working the same, and that a game ask explicitly for a start frame.

## Decision outcome

`resnip_play_from` is a function of its own, named by its verb ([0014](./0014-name-the-functions-that-act-on-a-player-by-their-verb.md)).

- The frame is a frame of the snip, like every other frame of the library, and `resnip_image_to_frame` converts a sub-image. It is checked with `__resnip_check_frame`, so a frame outside `[0, count - 1]` or not whole raises `[ERROR] resnip_play_from received frame F but the snip has N frames, numbered 0 to N-1. Use a whole number in that range.`
- `backward` is read as `_backward ?? false`, with no default argument ([0017](./0017-enter-the-next-frame-in-the-step-and-allocate-only-what-is-used.md)).
- It starts the snip through `__resnip_playback_start`, the same code as `resnip_play`, with its fifth argument set to the frame. The playback drops a queued snip and the target of a transition, resets its loops and its skip count, sets its progress to 0, and enters the frame. A loop that holds it is entered with its passes at 0, a loop with a count below 0 is skipped as at any other frame, and the script of the frame runs ([0011](./0011-run-a-callback-for-every-frame-entered.md)). Loops that lie wholly before the frame keep their passes at 0 until the end of the snip resets them, so they play if the direction turns back to them.
- It looks for no transition and queues nothing. `resnip_play`, the queue and `__resnip_playback_play_next` pass `undefined` as the frame and behave as before.
- It returns `true`, like `resnip_play`.

The step does not change, a playback keeps its 17 fields, and the frame stays inside `[0, count - 1]` because it is checked against the snip that starts. Two steps still give the same result as one step of their sum, because a start acts before any step.

## Considered options

- **An option `frame` of `resnip_play`** was built and measured. It reads one more option on every call that has options, about 47 ns on YYC and 178 ns on the VM, and it raises questions that the function avoids: what a frame means with a transition, which plays another snip first, and whether the queue keeps it. A frame given with `restart: false` would also be ignored without a word.
- **A function `resnip_play_ext` with every option as an argument** was refused, because `_ext` in GameMaker promises everything the base function does and more, and this one does less on purpose.
- **Give the start its own copy of the reset** was refused, because two copies of what a start resets would be two owners of one fact, and a reset changed in one would not change in the other.
- **Move the reset to a helper that `__resnip_playback_start` and `resnip_play_from` both call** was measured and refused. `resnip_play` became 6.5 percent slower on YYC with options and 12.6 percent without, against 0.990 and 1.015 for the fifth argument.
- **Read the fifth argument with `_frame ?? (...)`** was measured and refused for an `if`. It was about 3 percent slower on YYC, at the edge of the noise, so the `if` is kept with a comment.
- **A function that moves a playback to a frame of the snip it plays** was refused. It would have to decide what happens to a loop that is half played, to its passes and to the skip count, which a new start answers with a reset.
- **Keep the progress of the frame when the snip changes** was refused for now. It serves the character that turns, but one playback drawn with the sprite of the direction keeps the frame, the progress, the loops and the scripts with no new code, as the recipe in the [README](../../README.md#recipes) shows. A playback that starts another snip on the same frame loses the time spent in it: with frames of four steps, starting the other snip every two steps held the playback on its first frame for eight steps. Adding the progress later is one more argument of this function.
- **Start on a frame through a transition or the queue** was refused for now, because nobody asked for it. Resuming after an interruption is a call to `resnip_play_from` from the completion script of the interruption. Adding the queue later changes only this function and the struct of the queue.
- **Skip the script of the start frame** was refused. The frame is entered, so its script runs, and a game that must not repeat a sound when it resumes can check that in the callback.

## Consequences

- Cost. Method: as in [0018](./0018-let-a-snip-ask-for-the-durations-of-its-sprite.md), runtime 2026.0.0.23, 2026-10-19, and the repository does not let anyone repeat it.
  - The step does not change. With both this record and [0018](./0018-let-a-snip-ask-for-the-durations-of-its-sprite.md) applied, against the code before, the geometric mean of the mean step was 1.011 on YYC and 0.998 on the VM, and creating and playing a playback 0.998 and 1.009. Memory of a playback: unchanged, 832 and 1 216 bytes.
  - `resnip_play` itself, median of 24 repetitions of 20 000 calls, the library as committed against the code before: with options and without, 1.025 and 1.051, 1.002 and 0.998, and 1.002 and 1.009 in three runs on YYC, so the first run was noise, and 1.004 and 1.021 on the VM.
- Behaviour when no frame is given was checked against the code before with the fixed trace of 2 240 steps and 2 000 random scenarios on the VM and on YYC, with no difference.
- Pinned by the tests in the suite `flow` under "Start frame" and in the suite `input` under "Start frame". Each was checked by breaking the code once (rule `T004`).
- A character that turns by starting another snip on the same frame shows that frame a little longer at each turn, which is accepted and documented with the recipe.
- Without this decision, a game that resumes an animation or desynchronises copies of it keeps no way to start on a frame, or a second copy of what a start resets drifts from the first.
