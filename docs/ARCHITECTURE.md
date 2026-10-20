# Resnip architecture

## About this document

This document is the map of Resnip, a sprite animation library for GameMaker. It is for someone who needs to find their way around before changing it. It follows the structure of matklad's article "ARCHITECTURE.md" (2021): a bird's-eye view, a codemap, invariants, boundaries and cross-cutting concerns, with a glossary and a table of third-party components added.

It contains what rarely changes: the shape of the library, where things live, what must always hold, where one part ends and another begins, and the concerns that cut across all of them. It names files and functions without linking to them, so search for a name to find it. It leaves out the rules to follow, which are [CONTRIBUTING.md](./CONTRIBUTING.md), the reasons behind each larger choice, which are the records in [decisions/](./decisions/), and how GameMaker, Igor and AESnips behave, which is [reference/](./reference/).

Update it when a part is added, removed or renamed, or when an invariant or boundary changes. Revisit it as a whole from time to time instead of on every change.

## Bird's-eye view

Resnip plays a sprite, or a run of its sub-images, as an animation. A **snip** is the definition: a sprite, a frame range, speeds, loops, scripts and an end behaviour. A **playback** holds all the state of one animation that plays a snip: the frame, the direction, the progress inside the frame and what comes next. The game calls `resnip_step` once per step, and the playback spends the time of that step frame by frame. Everything else is built around that call.

The one fact the rest follows from: the playback is the only code that plays. A snip never changes after setup, and an instance never holds state of the library. Instance mode, drawing and the debug panel read a playback and add nothing to it.

## Codemap

The disk holds one folder per GameMaker resource (`scripts/<name>/`, `objects/<name>/`). The IDE shows a virtual tree, shaped by the rules `S001` to `S007` of [CONTRIBUTING.md](./CONTRIBUTING.md), and this codemap names its folders from what depends on nothing to what depends on it.

- `Resnip` is the library, and the only folder a user exports. What a user may call sits in `Definitions`, `Playback`, `Clocks` and `Adapters`. `_Internal` holds everything else, which may change in any version without notice.
- `Bootstrap` holds `rm_init` and `obj_init`, the entry of the demo, the tests and the benchmark.
- `Demo` holds the demo: `Logic` for its objects, room and script, and `Sprites` with `Cowboys` and `Movement`.
- `Tests` holds `Harness` (the test runner and its helpers), `Suites` and `Bench` (the benchmark).

### Entry points and configuration

- `resnip.yyp` is the project file, and `resnip.resource_order` the order of its resources. Both are fragile (`P001`).
- `rm_init` and `obj_init` read the environment variable `RESNIP_MODE` and go to `rm_test` for `test`, `rm_bench` for `bench`, and `rm_main`, the demo, otherwise.
- `resnip_constants` holds the version, the enums `RESNIP_END`, `RESNIP_COMPLETE` and `RESNIP_STOP`, and the direction macros, which a user needs. `__resnip_constants` holds two internal values. `__resnip_config` holds the defaults. `__resnip_system` holds the library state.

### Public API

Every public name starts with `resnip_`, and each has JSDoc. Anything in `Resnip` outside `_Internal` is public, and anything in `_Internal` is exempt from compatibility, as PEP 8 allows for internal interfaces. The library is at 0.x, so even the public names may change, as item 4 of Semantic Versioning allows for major version zero (both read on 2026-10-19 through a page summariser).

- Snip: `resnip_snip_create`, `resnip_snip_clone`, `resnip_snip_set_next`.
- Transition: `resnip_transition_add`, `resnip_transition_find`, `resnip_transition_remove`.
- Clock: `resnip_clock_create`, `resnip_clock_default`, `resnip_clock_set_scale`.
- Playback: `resnip_playback_create`, `resnip_play`, `resnip_play_from`, `resnip_step`, `resnip_stop`, `resnip_cancel_next`, `resnip_set_speed`, `resnip_set_loop_repeats`, `resnip_set_frame_speed`.
- Conversion: `resnip_frame_to_image`, `resnip_image_to_frame`.
- Adapters: `resnip_instance_sync`, `resnip_draw`, `resnip_draw_ext`, and the debug panel `resnip_debug_draw`.

### Internal code

`Resnip/_Internal` holds the scripts that start with `__resnip_`. `resnip_step` enters the next frame itself when it is not the edge of a loop or of the snip and no loop would be entered or skipped there. `__resnip_playback_move` (one frame forward or back, with the loop edge) takes every other move. The playback is also moved by `__resnip_playback_start` (what `resnip_play`, `resnip_play_from` and what plays next do to start a snip), `__resnip_playback_enter` (loops and the frame script), `__resnip_playback_loop_waits` (whether entering a frame would enter or skip a loop), `__resnip_playback_finish` (the end of a snip), `__resnip_playback_complete` and `__resnip_playback_play_next` (completion and what plays next), `__resnip_playback_reset_loops` and `__resnip_playback_give_up`. The rest are helpers: `__resnip_loop_repeat`, `__resnip_check_frame`, `__resnip_snip_build_*`, `__resnip_options_merge`, `__resnip_transition_key`, `__resnip_next_id` and `__resnip_error`.

### Demo, tests and benchmark

- The demo is `rm_main` with `obj_red_cowboy`, `obj_blue_cowboy`, `obj_ping_pong`, `obj_runner`, `obj_bullet` and `obj_explain`. It uses the sprites in `Demo/Sprites`.
- The tests are `rm_test` with `obj_resnip_test`. See [Tests](#tests).
- The benchmark is `rm_bench` with `obj_resnip_bench`, `__resnip_bench_create` and `__resnip_bench_step`. It prints `[BENCH] playbacks=N loops=M step_us=...` lines.
- `tools/` holds the Python command line (`gm.py` with `doctor`, `run`, `test` and `bench`), which finds a runtime, builds the Igor command and reads the `[RESULT]` line of the test run.

### Tests

`python tools/gm.py test` runs `rm_test`. The suites are `end`, `speed`, `loops`, `flow`, `input`, `state`, `callbacks`, `properties` and `debug`. On 2026-10-19 the run reported 192 tests, and all passed on the VM and on YYC. Re-run before citing that count.

Time is deterministic: `__resnip_test_reset` sets the gamespeed of the engine to 15 with `game_set_speed` before each test, so a sprite of 15 frames per second moves one frame per step. A test calls `resnip_step` with a number of steps and reads the playback. `properties` is the architectural check: it runs 200 seeded cases per property against the invariants below. `__resnip_test_known_failure` registers a fault that is known and not fixed.

## Invariants

- A snip is not written after setup, apart from its `next`. The test `playing never changes the snip` detects a write during play.
- All the state of an animation lives in the playback. No variable of the library is added to an instance.
- The frame of a playback is always inside `[0, count - 1]`. The property `the frame stays inside the snip` detects it.
- Two steps give the same result as one step of their sum. The property `two steps give the same result as one step of their sum` detects it.
- A script runs for every frame entered, never only for the frame where a step lands.
- `resnip_step` and `__resnip_playback_move` apply the same loop rules, so a rule changed in one must change in the other ([0017](./decisions/0017-enter-the-next-frame-in-the-step-and-allocate-only-what-is-used.md)). Breaking the loop edge, the loop test or the script call of the step on its own fails tests (checked on 2026-10-19), and no test compares the two paths directly.
- The library reads no global, asset or setting of the game, apart from the gamespeed of the engine, which it reads with `game_get_speed(gamespeed_fps)`. No test detects it, and it holds by attention alone (`C013`).
- Every public function has JSDoc, and every internal name starts with `__`. No test detects it.

## Boundaries

### Definition and state

A snip answers no question about time. A playback answers all of them and never writes the snip. A change that must differ per user, a loop count or a frame speed, is an override stored in the playback ([0002](./decisions/0002-keep-the-state-in-the-playback-and-fix-the-snip.md)).

### Core and adapters

The core is the clock and the playback with the single step. The adapters, `resnip_instance_sync`, the drawing functions and the debug panel, depend on the core and the core does not know them ([0008](./decisions/0008-sync-an-instance-from-a-playback.md)).

### Library and game

The game hands values in through functions, and the library never reaches into the game. The sprite functions of GameMaker are the only calls into the game, and they read the sprite given to `resnip_snip_create`. `sprite_get_info` is called only for a snip that asks for `sprite_durations`.

### Library and tests

Tests may call `__resnip_system`, and one of them reads the internal `__key` of a loop. `T010` asks for public results otherwise. The library never calls a test. A test names the behaviour of Resnip in its own terms (`T007`).

### Project and tools

`tools/gm.py` runs the project through Igor and reads only the `[RESULT]` line and the exit code. The game decides the exit code in `__resnip_test_finish`: 1 when a test failed or none ran.

## Cross-cutting concerns

### Time and speed

The step algorithm lives in `resnip_step` ([0003](./decisions/0003-advance-time-with-an-integer-frame-and-an-accumulator.md)). The sprite scale is read from the sprite when the snip is created, and so are the durations of its frames when the snip asks for them with `sprite_durations` ([0018](./decisions/0018-let-a-snip-ask-for-the-durations-of-its-sprite.md)). The gamespeed is read from the engine at each step ([0013](./decisions/0013-read-the-gamespeed-from-the-engine.md)).

### Changing speed while the game runs

Three controls change the pace of animations during play, and none of them touches the gamespeed of the engine. `resnip_set_speed(playback, x)` changes one playback. `resnip_clock_set_scale(clock, x)` changes every playback that follows the clock, so `resnip_clock_default()` gives a slow motion for all of them. `resnip_step(playback, steps)` takes a fraction of a step, which serves delta time: `resnip_step(playback, delta_time / 1000000 * game_get_speed(gamespeed_fps))` keeps an animation on the clock of the wall when the game runs below its gamespeed. The gamespeed is the target the game is set to, and `fps_real` is what it achieves.

### Callbacks

A frame script and a completion script are called as `callback(argument, playback)` ([0011](./decisions/0011-run-a-callback-for-every-frame-entered.md)). They run inside `resnip_play` and `resnip_step`, so they can call both again.

### Errors and messages

`__resnip_error` throws a string that starts with `[ERROR]` and says what was received and what to pass instead. Input is checked where it can be wrong: snip creation, the setters and the transition functions. A warning goes to the debug output with `[WARNING]` ([0010](./decisions/0010-hold-a-snip-whose-every-frame-is-skipped.md)).

### Shared state

`__resnip_system` holds the default clock, the transition registry and an id counter. The registry keeps its snips until `resnip_transition_remove` is called.

## Glossary

- **Snip.** A fixed definition of an animation: sprite, frame range, speeds, loops, scripts and end behaviour.
- **Sub-image.** One image of a GameMaker sprite, counted from 0 in the sprite.
- **Frame.** One image of a snip, counted from 0 at its first sub-image. `resnip_frame_to_image` and `resnip_image_to_frame` convert.
- **Playback.** The state of one animation that plays a snip.
- **Clock.** A struct with `paused` and `scale` that playbacks share.
- **Loop.** A run of frames of a snip that plays once and then repeats a count of times. A count below 0 skips it.
- **Transition.** A snip that plays between two others, found by from and to.
- **Step.** One game step, the unit of the step function.
- **Gamespeed.** The steps per second that the game is set to run at, `game_get_speed(gamespeed_fps)`. It is the target and not the measured rate.
- **Instance, object, room.** GameMaker's running object, the template of an instance, and a scene.
- **VM and YYC.** The two GameMaker compilers: bytecode, and C++ compiled to native code.
- **Igor.** The command line tool that ships with every GameMaker runtime, described in [reference/igor.md](./reference/igor.md).

## Third-party components

| Component | Version | Responsibility | Licence | Copyright holder |
| --- | --- | --- | --- | --- |
| AESnips | 0.1.4 | The concepts Resnip carries over, written again as new code | MIT, see `LICENSE` | William Jones |

GameMaker itself and its runtime are not part of the repository.
