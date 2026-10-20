# AGENTS.md

Resnip is a sprite animation library for GameMaker, written in GML. Everything about it lives in `docs/`, and the project is complete without this file. This file holds no rule that is not in `docs/CONTRIBUTING.md`.

## Sandbox

This directory is your whole sandbox. Never leave it, not to look for a file you did not find and not to read the user's system. The only exception is a path the user gives you for one specific task (`A012`).

## Read first

1. `docs/CONTRIBUTING.md` in full. Its rules bind you like any contributor, and the ones under code `A` are written for you.
2. `docs/PRINCIPLES.md`
3. `docs/ARCHITECTURE.md`.
4. `docs/decisions/`, before you change anything that looks wrong.

## Navigating the repository

- Code lives in `scripts/<name>/<name>.gml`, one function per script. Public names start with `resnip_`, and internal names start with `__resnip_`. Search for a name to find it.
- Test code starts with `__resnip_test_`, and the benchmark with `__resnip_bench_`. Search results are crowded by tests, so filter on `scripts/resnip_*` or `scripts/__resnip_playback_*` to read the library alone.
- In the IDE, the library is the folder `Resnip`, and what is public sits outside `Resnip/_Internal`. A resource says which virtual folder it is in with `parent` in its `.yy` (`S003`).
- `resnip.yyp`, `resnip.resource_order` and every `.yy` are written by the GameMaker IDE and are fragile (`P001`). The art under `sprites/` and the pages under `docs/reference/` are not yours to edit (`A009`).
- `.sandbox/` is ignored by git. It holds private work, and no rule depends on it (`D004`).

## Checks

- When a run fails, read what `python tools/gm.py doctor` prints before anything else (`A014`). The guides to the external tools are in `docs/reference/`.
- Run the tests with `python tools/gm.py test`, and again with `--yyc` before you share a build. Delete `.sandbox/igor/cache` first when you changed scripts (`T006`).
- After a change, run `git status` and `git diff` and look at every `.yy` that changed (`G002`).
- Say what you verified and what you could not, including anything that needs the game to run (`A006`).
