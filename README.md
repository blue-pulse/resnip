# Resnip

![Status: WIP](https://img.shields.io/badge/status-WIP-yellow)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](./LICENSE)
[![GameMaker LTS 2026](https://img.shields.io/badge/GameMaker-LTS%202026-black)](https://gamemaker.io)
[![Language: GML](https://img.shields.io/badge/language-GML-green)](https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Overview/GML_Overview.htm)
[![Based on AESnips](https://img.shields.io/badge/based%20on-AESnips-orange)](https://github.com/angelwire/AESnips)

Sprite animation for GameMaker. A full rewrite of [AESnips](https://github.com/angelwire/AESnips), built for the techniques and standards of GameMaker LTS 2026.

## Purpose

AESnips is a good idea held back by its age. It was written before structs, arrays and method variables became the normal way to write GML, and it keeps its state in data structures and in instance variables. Resnip keeps the ideas and rewrites the code, so that a library for playing animations follows what a GameMaker LTS 2026 project expects today.

The rewrite aims at the following.

- **Current language features.** Structs and arrays in place of data structures, so GameMaker's garbage collector frees what is no longer used.
- **One playback core.** Playing through an instance and playing apart from one share the same code, so a fix is made once.
- **No hidden state.** The state of an animation lives in its playback and not in variables added to the calling instance.
- **A clear public API.** Public names start with `resnip_`, everything internal is marked as private, and every public function is documented in the editor.
- **Predictable behaviour.** One convention for frame numbers, and a check for bad input that says what went wrong and how to fix it.

## What it does

Resnip keeps the concepts of AESnips.

- A **snip** is a sprite, or a run of its sub-images, with a speed.
- A **loop** repeats chosen frames of a snip a number of times.
- A **transition** plays a connecting snip between two snips.
- A snip can run a script on a chosen frame, follow another snip when it ends, and play forward, backward or back and forth.
- Snips can be queued, paused and resumed one by one or all at once.
- A snip can start on any of its frames, and can follow the duration that the sprite editor gives each frame.

## Recipes

Each recipe uses only the public functions. The code of each was run as a test in a copy of the project on 2026-10-19, with runtime 2026.0.0.23 on the VM and on YYC, except the drawing, which was not run.

### Hitstop

Give the fighters of a hit a clock of their own, and pause it for a few steps when the hit lands. A paused clock holds every playback on its frame and keeps the time already spent in it, so the animation resumes exactly where it stopped.

```gml
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

Set `paused` on one playback instead to stop only that one, and use `resnip_clock_set_scale` for a slow motion instead of a stop.

### An intro and a part that repeats

Make two snips of one sprite, the intro and the part that repeats, and make the second the next of the first. The intro plays once and the second part repeats.

```gml
var _body = resnip_snip_create(spr_charge, { first_image: 4, last_image: 9 });
var _intro = resnip_snip_create(spr_charge, { first_image: 0, last_image: 3, next: _body });
resnip_play(playback, _intro);
```

### One animation, one sprite per direction

When the sprites of the directions have the same frames and the same timing, play one snip and draw with the sprite of the direction. The frame, the time inside it, the loops and the scripts all carry over when the character turns, because the playback never changes.

```gml
// Create
walk = resnip_snip_create(spr_walk_down);
sprites = [spr_walk_right, spr_walk_up, spr_walk_left, spr_walk_down];
resnip_play(playback, walk);

// Draw
draw_sprite(sprites[facing], resnip_frame_to_image(playback.snip, playback.frame), x, y);
```

With `resnip_instance_sync`, set `sprite_index = sprites[facing]` after the call. When the directions have different timings, give each its own snip and turn with `resnip_play_from(playback, snip, playback.frame)`, which keeps the frame but starts it again, so each turn shows that frame a little longer.

## Requirements

- GameMaker LTS 2026. The project file records IDE version 2026.0.0.16, and the tests ran with runtime 2026.0.0.23.
- Python, for the command line tools in `tools/`. The minimum version is `requires-python` in `tools/pyproject.toml`.

## Run it

1. Open `resnip.yyp` in GameMaker and press run for the demo, or from the repository root run:

   ```sh
   python tools/gm.py doctor
   python tools/gm.py run
   ```

   `doctor` shows what the tools found and what is missing. `run` builds the project with Igor on the VM and starts the demo.

The commands for the tests and the benchmark are in [docs/CONTRIBUTING.md](./docs/CONTRIBUTING.md#commands).

## Project organisation

| Path | What it holds |
| --- | --- |
| `scripts/` | The library (`resnip_*`, `__resnip_*`), the tests (`__resnip_test_*`) and the benchmark (`__resnip_bench_*`) |
| `objects/`, `rooms/` | The demo, the test room and the benchmark room |
| `sprites/` | Art for the demo and the tests |
| `tools/` | The Python command line that runs the project with Igor |
| `docs/` | The documentation |

The IDE shows the scripts in virtual folders, and on disk each resource has its own folder.

## Where to go next

We recommend reading the following documents in the order listed.

- [docs/PRINCIPLES.md](./docs/PRINCIPLES.md): the principles every change is judged against.
- [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md): the map of the library, its invariants and its boundaries.
- [docs/CONTRIBUTING.md](./docs/CONTRIBUTING.md): the commands and the rules that bind everyone who works on it.
- [docs/decisions/](./docs/decisions/): why each larger choice was made, what was refused, and what differs from AESnips.
- [docs/reference/](./docs/reference/): how AESnips, Igor, GMS MCP and the GameMaker manual behave.
- [docs/PENDING.md](./docs/PENDING.md): the known work that is unfinished.
- [AGENTS.md](./AGENTS.md): where an AI coding agent starts.

## Credits and licence

Resnip is based on [AESnips](https://github.com/angelwire/AESnips) by William Jones, whose [documentation](https://docs.google.com/document/d/1JSGG1mfid8lOiSictlqFUEiaxrTep1TUyvLne1Z2Yr0) explains the concepts it carries over. It is released under the MIT licence. See [LICENSE](./LICENSE).
