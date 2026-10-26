# 0004. Describe the end of a snip with a mode and a completion rule

## About this document

This record decides how a snip behaves at its last frame and when it counts as complete. Read it before you change `end_mode`, `complete_on`, `__resnip_playback_finish` or the meaning of a completion script. It covers the five end modes, the three completion rules and loops at the edge of a snip. It does not cover what plays when the snip completes, which is [0005](./0005-decide-what-plays-next-with-one-rule.md), or a loop that skips every frame, which is [0010](./0010-hold-a-snip-whose-every-frame-is-skipped.md). Update it when a mode or a rule is added.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- `end_mode` says what happens at the end: HOLD, REWIND, FASTFORWARD, REPEAT or PINGPONG. `complete_on` says when a pingpong counts as complete: EDGE, HEAD or TAIL.
- Never add a mode that mixes the two questions.

## Context and problem statement

AESnips has seven end types, and each one mixes what happens at the end with when the snip counts as complete. `end_pingpong_head` and `end_pingpong_tail` differ from `end_pingpong` only in when the completion script and the next snip fire.

## Decision outcome

- HOLD stays where the snip ended (the last frame forward, the first backward) and stops.
- REWIND goes to the first frame and stops, in either direction.
- FASTFORWARD goes to the last frame and stops, in either direction.
- REPEAT starts again at the first frame going forward and at the last frame going backward.
- PINGPONG turns around without repeating the edge frame.
- `complete_on` applies to PINGPONG only. EDGE completes at both ends, HEAD only when the snip reaches the first frame going backward, and TAIL only when it reaches the last frame going forward.
- The completion script runs before the end mode. If the script plays a snip, or something queued or following plays, the end mode is skipped.

## Considered options

- Keep seven fixed end types was refused, because each is a point in a smaller space of two questions and a new case would need an eighth.
- A rule relative to the start direction, "complete when back where it started", was refused, because the playback can change its direction, and because `end_pingpong_head` and `end_pingpong_tail` are absolute, so a snip that starts backward would complete at other moments.
- Repeat the edge frame at a pingpong turn, as AESnips does, was refused, because it shows one frame twice and makes the period of the animation one frame longer than its frames.

## Consequences

- The seven AESnips end types are all expressible, as the table in [0001](./0001-rewrite-aesnips-with-structs-and-one-playback-core.md) shows.
- Pinned by tests in the suite `end`, among them `fastforward backward jumps to the last frame and stays`, `pingpong with head backward completes when it first reaches the first frame` and `pingpong with tail backward completes only on the return`. Breaking each of the HEAD rule and the FASTFORWARD frame fails tests (checked on 2026-10-15).
- A snip of one frame completes every step in REPEAT and in PINGPONG with EDGE. That is a consequence and not a defect.
- A completion script that stops the playback does not prevent the next snip from starting, because the next snip is chosen after the script. That is unresolved and is under "Waiting on the maintainer" in [PENDING.md](../PENDING.md).
- Without this decision, each new case of ending adds a type that mixes what happens at the end with when the snip completes, as the seven types of AESnips do.
