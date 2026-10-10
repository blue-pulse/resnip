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
- **One playback core.** Playing on an instance and playing on a standalone player share the same code, so a fix is made once.
- **No hidden state.** Playback state lives in the player and not in variables added to the calling instance.
- **A clear public API.** Public names start with `resnip_`, everything internal is marked as private, and every public function is documented in the editor.
- **Predictable behaviour.** One convention for frame numbers, and a check for bad input that says what went wrong and how to fix it.

## What it does

Resnip keeps the concepts of AESnips.

- A **snip** is a sprite, or a run of its sub-images, with a speed.
- A **loop** repeats chosen frames of a snip a number of times.
- A **transition** plays a connecting snip between two snips.
- A snip can run a script on a chosen frame, follow another snip when it ends, and play forward, backward or back and forth.
- Snips can be queued, paused and resumed one by one or all at once.

## Requirements

- GameMaker LTS 2026

## Credits and licence

Resnip is based on [AESnips](https://github.com/angelwire/AESnips) by William Jones, whose [documentation](https://docs.google.com/document/d/1JSGG1mfid8lOiSictlqFUEiaxrTep1TUyvLne1Z2Yr0) explains the concepts it carries over. It is released under the MIT licence. See [LICENSE](./LICENSE).
