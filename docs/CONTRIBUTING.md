# Contributing to Resnip

## About this document

This document holds the rules for working on Resnip. It is for anyone who works on this repository, and it binds everyone the same way. Follow each rule exactly as written. The maintainer is the owner of the project, the user is whoever is working in it at the moment, and only the maintainer may override a rule, and only in chat.

It contains the commands you run, what you must always do, what you must never do, and what to read before you change a given area. It does not explain how the library is organised, which is [ARCHITECTURE.md](./ARCHITECTURE.md), and it does not argue the larger decisions, which are the records in [decisions/](./decisions/). The external tools are described in [reference/](./reference/), and the backlog is [PENDING.md](./PENDING.md).

Each rule carries a stable code: a letter for its section and three digits, such as `C009`. Cite a rule by its code. Always and Never share one sequence per letter, so a list shows gaps. A rule that names no authority is a local convention that no external standard names.

| Code | Section | Always | Never |
| --- | --- | --- | --- |
| `C` | Code | [Always](#code) | [Never](#code-1) |
| `P` | Project files | [Always](#project-files) | [Never](#project-files-1) |
| `T` | Testing | [Always](#testing) | [Never](#testing-1) |
| `D` | Documents and scratch work | [Always](#documents-and-scratch-work) | [Never](#documents-and-scratch-work-1) |
| `G` | Version control | [Always](#version-control) | [Never](#version-control-1) |
| `V` | Verification | [Always](#verification) | [Never](#verification-1) |
| `A` | Agents | [Always](#agents) | [Never](#agents-1) |

A new rule takes the next free number of its letter and goes at the end of its section. A code is never reused or renumbered, and a retired rule keeps its line as `Retired` with one sentence saying why.

Update it when a rule is added, changed or retired. Each rule is one line with its reason. A decision that is architecturally significant, expensive to reverse or likely to be proposed again also gets a record under `decisions/`. Anything smaller stays a line here.

## Commands

Run them from the repository root. They need Python 3.11 or later and a GameMaker runtime of the same year as the IDE version that saved `resnip.yyp`.

| Task | Command |
| --- | --- |
| Check what the tools found | `python tools/gm.py doctor` |
| Run the demo | `python tools/gm.py run` |
| Run the tests on the VM | `python tools/gm.py test` |
| Run the tests on YYC | `python tools/gm.py test --yyc` |
| Run the benchmark | `python tools/gm.py bench` or `python tools/gm.py bench --yyc` |

The tests print one line, `[RESULT] N tests, P passed, F failed, K known`, and the command exits with 1 when any test fails or none ran.

## Always

### Code

- `C001` Write everything in English, including identifiers, comments, commit messages and documents, because one language serves every reader.
- `C002` Use the plain word, such as `use` over `utilize`, because short words read faster.
- `C003` Name public functions `resnip_action` in snake_case and public constants and enums with the `RESNIP_` prefix, because GameMaker has one global namespace for scripts and the prefix keeps the library out of the game's names.
- `C004` Name arguments and locals `_snake`, everything internal `__resnip_snake`, and private members of a struct `__snake`, because the marks say who may call or read a name.
- `C005` Keep one function per script, named like the function, with internal scripts in the `(System)` folder, because the editor finds a script by its name.
- `C006` Hand the library every value of the game through a function such as `resnip_set_game_speed`, because the library must run in any game without reading it.
- `C007` Document every public function with JSDoc: what it does, what it returns, how it differs from the native function or from AESnips when one resembles it, and one `@param {Type} name Description` line per argument, because the editor shows it as help.
- `C008` Put constants in enums and macros, and keep configuration in setup functions apart from behaviour, because a repeated literal drifts.
- `C009` Prefer code that works, then code a newcomer understands on first read, then small replaceable units, and weigh speed only after those.
- `C010` Mark a short function that runs often with `gml_pragma("forceinline")`, and only a short one, because inlining a long function grows every caller.
- `C011` Print messages with the level in brackets, `[INFO]`, `[WARNING]`, `[ERROR]` or `[DEBUG]`, and make a message about a failure say why it failed and what would change it.
- `C012` Comment in one line: a label for a block, or the reason where the code is hard to follow.

### Project files

- `P001` Edit `resnip.yyp`, each `.yy` and `resnip.resource_order` as little as possible and keep the exact line format the IDE writes, because the IDE is fragile with them.

### Testing

- `T001` Test with the VM runtime, and build any executable you share with YYC, because the two compilers can behave differently.
- `T002` Name a test after the behaviour it checks and work its expected value out by hand from the rule, because a value copied from the output of the code proves nothing.
- `T003` Give a generated case a seed and put the seed in the failure message, because a failure must reproduce.
- `T004` Break the code once for every test or fix you add and watch the test fail, because a test that cannot fail proves nothing. No test holds this rule, so it holds by attention alone.
- `T005` Register a fault you found and did not fix with `__resnip_test_known_failure`, because the run then stays green and the fault stays visible. The run reports a known failure that passes as an error, so remove the mark.
- `T006` Delete `.sandbox/igor/cache` before a YYC run after you add, rename or edit scripts that hold anonymous functions, because the incremental cache keeps stale generated code and the link fails with unresolved externals. Observed on 2026-10-15 with runtime 2026.0.0.23.

### Documents and scratch work

- `D001` Keep each document to its own role and give each fact one owner, linking to the owner instead of restating it, because two copies drift.
- `D002` Open every document under `docs/` with an "About this document" block, because it lets a reader decide in ten seconds.
- `D003` Record a measurement as its method, its number and its date, and say whether the repository lets anyone repeat it, because a number without a method cannot be checked.
- `D004` Keep scratch work, probes and benchmark copies in `.sandbox/`, which git ignores, and let no rule depend on a file there, because the repository must stand without it.
- `D005` Name the standard a rule rests on, or say it is a local convention.

### Version control

- `G001` Make each commit one logical change, so it can be reviewed and reverted alone. Authority: the `SubmittingPatches` guide of Git.
- `G002` After a change, run `git status` and `git diff` and look at every `.yy` that changed, because the IDE rewrites them.
- `G003` Give a commit a simple and clear title and a one line description of what changed and why, with no colon, semicolon, dash or complex word, because the history should read easily.

### Verification

- `V001` Verify a change on the path a person takes, because a shortcut can pass while the real path is broken.
- `V002` State how a change was verified and what was not, including anything that needs the game to run, because nobody should assume a check that never ran.

### Agents

- `A001` Read this whole document before changing anything, then [ARCHITECTURE.md](./ARCHITECTURE.md), and read the decision records before changing anything that looks wrong.
- `A002` Treat every rule as binding. Only the maintainer may override one, and only in the conversation.
- `A003` Stop and ask when a task seems to need breaking a rule or reopening a decision, and do not choose silently.
- `A004` Add a file under `docs/` only when the user asks.
- `A005` Act on the backlog or reopen a decision record only when the user asks.
- `A006` Report in the conversation what you did and what you verified, and say plainly what you could not verify.
- `A007` Keep to the scope of the request, and mention what you notice elsewhere without changing it.
- `A008` When the user asks for a commit, follow `G003`.

## Never

### Code

- `C013` Never read a global, an asset or a setting of the game from the library, because `C006` hands such values in.
- `C014` Never use a leading underscore to mark a type, because the underscore already marks scope under `C004`.
- `C015` Never repeat a literal that an enum or a macro could name.
- `C016` Never write a decorative comment, a comment over more than one line, two comments stacked, or a semicolon in comment text.
- `C017` Never add a feature, a flag or error handling for a case nobody asked for or that cannot happen, because each one is code to keep.
- `C018` Never refactor unrelated code while fixing a bug, because it hides the fix in the diff.
- `C019` Never golf code, because `C009` puts readability before brevity.

### Project files

- `P002` Never turn a legacy option of the project on, such as the collision compatibility mode, the legacy JSON parsing or the copy-on-write of arrays, because they keep deprecated behaviour alive. See [0012](./decisions/0012-keep-every-legacy-option-of-the-project-off.md).

### Testing

- `T007` Never let a test name or compare with another library, because a test states the behaviour of Resnip in its own terms.

### Documents and scratch work

- `D006` Never narrate a correction inside a document, because git keeps how the text changed.
- `D007` Never write a rule for an agent outside the Agents section, and never write a shared document as if addressed to one.

### Version control

- `G004` Never rewrite the history of a shared branch, because others build on those commits. Authority: the Pro Git book, "Do not rebase commits that exist outside your repository".

### Verification

- `V003` Never report a result you did not observe.

### Agents

- `A009` Never edit `docs/reference/` or the art under `sprites/` unless the user asks, because the first holds checked facts and the second is not ours.
- `A010` Never make a commit or a push unless the user asks for it in that request, because the user alone answers for each commit.
- `A011` Never mention the agent, its model or the company behind it in a commit or in any file, because the user alone answers for the work. This is a choice of the maintainer, and git history and tooling can still add a trailer on their own, so check each message.
- `A012` Never leave the project directory, not to look for a file you did not find and not to read the user's system, because the project is your whole sandbox. The only exception is a path the user gives you for one specific task.
- `A013` Never read, print, copy or transmit a secret, and refer to it by its variable name.

## Before you touch, read

| Before you touch | Read |
| --- | --- |
| `resnip_player_step` or any `__resnip_player_*` script | [Architecture: time and speed](./ARCHITECTURE.md#time-and-speed), [0003](./decisions/0003-advance-time-with-an-integer-frame-and-an-accumulator.md) |
| The end of a snip, `end_mode` or `complete_on` | [0004](./decisions/0004-describe-the-end-of-a-snip-with-a-mode-and-a-completion-rule.md) |
| `next`, the queue or transitions | [0005](./decisions/0005-decide-what-plays-next-with-one-rule.md) |
| A loop count or a frame speed set at run time | [0002](./decisions/0002-keep-playback-state-in-the-player-and-fix-the-snip.md) |
| `direction`, `backward` or pause | [0006](./decisions/0006-keep-direction-in-the-player.md), [0007](./decisions/0007-share-pause-and-scale-through-a-clock.md) |
| `resnip_instance_sync` | [0008](./decisions/0008-sync-an-instance-from-a-player.md) |
| A speed of 0, or a loop with a count below 0 | [0009](./decisions/0009-let-a-speed-of-zero-hold-a-frame.md), [0010](./decisions/0010-hold-a-snip-whose-every-frame-is-skipped.md) |
| A callback, frame script or completion script | [0011](./decisions/0011-run-a-callback-for-every-frame-entered.md) |
| Behaviour that differs from AESnips | [0001](./decisions/0001-rewrite-aesnips-with-structs-and-one-playback-core.md), [AESnips](./reference/aesnips.md) |
| `options/main/options_main.yy` or a platform option | [0012](./decisions/0012-keep-every-legacy-option-of-the-project-off.md), `P001`, `P002` |
| The test harness, `tools/` or the benchmark | [Architecture: tests](./ARCHITECTURE.md#tests), `T001` to `T007` |
