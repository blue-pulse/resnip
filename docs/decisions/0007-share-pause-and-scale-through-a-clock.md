# 0007. Share pause and scale through a clock

## About this document

This record decides how pause and time scale are shared. Read it before you add a global pause, a time scale or a function that pauses a playback. It covers the clock struct, the default clock, the `paused` field of a playback, and a pause set inside a callback. It does not cover the speed formula, which is [0003](./0003-advance-time-with-an-integer-frame-and-an-accumulator.md). Update it when a field is added to the clock.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- A clock is a struct with `paused` and `scale`. A playback follows one clock and has its own `paused`.
- Never add a global variable for pause, and never add pause and resume functions, because a field says it.

## Context and problem statement

AESnips pauses everything with the global variable `AE_SNIP_GLOBAL_IS_PAUSED`, and pauses one animation with `snip_pause`. In the standalone `SnipPlayer`, `snip_pause` and `snip_resume` write a variable that it never reads, so they do nothing (observed in AESnips 0.1.4, 2026-10-14).

## Decision outcome

`resnip_clock_create` returns a clock, `resnip_clock_default` returns the one that lives in the library state, and `resnip_clock_set_scale` validates the scale. A playback made without a clock follows the default. A step does nothing when the playback or its clock is paused. A pause set by a callback ends the step in progress, because the step checks it after each callback and after each move that goes through `__resnip_playback_move`.

## Considered options

- A global variable was refused, because it hides the shared state.
- `pause` and `resume` functions were refused, because they only write one field.

## Consequences

- Pinned by tests: `a paused playback holds even when the clock runs`, `a paused clock holds the playback`, `the default clock pauses its playbacks`, and in the suite `callbacks` `a callback that pauses the playback ends the step in progress` and `a callback that pauses the clock ends the step in progress`. Removing the pause checks after a callback fails two tests, and removing the pause checks at the top of the step fails four (checked on 2026-10-19).
- The check after each frame move costs about 3 to 4 percent on YYC at the worst case of the benchmark. The method is in [0003](./0003-advance-time-with-an-integer-frame-and-an-accumulator.md), and it is unverified from the repository. That cost is accepted. The step now makes that check only after a callback or after a move through `__resnip_playback_move`, and the cost was not measured again.
- The time that remains in a step when a callback pauses the playback is dropped, which is accepted.
