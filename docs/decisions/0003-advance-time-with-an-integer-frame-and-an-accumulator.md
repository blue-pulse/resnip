# 0003. Advance time with an integer frame and an accumulator

## About this document

This record decides how a playback measures time. Read it before you change `resnip_step`, the way a frame is entered, or the speed formula. It covers the integer frame, the accumulator, the speed formula, the sprite speed type, and what the benchmark shows today. It does not cover loops or ends, which are [0004](./0004-describe-the-end-of-a-snip-with-a-mode-and-a-completion-rule.md) and [0002](./0002-keep-the-state-in-the-playback-and-fix-the-snip.md). Update it when the step algorithm or a measurement changes.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- A playback holds an integer `frame` and a `__progress` in [0, 1). A step spends its time frame by frame.
- Never read a float image index to know which frame plays.

## Context and problem statement

AESnips advances a float `image_index` with `math_get_epsilon()` at the edges. A step that crosses frames uses the speed of the first one, throws away what is left at a wrap, and runs only the script of the frame it lands on. Float sums drift: a snip speed of 0.1 reaches frame 3 after 40 steps instead of frame 4 (observed in AESnips 0.1.4, 2026-10-14).

## Decision outcome

The rate of a frame is `frame_speed * snip speed * playback speed * clock scale * sprite scale`, in frames per step. The sprite scale is the sprite speed when the sprite runs in frames per game frame, and the sprite speed divided by the gamespeed when it runs in frames per second. The gamespeed is read from the engine at every step, so a change applies at once, and [0013](./0013-read-the-gamespeed-from-the-engine.md) decides that input.

A step takes the time to finish the current frame, `(1 - progress) / rate`, subtracts it from what remains, moves, and repeats with the speed of the new frame. The remainder passes to the next frame and to the next snip. A script runs for every frame entered, even at a high speed. A rate of 0 or below ends the step without spending time. Equality at the edge of a frame is tolerated by `1e-6`, as `__RESNIP_EPSILON`.

## Considered options

- Keep the float index with an epsilon was refused, because of the drift above and because it cannot run a script for each frame crossed.
- Count frames only, with no accumulator, was refused, because a speed below 1 and a delta time need a fraction of a frame.

## Consequences

- Pinned by tests in the suite `speed`: `no drift before the tenth step of a frame`, `no drift on the tenth step of a frame`, `a frame speed above one shortens only its own frame`, `several steps at once move several frames` and `a gamespeed set during play changes the pace of a sprite in frames per second`. Breaking `_remaining -= max(_room, 0) / _rate` fails seven tests.
- Cost today. Method: `python tools/gm.py bench` on 2026-10-15, runtime 2026.0.0.23, Windows 11, mean of steps 11 to 130 in the room `rm_bench` with the library set to a gamespeed of 15 and a sprite of 15 frames per second, so every step crosses a frame, which is the worst case. The benchmark now gets the same one frame per step from a copy of the sprite at the engine gamespeed, and these figures were not taken again. Microseconds per step for all the playbacks. Two runs of the same code differed by up to 30 percent in single cases, so read these as an order of magnitude and re-run before citing.

| Playbacks | Loops | YYC | VM |
| --- | --- | --- | --- |
| 1 000 | 0 | 916 | 3 260 |
| 1 000 | 4 | 1 302 | 4 644 |
| 5 000 | 0 | 4 719 | 16 692 |
| 5 000 | 4 | 6 570 | 23 681 |
| 10 000 | 0 | 10 082 | 33 434 |
| 10 000 | 4 | 13 801 | 48 163 |

- One hundred animated playbacks cost about 0.1 ms per step on YYC at this worst case, derived from the 1 000 playback rows by dividing, and not measured separately. A sprite that stays several steps on a frame costs less.
- Cost of the fixes of 2026-10-14. Method: alternating runs of two copies of the project, the code before and the code after, best of two rounds, minimum of 490 steps per case, on YYC and on the VM. The code after was between 1 percent faster and 7 percent slower on YYC and between 4 and 6 percent slower on the VM. The copies and the modified benchmark live in `.sandbox/`, so nobody else can repeat this, and it is unverified from the repository. The part that the check for a pause set inside a callback adds was about 3 to 4 percent on YYC.
- Resnip has not been measured against AESnips. A claim that one is faster than the other would be unverified.
- The benchmark of the repository reports a mean, which hides the noise. Item 1 of [PENDING.md](../PENDING.md) asks for the minimum and the median.
