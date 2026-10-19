# 0014. Name the functions that act on a player by their verb

## About this document

This record decides how the public functions are named. Read it before you add a public function or rename one. It covers the verb names of the functions that act on a player, and the names that keep a noun. It does not cover the rule of the prefix and the case, which is `C003` in [CONTRIBUTING.md](../CONTRIBUTING.md). Update it when a function changes group.

- Status: accepted, and its name of the type is superseded by [0016](./0016-name-the-type-playback.md)
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- A function that acts on a player is `resnip_<verb>`, such as `resnip_play(player, snip)` and `resnip_step(player)`. A function that creates or acts on another kind of thing keeps its noun: `resnip_snip_create`, `resnip_clock_create`, `resnip_player_create`.
- Never put `player` in the name of a function that acts on a player, because it names nothing that distinguishes it.

## Context and problem statement

In AESnips the word `player` told the standalone `SnipPlayer` apart from the instance mode, which had its own `snip_` functions. Resnip has one mode, so the word distinguishes nothing, and it made every call longer. Rule `C003` says that public functions are `resnip_action`.

## Decision outcome

These functions lost the word: `resnip_play`, `resnip_step`, `resnip_stop`, `resnip_cancel_next`, `resnip_set_speed`, `resnip_set_loop_repeats`, `resnip_set_frame_speed`, `resnip_draw` and `resnip_draw_ext`. These keep their nouns: `resnip_player_create`, where the noun says what is created and separates it from the other `create` functions, `resnip_instance_sync`, `resnip_snip_*`, `resnip_transition_*`, `resnip_clock_*` and the two converters of frames.

The type is still called a player. It reads as a player of playback and not as the player of the game, as the maintainer confirmed.

## Considered options

- Rename the type to `animator`, `playback`, `playhead` or `cursor` was refused, because `player` is clear in the sense of playback and matches AESnips, and a rename of the type changes nothing that the verbs do not already settle.
- Drop the prefix and name the functions `snip_play` and `snip_step` was refused, because those names exist in AESnips with other arguments, and the prefix keeps the library out of the global names of the game (`C003`).

## Consequences

- A person who knows AESnips sees `resnip_play(player, snip)` where AESnips has `snip_play(snip, transition)`. The JSDoc of `resnip_play`, `resnip_set_loop_repeats` and `resnip_set_frame_speed` says which functions of AESnips they replace.
- `resnip_set_speed` sits beside `resnip_clock_set_scale`, and `resnip_set_speed` acts on a player while `game_set_speed` acts on the engine. That is accepted.
- The 171 tests, the demo and the benchmark use the new names, and `git grep` finds no use of the old ones outside `docs/reference/` (2026-10-15).
