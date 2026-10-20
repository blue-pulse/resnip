# Contributing to Resnip

## About this document

This document holds the rules for working on Resnip. It is for anyone who works on this repository, and it binds everyone the same way. Follow each rule exactly as written. The maintainer is the owner of the project, the user is whoever is working in it at the moment, and only the maintainer may override a rule, and only in chat.

It contains the commands you run, what you must always do, what you must never do, and what to read before you change a given area. It does not explain how the library is organised, which is [ARCHITECTURE.md](./ARCHITECTURE.md), and it does not argue the larger decisions, which are the records in [decisions/](./decisions/). The external tools are described in [reference/](./reference/), and the backlog is [PENDING.md](./PENDING.md). The principles behind every rule are in [PRINCIPLES.md](./PRINCIPLES.md). No tool checks a rule of this document, so each holds by attention alone.

Each rule carries a stable code, the way Ruff codes its lint rules: a letter for its section and three digits, such as `C009`. Cite a rule by its code, in a document, a code comment or a review. Always and Never share one sequence per letter, so a list shows gaps. A rule that names no authority is a local convention that no external standard names.

| Code | Section | Always | Never |
| --- | --- | --- | --- |
| `C` | Code | [Always](#code) | [Never](#code-1) |
| `P` | Project files | [Always](#project-files) | [Never](#project-files-1) |
| `S` | Structure | [Always](#structure) | [Never](#structure-1) |
| `T` | Testing | [Always](#testing) | [Never](#testing-1) |
| `D` | Documents and scratch work | [Always](#documents-and-scratch-work) | [Never](#documents-and-scratch-work-1) |
| `G` | Version control | [Always](#version-control) | [Never](#version-control-1) |
| `V` | Verification | [Always](#verification) | [Never](#verification-1) |
| `A` | Agents | [Always](#agents) | [Never](#agents-1) |

A new rule takes the next free number of its letter and goes at the end of its section. A code is never reused or renumbered, and a retired rule keeps its line as `Retired` with one sentence saying why.

Update it when a rule is added, changed or retired. Each rule is one line with its reason. A choice that looks wrong but is deliberate also gets a record under `decisions/`, as [0020](./decisions/0020-record-architecture-decisions-with-a-fence-and-a-cost.md) states. Anything smaller stays a line here.

## Commands

Run them from the repository root. They need the Python version in `tools/pyproject.toml` (3.11 or later today) and a GameMaker runtime of the same year as the IDE version that saved `resnip.yyp`.

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
- `C002` Use the plain word, such as `use` over `utilize`, because short words read faster, as the Google developer documentation style guide asks for clear and straightforward language.
- `C003` Name public functions `resnip_action` in snake_case and public constants and enums with the `RESNIP_` prefix, because GameMaker has one global namespace for scripts and the prefix keeps the library out of the game's names.
- `C004` Name arguments and locals `_snake`, everything internal `__resnip_snake`, and private members of a struct `__snake`, because the marks say who may call or read a name.
- `C005` Keep one function per script, named like the function, with internal scripts in the `_Internal` folder, because the editor finds a script by its name.
- `C006` Hand the library every value of the game through a function, except the gamespeed, which the library reads with `game_get_speed(gamespeed_fps)`, because the gamespeed is a setting of the engine and a setter is one more call to forget. See [0013](./decisions/0013-read-the-gamespeed-from-the-engine.md).
- `C007` Document every public function with JSDoc: what it does, what it returns, how it differs from the native function or from AESnips when one resembles it, and one `@param {Type} name Description` line per argument, because the editor shows it as help.
- `C008` Put constants in enums and macros, and keep configuration in setup functions apart from behaviour, because a repeated literal drifts. Authority: Fowler's *Refactoring* catalogues it as Replace Magic Literal, and Dijkstra names the separation of concerns in "On the role of scientific thought".
- `C009` Prefer code that works, then code a newcomer understands on first read, then small replaceable units, and weigh speed only after those.
- `C010` Mark a short function that runs often with `gml_pragma("forceinline")`, and only a short one, because inlining a long function grows every caller. Authority: the GameMaker manual on `gml_pragma`, which says YYC honours it (the VM does not, see [0017](./decisions/0017-enter-the-next-frame-in-the-step-and-allocate-only-what-is-used.md)).
- `C011` Print messages with the level in brackets, `[INFO]`, `[WARNING]`, `[ERROR]` or `[DEBUG]`, so every line reads the same. The names follow the severities of RFC 5424 (syslog), whose list was not read in full.
- `C012` Comment in one line: a label for a block, or the reason where the code is hard to follow.
- `C020` Write gamespeed as one word in names, text and comments, because GameMaker does (`gamespeed_fps`).
- `C021` Make a message that reports a failure say why it failed and what would change it, in the words of somebody who has not read the code, so a log line saves them opening a file.

### Project files

- `P001` Edit `resnip.yyp`, each `.yy` and `resnip.resource_order` as little as possible and keep the exact line format the IDE writes, because the IDE is fragile with them.

### Structure

The folders below are the virtual folders of the IDE. On disk, GameMaker keeps one folder per resource under `scripts/`, `objects/` and the like, and `parent` in the `.yy` of a resource says which virtual folder it belongs to.

- `S001` Group the folders by domain and not by type of resource, so everything about one part lives together and the names show what the project is for. Authority: Martin's "Screaming Architecture", which was not re-read.
- `S002` Name a folder with one word, so a folder is found at a glance. This is a local convention.
- `S003` Keep the library in the folder `Resnip`, with what a user may call in folders by area and everything else in `Resnip/_Internal`, so a person sees at once what to call and what to leave alone. PEP 8 marks internal interfaces with a leading underscore and Go keeps them in a directory named `internal`, and the Input, DB and SparkleStore libraries of Juju Adams use a `(System)` folder for the same purpose (all read on 2026-10-19 through a page summariser). The parentheses are not used here because the maintainer does not like them.
- `S004` Prefix sprites with `spr_`, objects with `obj_` and rooms with `rm_`, because the name is the only context a resource has in code. Scripts carry no prefix, since `C003` and `C004` name them. This is a local convention.
- `S005` Keep to 4 levels of folders at most, and aim for 5 to 9 items per folder, subdividing above 9 by responsibility and merging below 5 when the items belong together. This follows "flat is better than nested" from PEP 20 and Miller's "The Magical Number Seven, Plus or Minus Two" as a heuristic and not a law. `_Internal` and `Harness` hold more than 9 because they are searched by name.
- `S006` Put a resource shared by several parts in the nearest common ancestor of its users, so no asset is duplicated or owned by chance.

### Testing

- `T001` Test with the VM runtime, and build any executable you share with YYC, because the two compilers can behave differently.
- `T002` Name a test after the behaviour it checks and work its expected value out by hand from the rule, because a value copied from the output of the code proves nothing.
- `T003` Give a generated case a seed and put the seed in the failure message, because a failure must reproduce.
- `T004` Break the code once for every test or fix you add and watch the test fail, because a test that cannot fail proves nothing. No test holds this rule, so it holds by attention alone.
- `T005` Register a fault you found and did not fix with `__resnip_test_known_failure`, because the run then stays green and the fault stays visible. The run reports a known failure that passes as an error, so remove the mark.
- `T006` Delete `.sandbox/igor/cache` before a YYC run after you add, rename or edit scripts that hold anonymous functions, because the incremental cache keeps stale generated code and the link fails with unresolved externals. Observed on 2026-10-15 with runtime 2026.0.0.23.
- `T008` Write a test only if you can name the behaviour it protects, because a test with no named behaviour protects nothing and still has to be maintained. See [0015](./decisions/0015-write-a-test-only-if-it-protects-a-named-behaviour.md).
- `T009` Write one test per equivalence class and per boundary of an input, because a second example of a class adds no information. Authority: the ISTQB definitions of equivalence partitioning and boundary value analysis, and ISO/IEC/IEEE 29119-4 (only its list of techniques was read).
- `T010` Assert on results and public state, never on private fields or the order of internal calls, because such a test breaks on a refactor that changes nothing visible. Authority: *Software Engineering at Google*, chapter 12, and Beck's Test Desiderata (structure-insensitive).
- `T011` Keep a test straight-line, with no loop, branch or computed expected value, because a test with logic needs its own test. Authority: *Software Engineering at Google*, chapter 12. A table of cases registered as one test per case is straight-line.

### Documents and scratch work

- `D001` Keep each document to its own role and give each fact one owner, linking to the owner instead of restating it, because two copies drift.
- `D002` Open every document under `docs/` with an "About this document" block, because it lets a reader decide in ten seconds.
- `D003` Record a measurement as its method, its number and its date, and say whether the repository lets anyone repeat it, because a number without a method cannot be checked.
- `D004` Keep scratch work, probes and benchmark copies in `.sandbox/`, which git ignores, and let no rule depend on a file there, because the repository must stand without it.
- `D005` Name the standard or practice a rule rests on, with its author or issuer, say when the rule departs from it, and say it is a local convention when none exists, so somebody who disagrees can check the reasoning, as [PRINCIPLES.md](./PRINCIPLES.md) asks. Say plainly when you could not read the source.
- `D008` Write each document in `reference/` about its subject alone, with no mention of this project, its tools or any machine, and with no link to another document, so it stays correct whatever happens to the rest.

### Version control

- `G001` Make each commit one logical change, so it can be reviewed and reverted alone. Authority: the `SubmittingPatches` guide of Git.
- `G002` After a change, run `git status` and `git diff` and look at every `.yy` that changed, because the IDE rewrites them.
- `G003` Give a commit a simple and clear title and a one line description of what changed and why, with no colon, semicolon, dash or complex word, because the history should read easily.

### Verification

- `V001` Verify a change on the path a person takes, because a shortcut can pass while the real path is broken.
- `V002` State how a change was verified and what was not, including anything that needs the game to run, because nobody should assume a check that never ran.

### Agents

- `A001` Read this whole document before changing anything, then [PRINCIPLES.md](./PRINCIPLES.md) and [ARCHITECTURE.md](./ARCHITECTURE.md), and read the decision records before changing anything that looks wrong.
- `A002` Treat every rule as binding. Only the maintainer may override one, and only in the conversation.
- `A003` Stop and ask when a task seems to need breaking a rule or reopening a decision, and do not choose silently.
- `A004` Add a file under `docs/` only when the user asks.
- `A005` Act on the backlog or reopen a decision record only when the user asks.
- `A006` Report in the conversation what you did and what you verified, and say plainly what you could not verify.
- `A007` Keep to the scope of the request, and mention what you notice elsewhere without changing it.
- `A008` When the user asks for a commit, follow `G003`.
- `A014` When a run fails, read what `python tools/gm.py doctor` prints before anything else, so nobody rebuilds the Igor command or reads the Igor guide again.

## Never

### Code

- `C013` Never read a global, an asset or a setting of the game from the library, apart from the gamespeed, because `C006` hands such values in.
- `C014` Never use a leading underscore to mark a type, because the underscore already marks scope under `C004`.
- `C015` Never repeat a literal that an enum or a macro could name.
- `C016` Never write a decorative comment, a comment over more than one line, two comments stacked, or a semicolon in comment text. The one exception is the JSDoc that `C007` requires on a public function.
- `C017` Never add a feature, a flag or error handling for a case nobody asked for or that cannot happen, because each one is code to keep. This is the YAGNI principle of Extreme Programming.
- `C018` Never refactor unrelated code while fixing a bug, because it hides the fix in the diff, and never optimise before measuring, as Knuth warns in "Structured Programming with go to Statements".
- `C019` Never golf code, because `C009` puts readability before brevity.

### Project files

- `P002` Never turn a legacy option of the project on, such as the collision compatibility mode, the legacy JSON parsing or the copy-on-write of arrays, because they keep deprecated behaviour alive. See [0012](./decisions/0012-keep-every-legacy-option-of-the-project-off.md).

### Structure

- `S007` Never put resources and subfolders in the same folder, because a mixed folder hides its structure and invites loose items.

### Testing

- `T007` Never let a test name or compare with another library, because a test states the behaviour of Resnip in its own terms.
- `T012` Never write a test to raise a coverage number, because a target makes people run code without checking it. Authority: Fowler, "TestCoverage", who quotes Marick.
- `T013` Never test a function of the engine, because such a test can only fail because of the engine and never because of your change. This is a local judgment, and no source states it.

### Documents and scratch work

- `D006` Never narrate a correction inside a document, because git keeps how the text changed.
- `D007` Never write a rule for an agent outside the Agents section, and never write a shared document as if addressed to one.

### Version control

- `G004` Never rewrite the history of a shared branch, because others build on those commits. Authority: the Pro Git book, "Do not rebase commits that exist outside your repository".

### Verification

- `V003` Never report a result you did not observe.

### Agents

- `A009` Never edit `docs/reference/` or the art under `sprites/` unless the user asks, because the first holds checked facts and the second is the art of the demo.
- `A010` Never make a commit or a push unless the user asks for it in that request, because the user alone answers for each commit.
- `A011` Never mention the agent, its model or the company behind it in a commit or in any file, because the user alone answers for the work. This is a choice of the maintainer, and git history and tooling can still add a trailer on their own, so check each message.
- `A012` Never leave the project directory, not to look for a file you did not find and not to read the user's system, because the project is your whole sandbox. The only exception is a path the user gives you for one specific task.
- `A013` Never read, print, copy or transmit a secret, and refer to it by its variable name.

## Before you touch, read

| Before you touch | Read |
| --- | --- |
| `resnip_step` or any `__resnip_playback_*` script | [Architecture: time and speed](./ARCHITECTURE.md#time-and-speed), [0003](./decisions/0003-advance-time-with-an-integer-frame-and-an-accumulator.md), [0017](./decisions/0017-enter-the-next-frame-in-the-step-and-allocate-only-what-is-used.md) |
| `game_get_speed` in `resnip_step`, or anything that reads the gamespeed | [0013](./decisions/0013-read-the-gamespeed-from-the-engine.md) |
| The name of a public function, or of the type that holds the state of an animation | [0014](./decisions/0014-name-the-functions-that-act-on-a-player-by-their-verb.md), [0016](./decisions/0016-name-the-type-playback.md), `C003` |
| The end of a snip, `end_mode` or `complete_on` | [0004](./decisions/0004-describe-the-end-of-a-snip-with-a-mode-and-a-completion-rule.md) |
| `next`, the queue or transitions | [0005](./decisions/0005-decide-what-plays-next-with-one-rule.md) |
| A loop count or a frame speed set at run time, or a field of a playback or a snip | [0002](./decisions/0002-keep-the-state-in-the-playback-and-fix-the-snip.md), [0017](./decisions/0017-enter-the-next-frame-in-the-step-and-allocate-only-what-is-used.md) |
| `direction`, `backward` or pause | [0006](./decisions/0006-keep-direction-in-the-playback.md), [0007](./decisions/0007-share-pause-and-scale-through-a-clock.md) |
| `resnip_instance_sync` | [0008](./decisions/0008-sync-an-instance-from-a-playback.md) |
| `sprite_durations`, `frame_speeds` or how a snip reads its sprite | [0018](./decisions/0018-let-a-snip-ask-for-the-durations-of-its-sprite.md), [0003](./decisions/0003-advance-time-with-an-integer-frame-and-an-accumulator.md) |
| `resnip_play_from`, or where a snip starts | [0019](./decisions/0019-start-a-snip-on-a-chosen-frame.md), [0005](./decisions/0005-decide-what-plays-next-with-one-rule.md) |
| A speed of 0, or a loop with a count below 0 | [0009](./decisions/0009-let-a-speed-of-zero-hold-a-frame.md), [0010](./decisions/0010-hold-a-snip-whose-every-frame-is-skipped.md) |
| A callback, frame script or completion script | [0011](./decisions/0011-run-a-callback-for-every-frame-entered.md) |
| Behaviour that differs from AESnips | [0001](./decisions/0001-rewrite-aesnips-with-structs-and-one-playback-core.md), [AESnips](./reference/aesnips.md) |
| The virtual folders, or where a new resource goes | [Architecture: codemap](./ARCHITECTURE.md#codemap), `S001` to `S007`, `P001` |
| `options/main/options_main.yy` or a platform option | [0012](./decisions/0012-keep-every-legacy-option-of-the-project-off.md), `P001`, `P002` |
| A test, or the rules for tests | [0015](./decisions/0015-write-a-test-only-if-it-protects-a-named-behaviour.md), `T001` to `T013` |
| The test harness, `tools/` or the benchmark | [Architecture: tests](./ARCHITECTURE.md#tests), `T001` to `T007` |
