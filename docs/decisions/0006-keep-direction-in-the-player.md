# 0006. Keep direction in the player

## About this document

This record decides where the direction of playback lives. Read it before you add a direction to a snip or change how `backward` is handled. It covers the `direction` field, the `backward` option and the pingpong turn. It does not cover which snip plays next, which is [0005](./0005-decide-what-plays-next-with-one-rule.md), or the end modes, which are [0004](./0004-describe-the-end-of-a-snip-with-a-mode-and-a-completion-rule.md). Update it when direction gets a second owner.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- `direction` is a field of the player, 1 or -1. A snip has no direction.
- Never store a direction on a snip, because the snip is shared.

## Context and problem statement

AESnips keeps one direction on the snip and another on the instance, and combines them with the sign of the speed. Reversing a snip that is playing turns it around for every instance that uses it. Which of the three decides how it plays is not clear to the reader.

## Decision outcome

`resnip_play` takes `backward: true` to start on the last frame and play down. A pingpong flips `direction` at each turn. A transition plays in the direction of its registry entry ([0005](./0005-decide-what-plays-next-with-one-rule.md)). The `direction` field may be set to 1 or -1 by the game, and the next frame move follows it.

## Considered options

- A direction on the snip, as AESnips has, was refused, because reversing it changes every user.
- A negative speed to play backward was refused, because a speed of 0 or above is the contract of every speed in the library, and the sign would hide the direction.

## Consequences

- Pinned by tests in the suites `end` and `loops` that run each end mode and each loop backward, among them `repeat backward wraps to the last frame` and `a loop plays backward`. The property `a backward run mirrors the forward run` checks 200 seeded snips in HOLD, REPEAT and PINGPONG.
- Setting `direction` in the middle of a run turns the player in place. A negative value other than -1 is not checked, which is a gap and not a decision.
