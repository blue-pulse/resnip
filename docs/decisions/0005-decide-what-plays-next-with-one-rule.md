# 0005. Decide what plays next with one rule

## About this document

This record decides which snip plays when the current one completes, and how it plays. Read it before you change `__resnip_playback_play_next`, `resnip_play`, `resnip_snip_set_next` or `resnip_transition_add`. It covers the order of the queue, the transition target and the `next` of a snip, the options each carries, and the transition registry. It does not cover when a snip completes, which is [0004](./0004-describe-the-end-of-a-snip-with-a-mode-and-a-completion-rule.md), or the direction rules, which are [0006](./0006-keep-direction-in-the-playback.md). Update it when a source of "what plays next" is added.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- The order is the playback queue, then the target of a running transition, then the `next` of the snip. Each one carries its own `transition` and `backward` options.
- Never add a fourth path for what plays next.

## Context and problem statement

AESnips reaches the same answer by a queued snip, a successor and a transition target, each with its own code and its own flag. The successor carries a transition flag, and a snip direction decides how the next one plays.

## Decision outcome

When a snip completes, `__resnip_playback_play_next` picks the first that exists:

1. The queued snip, set by `resnip_play` with `queue: true`, with the transition and direction it was queued with.
2. The target of the transition that is running, which plays in the direction that was asked for the target. The transition snip itself plays in the direction of its registry entry.
3. The `next` of the snip, set by `resnip_snip_set_next(snip, next, {transition, backward})`, with `transition` true and `backward` false unless set.

Transitions live in a registry in the library state, found by from and to, so a snip points to no other snip and the registry can be replaced whole. A transition can play backward by an option, so one authored snip serves both ways. A queued snip that asks for a transition continues from the target of the running transition, so the target never plays and the transition between the target and the queued snip does.

## Considered options

- Keep a successor, a queue and a transition target as three paths was refused, because they answer one question.
- Keep a reverse clone of each transition, as AESnips does, was refused, because a `backward` option on the transition does the same with no copy.
- Store transitions inside each snip was refused, because the snips would point to each other and could not be fixed after creation.

## Consequences

- Pinned by tests in the suite `flow`: `the target of a transition wins over the next of the transition snip`, `a queued snip asked with a transition continues from the target of the running transition`, `a queued snip can play backward`, `the target of a transition plays backward when asked`, `the next of a snip can play backward` and `the next of a snip uses a transition unless told not to`.
- `resnip_stop` forgets the target of a running transition, so `restart: false` no longer thinks the playback is heading there. Pinned by `a stopped playback can play the target of a transition it left`.
- The registry holds its snips until `resnip_transition_remove` is called, which is accepted.
- A transition snip's own `next` is ignored while it runs as a transition, because the target wins. That is accepted.
