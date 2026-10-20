<div align="center">

# Resnip

![Status: WIP](https://img.shields.io/badge/status-WIP-yellow)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](./LICENSE)
[![GameMaker LTS 2026](https://img.shields.io/badge/GameMaker-LTS%202026-black)](https://gamemaker.io)
[![Based on AESnips](https://img.shields.io/badge/based%20on-AESnips-orange)](https://github.com/angelwire/AESnips)

</div>

Resnip plays sprite animations in GameMaker. You describe an animation once, and then any number of objects can play it. It is a rewrite of [AESnips](https://github.com/angelwire/AESnips) for GameMaker LTS 2026.

## What you can do with it

- Play a whole sprite or only a range of its images.
- Choose what happens at the end: stay on the last frame, go back to the first, repeat, or play back and forth.
- Repeat some frames of a snip a number of times, then go on.
- Run a script when a chosen frame appears, and another when the snip ends.
- Make a snip follow another one, or queue snips to play one after the other.
- Play a short snip between two others, such as drawing a gun between idle and aim.
- Play forward or backward.
- Pause one animation, or pause or slow down a group of them.
- Start a snip on any of its frames.
- Follow the time that the sprite editor gives each frame.

## Example

```js
// Create
walk = resnip_snip_create(spr_walk);
playback = resnip_playback_create();
resnip_play(playback, walk);

// Step
resnip_step(playback);

// Draw
resnip_draw(playback, x, y);
```

Two words to know:

- A **snip** describes an animation: a sprite, or some of its images, plus its speed, loops, scripts and what happens at the end. A snip does not change once it is made, so many objects can share one.
- A **playback** is one animation that is playing. It knows the snip, the current frame and what plays next. You call `resnip_step` on it once per step.

By default a snip repeats when it reaches its last frame.

## Why a rewrite

AESnips was written before structs and arrays became the usual way to write GML. Resnip keeps its ideas and writes the code again.

- The state of an animation lives in a playback. Nothing is added to your instance.
- Playing with an instance and playing without one use the same code.
- It uses structs and arrays, so there is nothing to destroy by hand.
- Every public function starts with `resnip_` and has help text in the editor.
- A mistake in your input raises an error that says what was wrong and what to pass instead.

A few things behave differently from AESnips, such as when a frame script runs. [Record 0001](./docs/decisions/0001-rewrite-aesnips-with-structs-and-one-playback-core.md) lists them.

## Recipes

These use only the public functions. The code of each recipe was run as a test on 2026-10-19, with runtime 2026.0.0.23 on the VM and on YYC. The drawing was not run.

### Hitstop

Give the fighters of a hit a clock of their own, and pause it for a few steps when the hit lands. A paused clock holds every playback on its frame, and the animation goes on from the same point when the clock runs again.

```js
// Create
hit_clock = resnip_clock_create();
playback = resnip_playback_create(hit_clock);
hitstop = 0;

// When the hit lands, hold for 4 steps
hitstop = 4;

// Step
hit_clock.paused = hitstop > 0;
hitstop = max(hitstop - 1, 0);
resnip_step(playback);
```

To stop only one playback, set `paused` on that playback. For a slow motion instead of a stop, use `resnip_clock_set_scale`.

### An intro and a part that repeats

Make two snips from one sprite, and make the second the `next` of the first. The intro plays once, and then the second part repeats.

```js
var _body = resnip_snip_create(spr_charge, { first_image: 4, last_image: 9 });
var _intro = resnip_snip_create(spr_charge, { first_image: 0, last_image: 3, next: _body });
resnip_play(playback, _intro);
```

### One animation, one sprite per direction

If the sprites of all directions have the same frames and timing, play one snip and draw the sprite of the direction you face. The frame, the loops and the scripts carry over when the character turns, because the playback does not change.

```js
// Create
walk = resnip_snip_create(spr_walk_down);
sprites = [spr_walk_right, spr_walk_up, spr_walk_left, spr_walk_down];
resnip_play(playback, walk);

// Draw
draw_sprite(sprites[facing], resnip_frame_to_image(playback.snip, playback.frame), x, y);
```

If you use `resnip_instance_sync`, set `sprite_index = sprites[facing]` after the call.

If the directions have different timings, give each its own snip and turn with `resnip_play_from(playback, snip, playback.frame)`. It keeps the frame but starts it again, so each turn shows that frame a little longer.

## Install

Everything the library needs is in the folder `Resnip` of the asset browser. It uses no sprite, object, room or font of the project, so it is the only folder to export as a local package from the IDE and import into your project. Inside it, `_Internal` holds the parts you should leave alone, and the other folders hold what you can call.

## Requirements

- GameMaker LTS 2026. The project file records IDE version 2026.0.0.16, and the tests ran with runtime 2026.0.0.23.
- Python, for the command line tools in `tools/`. The minimum version is `requires-python` in `tools/pyproject.toml`.

## Run it

Open `resnip.yyp` in GameMaker and run it to see the demo. To run it from the command line, use the repository root:

```sh
python tools/gm.py doctor   # Shows what the tools found and what is missing
python tools/gm.py run      # Starts the demo with Igor on the VM
```

The commands for the tests and the benchmark are in [docs/CONTRIBUTING.md](./docs/CONTRIBUTING.md#commands).

## What is in the repository

| Path | What it holds |
| --- | --- |
| `scripts/` | The library (`resnip_*`, `__resnip_*`), the tests (`__resnip_test_*`) and the benchmark (`__resnip_bench_*`) |
| `objects/`, `rooms/` | The demo, the test room and the benchmark room |
| `sprites/` | Art for the demo and the tests |
| `tools/` | The Python command line that runs the project with Igor |
| `docs/` | The documentation |

The IDE shows the scripts in virtual folders, and on disk each resource has its own folder.

## Where to go next

Read these in order.

- [docs/PRINCIPLES.md](./docs/PRINCIPLES.md): the principles every change is judged against.
- [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md): the map of the library, its invariants and its boundaries.
- [docs/CONTRIBUTING.md](./docs/CONTRIBUTING.md): the commands and the rules for everyone who works on it.
- [docs/decisions/](./docs/decisions/): why each larger choice was made, what was refused, and what differs from AESnips.
- [docs/reference/](./docs/reference/): how AESnips, Igor, GMS MCP and the GameMaker manual behave.
- [docs/PENDING.md](./docs/PENDING.md): the known work that is unfinished.
- [AGENTS.md](./AGENTS.md): where an AI coding agent starts.

## Credits and licence

Resnip is based on [AESnips](https://github.com/angelwire/AESnips) by William Jones, whose [documentation](https://docs.google.com/document/d/1JSGG1mfid8lOiSictlqFUEiaxrTep1TUyvLne1Z2Yr0) explains the concepts it carries over. It is released under the MIT licence. See [LICENSE](./LICENSE).
