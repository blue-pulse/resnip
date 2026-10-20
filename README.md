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

## Use it

Download [`resnip.yymps`](https://github.com/blue-pulse/resnip/releases/latest/download/resnip.yymps) from the [latest release](https://github.com/blue-pulse/resnip/releases/latest) and import it into your project as a local package. It needs GameMaker LTS 2026 or later.

Two words to know:

- **Snip**: a description of an animation. It is a sprite, or some of its images, plus its speed, its loops, its scripts and what happens at the end. A snip never changes once it is made, so many objects can share one.
- **Playback**: one animation that is playing right now. It remembers which snip it plays and which frame it is on.

## Your first animation

Put this in an object. `spr_walk` stands for any sprite of your project.

```js
// Create event
walk = resnip_snip_create(spr_walk);   // describe the animation
playback = resnip_playback_create();   // make the thing that plays it
resnip_play(playback, walk);           // start playing

// Step event
resnip_step(playback);                 // move the animation forward, once per step

// Draw event
resnip_draw(playback, x, y);           // draw the current frame
```

The sprite now plays and starts again each time it reaches its last frame. Choose another ending with `end_mode` (see below).

### Drawing with `draw_self`

Resnip keeps the state of the animation in the playback, not in your object, so `draw_self()` alone draws whatever sprite the object already had. If you want to use `draw_self()`, or you need the object's collision mask to follow the animation, copy the animation to the object after each step:

```js
// Step event
resnip_step(playback);
resnip_instance_sync(playback);   // sets sprite_index and image_index, and image_speed to 0

// Draw event
draw_self();
```

### What happens at the end

Give the snip an `end_mode` when you make it.

```js
var _open = resnip_snip_create(spr_door_open, { end_mode: RESNIP_END.HOLD });
```

| End mode | What the snip does at its last frame |
| --- | --- |
| `RESNIP_END.REPEAT` | Starts again. This is the default |
| `RESNIP_END.HOLD` | Stays on the last frame |
| `RESNIP_END.REWIND` | Goes back to the first frame and stops |
| `RESNIP_END.FASTFORWARD` | Goes to the last frame and stops |
| `RESNIP_END.PINGPONG` | Plays back and forth |

## Try the demo

Download or clone the repository, open `resnip.yyp` in GameMaker LTS 2026 and run it. You need nothing else.

## Explore the repository

In the asset browser, the folder `Resnip` is the library, `Demo` is the demo you just ran, `Tests` holds the tests and the benchmark, and `Bootstrap` holds the room that starts them.

| Path | What it holds |
| --- | --- |
| `scripts/`, `objects/`, `rooms/`, `sprites/` | The resources of the project, one folder each, as GameMaker keeps them on disk |
| `docs/` | The documentation for people who work on Resnip |
| `tools/` | Command line tools for contributors |

## Why a rewrite

AESnips was written before structs and arrays became the usual way to write GML. Resnip keeps its ideas and writes the code again.

- The state of an animation lives in a playback. Nothing is added to your instance.
- Playing with an instance and playing without one use the same code.
- It uses structs and arrays, so there is nothing to destroy by hand.
- Every public function starts with `resnip_` and has help text in the editor.
- A mistake in your input raises an error that says what was wrong and what to pass instead.

A few things behave differently from AESnips, such as when a frame script runs. [Record 0001](./docs/decisions/0001-rewrite-aesnips-with-structs-and-one-playback-core.md) lists them.

## Contribute

You do not need the command line to use Resnip, but you do to work on it. The tests and the benchmark run through Python and the GameMaker runtime, and `docs/CONTRIBUTING.md` has the commands. Read these in order.

- [docs/CONTRIBUTING.md](./docs/CONTRIBUTING.md): the commands and the rules for everyone who works on it.
- [docs/PRINCIPLES.md](./docs/PRINCIPLES.md): the principles every change is judged against.
- [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md): the map of the library, its invariants and its boundaries.
- [docs/decisions/](./docs/decisions/): why each larger choice was made, what was refused, and what differs from AESnips.
- [docs/PENDING.md](./docs/PENDING.md): the known work that is unfinished.
- [docs/reference/](./docs/reference/): how AESnips, Igor, GMS MCP and the GameMaker manual behave.
- [AGENTS.md](./AGENTS.md): where an AI coding agent starts.

## Credits and licence

Resnip is based on [AESnips](https://github.com/angelwire/AESnips) by William Jones, whose [documentation](https://docs.google.com/document/d/1JSGG1mfid8lOiSictlqFUEiaxrTep1TUyvLne1Z2Yr0) explains the concepts it carries over. It is released under the MIT licence. See [LICENSE](./LICENSE) and [NOTICE](./NOTICE.md).
