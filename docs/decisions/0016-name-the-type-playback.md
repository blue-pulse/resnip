# 0016. Name the type playback

## About this document

This record decides the name of the type that holds the state of one animation. Read it before you rename the type, add a function that creates it, or write a document that names it. It covers the name, why the earlier name was dropped, and what the change costs. It does not cover the verbs of the functions that act on it, which are [0014](./0014-name-the-functions-that-act-on-a-player-by-their-verb.md), or where its state lives, which is [0002](./0002-keep-the-state-in-the-playback-and-fix-the-snip.md). Update it when the type changes name again.

- Status: accepted
- Date: 2026-10-18
- Decision-makers: the maintainer
- Supersedes: the part of [0014](./0014-name-the-functions-that-act-on-a-player-by-their-verb.md) that kept the name of the type

## Summary

- The type is a **playback** and its constructor is `resnip_playback_create`.
- Never name the type after the person who plays the game.

## Context and problem statement

The type was called a player, after the `SnipPlayer` of AESnips. In a game, `player` is almost always the character that a person controls, so `resnip_player_create`, `player.frame` and `callback(argument, player)` read as something that belongs to that character. The maintainer read `SnipPlayer` as a snip made for the character of the game, and the same reading applies to the type. Record 0014 judged the word clear in the sense of playback and refused to rename the type.

## Decision outcome

The type is a playback, the struct that plays a snip. The parameter is `playback`, the plural is `playbacks`, the creator is `resnip_playback_create`, and the internal scripts are `__resnip_playback_*`. `SnipPlayer` keeps its name where the text speaks of AESnips.

The three reasons of 0014 do not hold:

- The word is not clear when the first reader to meet it takes it for the character of the game.
- Matching AESnips gives no benefit, since Resnip already renames its end types, drops its accessors and has one mode. The JSDoc maps the functions that moved.
- The verbs did not settle the name, since the word stayed in the creator, in every `player` parameter that the editor shows as help, and in the signature of a callback.

## Considered options

- `animator`, `runner`, `track` and `reel` were refused. `runner` is already an object of the demo, `track` suggests audio, and `animator` and `reel` say less than the word the library already uses for the idea.
- Keep the name and write "player of playback" in the documents was refused, because the code and the editor help would still say `player`.

## Consequences

- The public name `resnip_player_create` becomes `resnip_playback_create`. The library was at 0.1.0 when the type was renamed, so no release carried the old name.
- The word is also the everyday name for the idea, so a sentence can say "a playback plays a snip" and "the direction of playback". The documents say "the state of an animation" where the type and the idea would collide.
- The line of the benchmark reads `[BENCH] playbacks=N` and `playback_ns=`, so figures taken before 2026-10-18 carry the old labels.
- The files of records 0002, 0006 and 0008 changed name. Record 0014 keeps its name and its text, apart from the line that says what supersedes it.
- The 171 tests passed on the VM and on YYC after the change.
- Without this decision, the type is read as something that belongs to the character of the game, as the maintainer read `SnipPlayer`.
