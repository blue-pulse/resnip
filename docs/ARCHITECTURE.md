# Resnip architecture

## About this document

This document is the map of Resnip, a sprite animation library for GameMaker. It is for someone who needs to find their way around before changing it. It follows the structure of matklad's article "ARCHITECTURE.md" (2021): a bird's-eye view, a codemap, invariants, boundaries and cross-cutting concerns.

It contains what rarely changes: the shape of the library, where things live, what must always hold, where one part ends and another begins, and the concerns that cut across all of them. It names files and functions without linking to them, so search for a name to find it. It leaves out the rules to follow, which are [CONTRIBUTING.md](./CONTRIBUTING.md), the reasons behind each larger choice, which are the records in [decisions/](./decisions/), and how GameMaker, Igor and AESnips behave, which is [reference/](./reference/).

Update it when a part is added, removed or renamed, or when an invariant or boundary changes. Revisit it as a whole from time to time instead of on every change.

## Bird's-eye view

Resnip plays a sprite, or a run of its sub-images, as an animation. A **snip** is the definition: a sprite, a frame range, speeds, loops, scripts and an end behaviour. A **player** holds all the state of one animation that plays a snip: the frame, the direction, the progress inside the frame and what comes next. The game calls `resnip_player_step` once per step, and the player spends the time of that step frame by frame. Everything else is built around that call.

The one fact the rest follows from: the player is the only code that plays. A snip never changes after setup, and an instance never holds state of the library. Instance mode, drawing and the debug panel read a player and add nothing to it.

## Codemap

The disk holds one folder per GameMaker resource (`scripts/<name>/`, `objects/<name>/`). The IDE shows a virtual tree, and this codemap names the resource folders of that tree, `Scripts/Resnip`, `Scripts/Resnip/(System)`, `Tests/Harness`, `Tests/Suites` and `Tests/Bench`.

### Entry points and configuration

- `resnip.yyp` is the project file, and `resnip.resource_order` the order of its resources. Both are fragile (`P001`).
- `rm_init` and `obj_init` read the environment variable `RESNIP_MODE` and go to `rm_test` for `test`, `rm_bench` for `bench`, and `rm_main`, the demo, otherwise.
- `__resnip_constants` holds the version, the enums `RESNIP_END`, `RESNIP_COMPLETE` and `RESNIP_STOP`, and the direction macros. `__resnip_config` holds the defaults. `__resnip_system` holds the library state.

### Public API

Every public name starts with `resnip_`, and each has JSDoc.

- Snip: `resnip_snip_create`, `resnip_snip_clone`, `resnip_snip_set_next`.
- Transition: `resnip_transition_add`, `resnip_transition_find`, `resnip_transition_remove`.
- Clock and game speed: `resnip_clock_create`, `resnip_clock_default`, `resnip_clock_set_scale`, `resnip_set_game_speed`.
- Player: `resnip_player_create`, `resnip_player_play`, `resnip_player_step`, `resnip_player_stop`, `resnip_player_cancel_next`, `resnip_player_set_speed`, `resnip_player_set_loop_repeats`, `resnip_player_set_frame_speed`.
- Conversion: `resnip_frame_to_image`, `resnip_image_to_frame`.
- Adapters: `resnip_instance_sync`, `resnip_player_draw`, `resnip_player_draw_ext`, and the debug panel `resnip_debug_draw`.

### Internal code

`Scripts/Resnip/(System)` holds the scripts that start with `__resnip_`. The player is moved by `__resnip_player_move` (one frame forward or back, with the loop edge), `__resnip_player_enter` (loops and the frame script), `__resnip_player_finish` (the end of a snip), `__resnip_player_complete` and `__resnip_player_play_next` (completion and what plays next), `__resnip_player_reset_loops` and `__resnip_player_give_up`. The rest are helpers: `__resnip_loop_repeat`, `__resnip_sprite_scale`, `__resnip_check_frame`, `__resnip_snip_build_*`, `__resnip_options_merge`, `__resnip_transition_key`, `__resnip_next_id` and `__resnip_error`.

### Demo, tests and benchmark

- The demo is `rm_main` with `obj_red_cowboy`, `obj_blue_cowboy`, `obj_ping_pong`, `obj_runner`, `obj_bullet` and `obj_explain`. It uses the sprites in `sprites/`.
- The tests are `rm_test` with `obj_resnip_test`. See [Tests](#tests).
- The benchmark is `rm_bench` with `obj_resnip_bench`, `__resnip_bench_create` and `__resnip_bench_step`. It prints `[BENCH] players=N loops=M step_us=...` lines.
- `tools/` holds the Python command line (`gm.py` with `doctor`, `run`, `test` and `bench`), which finds a runtime, builds the Igor command and reads the `[RESULT]` line of the test run.

### Tests

`python tools/gm.py test` runs `rm_test`. The suites are `end`, `speed`, `loops`, `flow`, `input`, `state`, `callbacks`, `properties` and `debug`. On 2026-10-15 they held 171 plain tests and one scenario, 172 in all, and all passed on the VM and on YYC. Re-run before citing that count.

Time is deterministic: `__resnip_test_reset` sets the game speed to 15 before each test, so a sprite of 15 frames per second moves one frame per step. A test calls `resnip_player_step` with a number of steps and reads the player. `properties` is the architectural check: it runs 200 seeded cases per property against the invariants below. `__resnip_test_known_failure` registers a fault that is known and not fixed.

## Invariants

- A snip is not written after setup, apart from its `next`. The test `playing never changes the snip` detects a write during play.
- All playback state lives in the player. No variable of the library is added to an instance.
- The frame of a player is always inside `[0, count - 1]`. The property `the frame stays inside the snip` detects it.
- Two steps give the same result as one step of their sum. The property `two steps give the same result as one step of their sum` detects it.
- A script runs for every frame entered, never only for the frame where a step lands.
- The library reads no global, asset or setting of the game, so the game speed arrives through `resnip_set_game_speed`. No test detects it, and it holds by attention alone (`C013`).
- Every public function has JSDoc, and every internal name starts with `__`. No test detects it.

## Boundaries

### Definition and state

A snip answers no question about time. A player answers all of them and never writes the snip. A change that must differ per user, a loop count or a frame speed, is an override stored in the player ([0002](./decisions/0002-keep-playback-state-in-the-player-and-fix-the-snip.md)).

### Core and adapters

The core is the clock and the player with the single step. The adapters, `resnip_instance_sync`, the drawing functions and the debug panel, depend on the core and the core does not know them ([0008](./decisions/0008-sync-an-instance-from-a-player.md)).

### Library and game

The game hands values in through functions, and the library never reaches into the game. The sprite functions of GameMaker are the only calls into the game, and they read the sprite given to `resnip_snip_create`.

### Library and tests

Tests may read internal fields of a player, such as `__progress`, and may call `__resnip_system`. The library never calls a test. A test names the behaviour of Resnip in its own terms (`T007`).

### Project and tools

`tools/gm.py` runs the project through Igor and reads only the `[RESULT]` line and the exit code. The game decides the exit code in `__resnip_test_finish`: 1 when a test failed or none ran.

## Cross-cutting concerns

### Time and speed

The step algorithm lives in `resnip_player_step` ([0003](./decisions/0003-advance-time-with-an-integer-frame-and-an-accumulator.md)). The sprite scale is read from the sprite when the snip is created, and the game speed is read at each step.

### Callbacks

A frame script and a completion script are called as `callback(argument, player)` ([0011](./decisions/0011-run-a-callback-for-every-frame-entered.md)). They run inside `resnip_player_play` and `resnip_player_step`, so they can call both again.

### Errors and messages

`__resnip_error` throws a string that starts with `[ERROR]` and says what was received and what to pass instead. Input is checked where it can be wrong: snip creation, the setters and the transition functions. A warning goes to the debug output with `[WARNING]` ([0010](./decisions/0010-hold-a-snip-whose-every-frame-is-skipped.md)).

### Shared state

`__resnip_system` holds the game speed, the default clock, the transition registry and an id counter. The registry keeps its snips until `resnip_transition_remove` is called.

## Glossary

- **Snip.** A fixed definition of an animation: sprite, frame range, speeds, loops, scripts and end behaviour.
- **Sub-image.** One image of a GameMaker sprite, counted from 0 in the sprite.
- **Frame.** One image of a snip, counted from 0 at its first sub-image. `resnip_frame_to_image` and `resnip_image_to_frame` convert.
- **Player.** The state of one animation that plays a snip.
- **Clock.** A struct with `paused` and `scale` that players share.
- **Loop.** A run of frames of a snip that plays once and then repeats a count of times. A count below 0 skips it.
- **Transition.** A snip that plays between two others, found by from and to.
- **Step.** One game step, the unit of the step function.
- **Instance, object, room.** GameMaker's running object, the template of an instance, and a scene.
- **VM and YYC.** The two GameMaker compilers: bytecode, and C++ compiled to native code.
- **Igor.** The command line tool that ships with every GameMaker runtime, described in [reference/igor.md](./reference/igor.md).

## Third-party components

| Component | Version | Responsibility | Licence | Copyright holder |
| --- | --- | --- | --- | --- |
| AESnips | 0.1.4 | The concepts Resnip carries over, written again as new code | MIT, see `LICENSE` | William Jones |
| Sprites in `sprites/` | Not recorded | Art of the demo and the tests | Not established | Not established |

The licence of the sprites is item 4 of [PENDING.md](./PENDING.md). GameMaker itself and its runtime are not part of the repository.
