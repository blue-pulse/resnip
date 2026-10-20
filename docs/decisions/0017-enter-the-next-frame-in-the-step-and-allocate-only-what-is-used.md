# 0017. Enter the next frame in the step and allocate only what is used

## About this document

This record decides how the step and the playback are built to spend less time and memory. Read it before you change `resnip_step`, `__resnip_playback_move`, `__resnip_playback_enter`, `__resnip_playback_start` or `__resnip_playback_loop_waits`, before you add a field to a playback or to a snip, before you give a public function a default argument, and before you propose to merge, split or inline any of these. It covers what was adopted, every option that was tried or weighed and refused, and the measurements behind both. It does not cover the time algorithm, which is [0003](./0003-advance-time-with-an-integer-frame-and-an-accumulator.md), the input of the gamespeed, which is [0013](./0013-read-the-gamespeed-from-the-engine.md), or the pause, which is [0007](./0007-share-pause-and-scale-through-a-clock.md). Update it when an option is tried again or a measurement is taken again.

- Status: accepted
- Date: 2026-10-19
- Decision-makers: the maintainer

## Summary

- `resnip_step` enters the next frame itself when that frame is not the edge of a loop or of the snip and no loop would be entered or skipped there. `__resnip_playback_move` takes every other move.
- A playback creates only what it uses, and a snip works out at creation what the step reads at every step.
- Never send every frame back through one call per frame, and never write a default argument in `resnip_step`, `resnip_play` or `resnip_playback_create`, without measuring on YYC first.

## Context and problem statement

The goal is a library that is faster and smaller than AESnips in time per step and memory per animation, on the VM and on YYC, and that keeps its guarantees: no drift of a float, the script of every frame crossed, and the time left over passes to the next frame ([0003](./0003-advance-time-with-an-integer-frame-and-an-accumulator.md), [0011](./0011-run-a-callback-for-every-frame-entered.md)). Before this record Resnip was slower than AESnips in the mean of the cases and larger in memory.

The measurements located the cost. A step that stays inside a frame was already cheaper than in AESnips. The whole difference was in the step that crosses a frame, which sent the frame through two calls with their own locals, and in the creation of a playback, which grew with its number of fields.

GML makes some operations expensive. Probes of 10⁶ iterations on runtime 2026.0.0.23 on 2026-10-18 and 2026-10-19, order of magnitude only, with about 20 ns of noise on the VM:

| Operation | VM | YYC |
| --- | --- | --- |
| Call to a function with no locals | ~40 ns | ~4 ns |
| Call to a function with at least one `var` | ~190 ns | ~11 ns |
| Each extra `var` | ~20 ns | ~5 ns |
| A function that writes an argument, which every default argument does | +~50 ns | +~55 ns |
| Read of a field of a struct | ~27 ns | ~8 ns |
| Create a struct of 8 and of 17 fields | ~800 and ~1 400 ns | ~700 and ~1 100 ns |
| Memory of a field of a struct | 16 B | 16 B |
| Memory of an empty array | ~320 B | ~336 B |

The VM builds the locals of a function when it runs the first `var`, so a guard before any `var` costs almost nothing. YYC builds every local when it enters the function, whether it is used or not. `forceinline` is honoured on YYC and not on the VM. These probes can be repeated only from `.sandbox/`, so the repository does not let anyone repeat them.

## Decision outcome

What the step and the playback do:

1. **The step enters the next frame itself.** It does so when the playback is inside a loop and not on its edge, or when it is outside a loop and the next frame is inside the snip and holds no loop that would be entered or skipped. It sets the frame and calls the script of that frame. Every other move goes through `__resnip_playback_move`. This avoids the two calls with locals that each crossing used to make.
2. **The guard comes before any local.** A playback that cannot move returns before the first `var`.
3. **The step rereads the snip and checks `stopped` and both pauses after a callback or after a move through `__resnip_playback_move`.** Only those two can change the fields, so a plain move without a script needs no check.
4. **No default argument** in `resnip_step`, `resnip_play` and `resnip_playback_create`. The function reads the value inside, such as `_steps ?? 1`. The JSDoc keeps marking the parameter as optional. `resnip_play` with no options goes straight to `__resnip_playback_start`, and so does what plays next, with no options struct.
5. **A playback creates only what it uses.** The overrides of loop counts (`__repeats`) are `undefined` until the first override. All snips with no loops share one empty array of passes. The queue is a struct only while something is queued. Whether a playback owns its frame speeds is read from the identity of the array, compared with the `__frame_speeds` of its snip, and not stored. A playback has 17 fields and not 20.
6. **A snip works out what the step reads at creation.** `__loops_at` lists the loops that hold each frame, `__scale` is its speed times the speed of its sprite, `__per_second` says whether the sprite runs in frames per second, and `__frame_speeds` holds the speeds the step reads, which is the array `frame_speeds` itself unless the snip asks for the durations of its sprite ([0018](./0018-let-a-snip-ask-for-the-durations-of-its-sprite.md)). The snip is still not written after setup ([0002](./0002-keep-the-state-in-the-playback-and-fix-the-snip.md)).
7. **Two conditions leave the loop of the step.** `max(_room, 0)` and `!_playback.stopped` were dead. The progress only grows when the sum stays below `1 - __RESNIP_EPSILON`, so the room is above the epsilon, and a playback that stopped returned at the guard or at the check after a callback.
8. **The loop rule exists twice on purpose.** `__resnip_playback_enter` and `__resnip_playback_loop_waits` apply the same test: a loop is skipped when its count is below 0 and it was not skipped yet, and it is entered while it has passes left. A change to the rule must change both.

## Considered options

Adopted options are above. These were refused. Where a number is given, the method is two or more copies of the library in one process, alternating runs with the order rotated, 5 000 playbacks of one snip of 20 frames, 9 repetitions, runtime 2026.0.0.23, Windows 11, on 2026-10-18 and 2026-10-19, and the repository does not let anyone repeat it. A difference under 3 percent is noise, since two runs of the same code differ by about 4 percent.

- **Send every frame through `__resnip_playback_move` and `__resnip_playback_enter`** was refused, because each call builds its locals. Entering the frame in the step took 17 percent off the case that crosses a frame every step on the VM and 23 percent on YYC.
- **Put the check of the crossing in a helper with `forceinline`** was refused. On the VM it is not inlined and adds a call, 5 percent slower. On YYC it was 5.7 percent slower in the mean of the cases against the version with the check in the step.
- **Put the whole crossing in a helper** was refused. It is 4 percent slower on the VM and 1.9 percent on YYC in the mean. On YYC it gains where few frames are crossed, 16 percent for a paused playback and 7 percent for a snip at speed 0.1, and loses 13 percent where every step crosses.
- **Keep the target and its direction in one field, split the start from the entry, search the loops apart from the entry, and share the zeros of the passes until the first write** was refused. It made creation 7 percent faster on the VM only, left the step equal or 4 to 6 percent slower with loops, and saved 16 bytes. It does not pay for the extra code ([CONTRIBUTING.md](../CONTRIBUTING.md), `C009`).
- **Make the playback a constructor with `static` defaults** was refused. Creation fell to 1.11 times AESnips on the VM and 1.14 on YYC, from 1.35 and 1.46, and memory fell 64 bytes. It changes `instanceof`, hides the public fields from `struct_get_names`, and a write to a field inside the constructor wrote to the shared `static`, which changed the behaviour (the trace differed). The type is part of the interface, so this is a different design and not a tuning.
- **Use one function for the loop rule, called by `__resnip_playback_enter` and by the step** was measured and refused. The step stayed equal. A snip with loops took 3 percent longer on the VM and 4.7 percent on YYC, and the creation of a playback 6.7 and 4.9 percent. Its `forceinline` version showed no gain that could be told from noise on YYC (6 repetitions, on a machine that was busier than in the other runs). The rule is a unit of its own, and the second copy is the price of those percentages. When a third place needs the rule, or the rule changes often, merge the two.
- **Call the script as `_script.callback(...)` instead of through a local** was refused, because the callback then runs with the script struct as `self` and not with the `self` it was made with.
- **Read the gamespeed once per call, or stop reading it each step** was refused. Removing the read gained 0.7 percent on the VM, which is noise, and 4.5 percent on YYC, and it would reopen [0013](./0013-read-the-gamespeed-from-the-engine.md). It does not pay for that.
- **Mark the start of a snip and the functions it calls with `forceinline`** was measured and refused. A function that its caller always runs wastes no locals when inlined, and YYC builds every local at entry, so it was worth trying. Four sets were compared with the code before and with an identical copy of it that gives the noise: `__resnip_playback_start`; that and `__resnip_playback_reset_loops`; those and `__resnip_playback_complete` and `__resnip_playback_play_next`; and those and `resnip_clock_default`. A fifth copy marked only `__resnip_playback_move`, which the step runs only at an edge, was the control. Method: as above, on YYC on 2026-10-19, with creation and play of 10 000 playbacks timed apart (8 repetitions kept), 20 000 calls of `resnip_play` (24 kept), and three more snips of 4 frames, one that repeats and two that name each other as `next`, to run the end of a snip often. Every set compiled on YYC, including the `static` of `__resnip_playback_reset_loops` inlined, and gave the same trace and no difference in 2 000 random scenarios of 320 steps. The identical copy moved by up to 4 percent in the step, 3 percent in `resnip_play` and under 1 percent in the split timings. Marking `__resnip_playback_start` alone gave 0.997 in creation and 0.999 in play. With the end of the snip marked, the step of the snip that repeats and of the chained snips gave 1.004 and 1.000, and play became 3.5 to 4.6 percent slower. The control was not slower either (0.987 in the step), so this method cannot tell a difference of 2 percent. Nothing passed 3 percent, and no function is marked. The step already makes almost no calls, which is what the first item of this list removed, so little is left to inline. Not tried: the VM, which does not inline, `__resnip_system`, which the harness shares between copies, and a second run of the whole block.

These were weighed and not built or not measured:

- **Cache the rate in the playback.** The clock is shared and the gamespeed is read at each step, so nothing says when to drop it.
- **Take the rate out of the step loop.** The benchmark makes one pass per step, and it would reorder the multiplications again.
- **Write to the arguments as if they were locals.** It is faster on the VM and costs about 55 ns on YYC, and it breaks `C019`.
- **Keep rarely used state in a struct created on demand.** It was estimated at 4 percent of creation, it does not close the gap, and it puts one more read on every `resnip_play`.
- **Shrink the array of passes.** It is the largest part of what is left in memory with loops. Changing how passes are counted would change what is seen when `direction` is written inside a snip or when `resnip_set_loop_repeats` is called during the last pass. It was not tried.
- **Keep `_steps = undefined` in the signature to see the default in the editor.** Any default argument writes the argument, and this was not measured on its own.

## Consequences

- Against AESnips 0.1.4. Method: as above, a snip of 20 frames, 10 steps of warm up and 120 measured, the median over 9 repetitions of the mean step. Ratio of Resnip over AESnips, where below 1 means Resnip is faster:

| Case | Before, VM | After, VM | Before, YYC | After, YYC |
| --- | --- | --- | --- | --- |
| Crosses a frame every step | 1.40 | 1.00 | 1.53 | 0.94 |
| Same with 4 loops | 1.24 | 0.86 | 1.48 | 0.89 |
| Every 2 steps | 1.12 | 0.87 | 1.26 | 0.85 |
| Every 4 steps | 1.00 | 0.80 | 1.14 | 0.80 |
| Every 10 steps | 0.90 | 0.75 | 1.04 | 0.75 |
| Geometric mean of these five | 1.12 | 0.85 | 1.28 | 0.85 |
| Paused | 0.25 | 0.22 | 0.40 | 0.27 |
| Create and play | 1.85 | 1.35 | 2.01 | 1.46 |

  With 10 000 playbacks the geometric means were 0.88 on the VM and 0.90 on YYC. A run on 2026-10-19 reproduced the figures of the two cases that cross every step within 4 percent.
- Live memory per playback after 25 steps, read with `debug_event("DumpMemory", true)`. With no loops it fell from 1 200 to 832 bytes on the VM and from 1 279 to 911 on YYC, against 1 120 and 1 199 for AESnips. With 4 loops it is 1 216 on both, against 1 184 and 1 263 for AESnips, which is a tie.
- The saving is small in absolute terms. A game with a few hundred animations will hardly notice it, and this record does not present it as a large gain.
- Creation is still slower than in AESnips, 1.35 on the VM and 1.46 on YYC. The cause measured is the number of fields of the playback, about 45 ns each, and the only way found to cut it changes the type.
- Behaviour was checked against the version before this record with a fixed scenario of 2 240 steps and with random scenarios whose callbacks stop, play, set the speed, a loop count or a frame speed, pause the playback or the clock, flip the direction, call the step again and queue or cancel a snip. 10 000 seeds on the VM and 10 000 on YYC, about 3.2 million steps each, gave no difference in the frame, the direction, `stopped`, the pause, the snip, the scripts or the completions. The last bit of the progress differs in about 40 percent of the seeds, because the rate multiplies in another order, and the tolerance of `__RESNIP_EPSILON` and of the comparison of GameMaker absorbs it. The harness lives in `.sandbox/`, so the repository does not let anyone repeat this.
- Breaking one copy of the rule on its own fails tests (checked on 2026-10-19): the test of the loop edge in the step fails 22, the test of the edge of the snip fails 90, the loop test of `__resnip_playback_loop_waits` fails 5, the call to the script in the step fails 12, and the speed of the sprite in `__scale` fails 111. Leaving out the reread of the snip after a callback fails one test, `the rest of a step runs at the speed of the snip a callback started`. No test compares the step with `__resnip_playback_move` directly, and a test that did would have to call an internal function (`T010`).
- Two couplings are implicit. All snips with no loops share one array of passes, which nothing may write to, and whether a playback owns its frame speeds comes from comparing its array with the `__frame_speeds` of its snip. Neither is checked by a test.
- The benchmark is synthetic: one snip of 20 frames and loops of 4 frames. It was not run on a real scene, on another machine, on another runtime, or on HTML5.
- Without this decision, the step sends every frame crossed through calls that build their locals, and Resnip is slower than AESnips in the mean of the cases and larger in memory, as it was before this record.
