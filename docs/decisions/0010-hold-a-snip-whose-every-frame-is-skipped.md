# 0010. Hold a snip whose every frame is skipped

## About this document

This record decides what happens when loops with a count below 0 skip every frame of a snip. Read it before you change `__resnip_player_enter`, the loop skip, or `__resnip_player_give_up`. It covers the skip counter, the limit and the warning. It does not cover the loop count itself, which is [0002](./0002-keep-playback-state-in-the-player-and-fix-the-snip.md), or the end modes, which are [0004](./0004-describe-the-end-of-a-snip-with-a-mode-and-a-completion-rule.md). Update it when the skip logic stops recursing.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- A player counts the skips it follows. When the count reaches the number of loops of the snip, the player holds its last frame going forward or its first going backward, stops, and prints a `[WARNING]`.
- Never remove the limit while the skip and the end of a snip call each other.

## Context and problem statement

A loop with a count below 0 is skipped: the player jumps past it. When the loops cover every frame, the jump leaves the snip, the snip ends, REPEAT or PINGPONG start again, the loops reset, and the jump happens again without any frame in between. `__resnip_player_enter` and `__resnip_player_finish` call each other without end.

## Decision outcome

`__resnip_player_enter` keeps `__skips` on the player. It adds one before it follows a skip and subtracts one after. If `__skips` already equals the number of loops of the snip, it calls `__resnip_player_give_up`, which prints the warning and stops the player. `resnip_play` resets the counter. A chain of skips that lands on a real frame never reaches the limit, because each loop skips once per pass.

## Considered options

- Make the skip and the end iterative was refused for now, because it is a larger change to the core, and the limit is small and local. It remains possible (item 3 of [PENDING.md](../PENDING.md)).
- Throw an error was refused, because a game should not crash for a content mistake.
- Hold without a message was refused, because the mistake would stay silent.

## Consequences

- Pinned by three tests in the suite `loops`: `a repeating snip whose every frame is skipped holds on its last frame`, `a pingpong snip whose frames are skipped by two loops holds` and `a snip whose frames are skipped still completes once`, and by `a completion script can play a snip that starts inside a skipped loop`, which would fail if a stale count tripped the limit.
- Without the limit the game hangs. With the limit removed, the test run produced no result after 300 seconds and was killed (checked on 2026-10-15). The cause is the unbounded recursion, which is read from the code and was not observed as a stack overflow.
- Two snips that are both fully skipped and name each other as `next` are not covered, because `resnip_play` resets the counter. That is a hypothesis and not a finding, and it was not reproduced (item 3 of [PENDING.md](../PENDING.md)).
