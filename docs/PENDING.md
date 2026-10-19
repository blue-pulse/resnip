# Pending work

## About this document

This document is the long-term backlog of Resnip. It is for anyone choosing what to work on next, or who needs to know what is deliberately unfinished.

Each entry states the problem, the shape of the fix, and how you know it is done, so you can pick it up cold. Entries are ordered by priority and carry no dates. Items cite each other by number, and a finished item is deleted while the others keep their numbers, so the list can start above 1 and have gaps. Git keeps what was done.

It does not record what was done, because the code, its tests and git record that. It holds no rules or deliberate constraints, which are in [CONTRIBUTING.md](./CONTRIBUTING.md) and [decisions/](./decisions/).

Update it when an item is found, changes shape, or closes. Never act on an entry unless the user asks.

## 1. The benchmark hides its own noise

Problem. `python tools/gm.py bench` prints the mean of steps 11 to 130 per case. Two runs of the same code on 2026-10-15 differed by up to 30 percent in one case and by 1 to 6 percent in the others (VM), so a cost of 3 percent could not be seen. Deciding the cost of the fixes needed private copies of the project with a longer run (steps 11 to 500) that prints the minimum and the median. Re-run before citing any figure.

Shape. Change `__resnip_bench_step` to keep the time of each step, sort them and print the minimum and the median next to the mean. Keep the `[BENCH]` line format that the tools may read. Compare code versions by alternating runs of two copies, not by one run each.

Done when two runs of unchanged code agree within 5 percent on the minimum for every case.

## 2. Resnip has not been measured against AESnips

Problem. Every figure in [0003](./decisions/0003-advance-time-with-an-integer-frame-and-an-accumulator.md) compares Resnip with an earlier Resnip. No run puts the two libraries side by side, so "as fast as AESnips" is a hypothesis. The reason to expect it is that Resnip uses structs and arrays and AESnips uses variables on the instance and lists, which was not checked.

Shape. Run the same cases (1 000, 5 000 and 10 000 playbacks, one sprite at one frame per step) through the `SnipPlayer` of AESnips in the private project under `.sandbox/` and record the method and the numbers in record 0003. The AESnips code stays out of the repository, so the result cannot be repeated by others, and the record must say so.

Done when record 0003 holds both columns with their method.

Low priority.

## 3. The skip and the end of a snip call each other

Problem. `__resnip_playback_enter` follows a loop skip and `__resnip_playback_finish` follows the end of a snip, and each can call the other. [0010](./decisions/0010-hold-a-snip-whose-every-frame-is-skipped.md) bounds this with a counter per playback. The counter is reset by `resnip_play`, so two snips that are both fully skipped and name each other as `next` may still recurse without end. That is a hypothesis and not a finding, because it was not reproduced.

Shape. Write the test that builds two such snips. If it hangs, make the skip iterative: find the next frame to play in a loop inside `__resnip_playback_enter`, and finish the snip once when none is left, so no recursion remains and the counter goes away.

Done when that test passes and `__resnip_playback_enter` has no recursive call.

## 5. The YYC build keeps stale code after scripts change

Problem. After scripts are added or edited, `python tools/gm.py test --yyc` can fail at the link step with unresolved externals for anonymous functions, until `.sandbox/igor/cache` is deleted. Seen twice on 2026-10-15 with runtime 2026.0.0.23, and not seen on a fresh checkout.

Shape. Make `tools/commands/run.py` clear the cache folder before a YYC build, or add a `--clean` option that does, and then drop rule `T006`. Do not change the Igor options without reading [reference/igor.md](./reference/igor.md).

Done when adding a script and running `test --yyc` links without a manual delete.

## 6. A snip can still change after setup

Problem. `resnip_snip_set_next` can run at any time, and `snip.__options` is a shallow copy, so changing an array that was passed to `resnip_snip_create` changes later clones. Both were read from the code and not run.

Shape. Copy the arrays and structs of the options when the snip is created, and either document `resnip_snip_set_next` as setup only with a check that raises once the snip has been played, or accept the gap in [0002](./decisions/0002-keep-the-state-in-the-playback-and-fix-the-snip.md) as a decision.

Done when a test changes the passed array after creation and the clone does not change.

Low priority.

## 7. Behaviour that no test covers

Problem. These were found by reading and have no test: a callback that throws; `resnip_instance_sync` with a stopped or backward playback; a `direction` other than 1 or -1; a sprite in frames per game frame together with a gamespeed change; the parts of the debug panel other than that it draws.

Shape. One test per item in the suite that owns the area. Do not build features for them.

Done when each has a test or a line in a record that says it is accepted.

Low priority.

## 8. The test suite was not audited against the test rules

Problem. Record [0015](./decisions/0015-write-a-test-only-if-it-protects-a-named-behaviour.md) was written after the 171 tests. Some may be a second example of a class that another test covers, one checks a private field (the clone test compares `__key` of two loops), and some may be too close to the implementation. A first reading on 2026-10-15 found these candidates, and it is not the audit: the eight tests of the suite `properties` and one test of `speed` use a loop and a branch, which breaks `T011` as written; the test `callbacks receive the argument and the playback` of `flow` repeats two tests of `callbacks`; and `the snip counts its frames` of `input` checks a field value. Re-count before acting.

Shape. List each suite's tests against the gate of 0015, mark the ones that fail its first four questions, and delete or rewrite them. Run the mutation checks of `T004` before and after, so that deleting a test does not hide a fault that only it caught. Do not add tests while doing this.

Done when every test in the suite has a behaviour that can be named in one sentence, and the mutation checks catch what they caught before.

Low priority.

## Waiting on the user, not on us

These shape code but are product calls. Do not decide them.

- Resnip has no logo of its own. The Windows build uses the default icon of GameMaker, and the other platforms use the defaults of the IDE. Which logo, from Blue Pulse or new, goes in `options/windows/icons/icon.ico`?
- Should a completion script that stops the playback keep the next snip from starting? Today the next snip starts anyway ([0004](./decisions/0004-describe-the-end-of-a-snip-with-a-mode-and-a-completion-rule.md)).

## Operational, not code

- The README and `LICENSE` credit AESnips and keep the MIT notice of William Jones. Do not remove either without the maintainer's ruling. Re-read both after any change of licence.
