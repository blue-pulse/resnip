# 0008. Sync an instance from a player

## About this document

This record decides how an instance shows a player. Read it before you add instance state or a second playback path for instances. It covers `resnip_instance_sync` and why no state lives on the instance. It does not cover drawing without an instance, which `resnip_draw` and `resnip_draw_ext` do, or the debug panel, which is `resnip_debug_draw`. Update it when the sync copies another variable.

- Status: accepted
- Date: 2026-10-15
- Decision-makers: the maintainer

## Summary

- `resnip_instance_sync(player)` copies the sprite and the image of the player to the calling instance and sets `image_speed` to 0. The instance holds no state of Resnip.
- Never add a variable of the library to an instance.

## Context and problem statement

AESnips has an instance mode as its main mode, with `snip_create_event` and `snip_step_event`, and `ae_snip_` variables on the instance, plus a standalone player. The two share no code, so a fix is made twice. The runner advances `image_index` between the Step and Draw events, and AESnips predicts the next frame from the speed it sets, as its code reads. That was not run.

## Decision outcome

The player is the only playback code. An instance that wants masks, collisions or `draw_self` calls `resnip_instance_sync(player)` after the step of the player. The function sets `sprite_index` from the snip, `image_index` from `resnip_frame_to_image`, and `image_speed` to 0.

## Considered options

- Instance mode as the main mode was refused, because it needs state on the instance and a second playback code.
- Let the runner advance the image and only correct it was refused, because it reintroduces the float index of [0003](./0003-advance-time-with-an-integer-frame-and-an-accumulator.md).

## Consequences

- Pinned by one test in the suite `state`: `instance sync copies the sprite, the sub-image and stops image_speed`. It covers a player that plays forward only. A stopped or backward player is not tested, which is a gap.
- An instance that plays two animations at once uses two players and syncs from the one that drives its sprite.
