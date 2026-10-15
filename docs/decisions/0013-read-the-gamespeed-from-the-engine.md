# 0013. Read the gamespeed from the engine

## About this document

This record decides where the library gets the gamespeed. Read it before you change `__resnip_sprite_scale`, add a setting that the library should read from the game, or change how the tests and the benchmark fix the pace. It covers the input of the gamespeed and how animations change pace while the game runs. It does not cover the speed formula, which is [0003](./0003-advance-time-with-an-integer-frame-and-an-accumulator.md), or the clock, which is [0007](./0007-share-pause-and-scale-through-a-clock.md). Update it when the library reads another setting of the engine.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- `__resnip_sprite_scale` reads `game_get_speed(gamespeed_fps)` at every step. There is no setter and no copy of the value in the library.
- Never add a function that the game must call for the library to run at the right pace.

## Context and problem statement

The library had `resnip_set_game_speed(fps)` and a default of 60. A game that forgot the call got no error, and a sprite of 15 frames per second at a gamespeed of 30 advanced 0.25 frames per step instead of 0.5, which is half the pace (computed from the formula of record 0003, not run). The setter also existed only to keep the library from reading the game, which rule `C006` asked for. The maintainer asked whether reading the engine is better than depending on extra calls.

## Decision outcome

The scale of a sprite in frames per second is the sprite speed divided by `game_get_speed(gamespeed_fps)`, read at each step, so it cannot be forgotten or go out of date when the game changes its gamespeed. The value is the target that the game is set to and not the measured rate, which is the right base because GameMaker converts the speed of its own sprites the same way.

Changing the pace of animations while the game runs needs no gamespeed call. `resnip_set_speed` changes one player, `resnip_clock_set_scale` changes every player of a clock, and `resnip_step` takes a fraction of a step for delta time ([ARCHITECTURE.md](../ARCHITECTURE.md#changing-speed-while-the-game-runs)).

## Considered options

- Keep the setter under a new name was refused, because it keeps the call that can be forgotten.
- Read the engine by default and let a setter override it was refused, because each step would pay one more check, and the override would bring back the same inconsistency.
- Read the gamespeed when the snip is created was refused, because a change of gamespeed would not reach a snip that already exists.

## Consequences

- Rules `C006` and `C013` name the gamespeed as their one exception. The library still reads no global, asset or setting of the game apart from it.
- The tests fix the pace through the engine. `__resnip_test_reset` calls `game_set_speed(15, gamespeed_fps)` before each test, and three tests in the suite `speed` set 60 and 30 the same way. The test `a gamespeed set during play changes the pace of a sprite in frames per second` pins that a change applies at once.
- The benchmark can no longer set the library to 15 without slowing the engine to 15. It copies the sprite and sets its speed to the gamespeed of the engine, which gives one frame per step at any gamespeed.
- The cost of calling `game_get_speed` at each step against the earlier read of a field was not measured, and no benchmark was run for this change. The library does call a native function more often, and nothing shows that it is slower.
- The 171 tests pass on the VM and on YYC after the change (2026-10-15, runtime 2026.0.0.23).
