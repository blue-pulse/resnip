# 0012. Keep every legacy option of the project off

## About this document

This record decides the compatibility options of the GameMaker project. Read it before you change `options/main/options_main.yy` or the project settings of any platform. It covers the eight deprecated behaviours and the removal of unused assets. It does not cover the names and descriptions in the platform options, which are plain settings. Update it when GameMaker adds or removes a legacy option.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- Every deprecated behaviour of the project is off, and unused assets are removed when compiling.
- Never turn a legacy option on to make an old snippet work. Change the snippet.

## Context and problem statement

The project came from the AESnips demo, which was made for GameMaker 2.3, and all eight deprecated behaviours were on. The manual of GameMaker LTS (`Settings/Game_Options`, read on 2026-10-15) says that all of them are off by default in a new project and that they are recommended to stay off unless an older project needs them. It also says that removing unused assets when compiling is on by default.

## Decision outcome

These keys of `options_main.yy` are `false`: `option_collision_compatibility` (collision system before 2022, with integer bounding boxes), `option_audio_error_behaviour` (hides audio errors), `option_legacy_json_parsing`, `option_legacy_number_conversion`, `option_legacy_other_behaviour`, `option_legacy_primitive_drawing` (coordinates before 2024.14), `option_allow_instance_change` and `option_copy_on_write_enabled` (the deprecated copy-on-write of arrays). `option_remove_unused_assets` is `true`.

## Considered options

- Keep the options on, as the demo had them, was refused, because they keep deprecated paths alive in a library meant for current GameMaker.
- Keep `option_copy_on_write_enabled` on, because the library copies arrays on purpose, was refused. The library copies explicitly where it needs a copy (`resnip_set_frame_speed`) and never relies on the implicit one.

## Consequences

- Checked on 2026-10-15 with runtime 2026.0.0.23: the code outside the tests has no use of `other`, `instance_change`, `position_change`, JSON functions, audio functions, primitives or collision functions, and no object of the demo has a collision event (read with a text search). The 172 tests passed on the VM and on YYC with the options off, and the demo started and ran for about a minute without a runtime error in its output. Nobody looked at the screen, so the picture of the demo is unverified.
- No benchmark was run for this change, so its effect on speed is not measured. The options remove deprecated compatibility paths, and none of them guarantees speed.
- Projects that use Resnip are not bound by these settings. They set their own.
