# 0018. Let a snip ask for the durations of its sprite

## About this document

This record decides how a snip follows the duration that the sprite editor gives each frame. Read it before you change how a snip reads its sprite, the meaning of `frame_speeds`, `resnip_set_frame_speed`, or the default of `sprite_durations`. It covers the option, where the durations are read, how they combine with the frame speeds, sprites without durations, partial ranges and clones, and what it costs. It does not cover the rest of the speed formula, which is [0003](./0003-advance-time-with-an-integer-frame-and-an-accumulator.md), or a speed of 0, which is [0009](./0009-let-a-speed-of-zero-hold-a-frame.md). Update it when GameMaker changes how it reports the durations, or when a measurement is taken again.

- Status: accepted
- Date: 2026-10-19
- Decision-makers: the maintainer

## Summary

- `resnip_snip_create(sprite, {sprite_durations: true})` reads the duration of each frame from the sprite once, at creation, and a frame then lasts its duration times what it would last otherwise. A frame speed multiplies on top of it.
- Never read the durations without the option, never read them in the step, and never let a frame speed replace a duration.

## Context and problem statement

The sprite editor of GameMaker lets each frame last more or less than one frame of the sprite, and GameMaker plays an instance with those durations. Resnip read the speed of the sprite and its speed type but not the durations.

What GameMaker reports, observed on runtime 2026.0.0.23 on the VM and on YYC on 2026-10-19 with a sprite of three frames of durations 1, 2.5 and 0.5 set in its `.yy`:

- `sprite_get_info(sprite).frame_info` is an array of `{frame, duration, image_index}`, one entry per frame, where `frame` is the position on the timeline of the sprite.
- `frame_info` is `undefined` for a sprite whose frames all last 1, for a copy made with `sprite_duplicate`, and for a sprite made at run time with `sprite_create_from_surface`.
- An instance with `image_speed` 1 and a sprite at one frame per game frame showed sub-image 0 for one step and sub-image 1 for three, and never showed sub-image 2, so the animation repeated every 4 steps, the sum of the durations.
- `sprite_get_info` took about 6 µs for that sprite and 14 µs for a sprite of 17 frames on the VM, and 4 and 12 µs on YYC, as the mean of 1 000 calls.

The probe lives in `.sandbox/`, so the repository does not let anyone repeat it. The manual page of `sprite_get_info` was not read for this record, so the format above is what was observed and not what is documented.

## Decision outcome

The option is off by default, so every snip that does not ask plays as it did before and creating it does not call `sprite_get_info`. The name follows the word GameMaker uses in `frame_info`.

- `resnip_snip_create` reads `sprite_durations` and rejects a value that is not a bool.
- With the option, `__resnip_snip_build_durations` reads `frame_info` and returns the duration of every frame of the snip, found by the `image_index` of each entry less `first_image`, or `undefined` when the sprite has no `frame_info`. A duration that is not a number above 0 has not been observed. If one appears, that frame plays with a duration of 1 and a `[WARNING]` names the sprite and the sub-image, so the snip degrades instead of dividing by 0.
- The snip keeps `frame_speeds` as given, `__durations` (the durations, or `undefined`), and `__frame_speeds`, the speeds the step reads: each frame speed divided by its duration. Without durations `__frame_speeds` is the same array as `frame_speeds`, so it takes no memory and the step multiplies the same numbers as before.
- A playback starts with the `__frame_speeds` of its snip. `resnip_set_frame_speed` copies them on the first change, stores the speed it receives divided by the duration of that frame, and with `undefined` brings back the value of the snip. The step does not change.
- The rate of a frame becomes `frame_speed / duration * snip speed * playback speed * clock scale * sprite scale`. A duration is in frames of the sprite, so it applies the same way to a sprite in frames per second and to one in frames per game frame.
- A partial range reads only the durations of its own sub-images. `resnip_snip_clone` keeps the option, since it is one of the options of the snip, and reads the durations of the sprite of the clone, because it creates a new snip.
- A frame speed of 0 still holds the frame, because 0 divided by a duration is 0 ([0009](./0009-let-a-speed-of-zero-hold-a-frame.md)).

## Considered options

- **Read the durations of every snip by default** was refused. It matches GameMaker and the sprite speed that Resnip already reads, but it changes how existing sprites with durations play, and it made creating a snip of 20 frames about 3 times slower on YYC for every user, including those who never set a duration. The maintainer asked that what works today keep working the same, and that a game ask for the durations explicitly.
- **A second function such as `resnip_snip_create_ext`** was refused, because every property of a snip is an option of `resnip_snip_create`, and a second entry point for one option would be a wrapper with a single implementation.
- **Let the durations replace the frame speeds, or the reverse,** was refused, because they answer different questions: the artist sets the timing of the sprite, and the game changes it per snip.
- **Fold the durations into the public `frame_speeds`** was refused, because the field would no longer hold what was given.
- **Divide by the duration in the step** was refused, because it adds a read and a division to every frame crossed, where the snip can do it once.
- **Keep the durations in a cache per sprite** was refused, because a sprite can be replaced while the game runs, and the cost is paid once per snip.
- **Model a timeline with gaps or with one sub-image shown twice** was not built. Resnip plays the sub-images in order, and how GameMaker reports such a sprite was not observed.

## Consequences

- Cost. Method: copies of the library before and after in one process, alternating runs with the order rotated, runtime 2026.0.0.23, Windows 11, 2026-10-19. The harness lives in `.sandbox/`, so the repository does not let anyone repeat it. A difference under 3 percent is noise, since two runs of the same code differ by about 4 percent.
  - The step, 5 000 playbacks of one snip of 20 frames, 9 repetitions, six cases from one crossing per step to a paused playback: the geometric mean of the mean step was 0.992 on YYC and 1.001 on the VM against the code before. The step is the same code, so this is the noise of the method.
  - Memory of a playback after 25 steps, read with `debug_event("DumpMemory", true)`, 10 000 playbacks: 832 bytes with no loops and 1 216 with 4 loops, as before.
  - Creating a snip that does not ask, median of 24 repetitions of 2 000 snips, the library as committed against the code before, three runs on YYC and one on the VM: 2.8 to 4.3 percent slower on YYC (5.4 to 5.6 µs) and 6 percent on the VM (10.4 to 11.0 µs), from reading the option and the two new fields. It is paid once per snip.
  - Creating a snip that asks, on a sprite of 20 frames with durations: 25.4 µs on YYC and 44.7 µs on the VM, against 5.9 and 11.6 µs before. Almost all of it is `sprite_get_info`, which builds a struct for every frame of the sprite, so it grows with the number of sub-images. Creating snips once, in a Create event or behind a loading screen, pays it once.
- Behaviour of snips that do not ask was checked against the code before with a fixed trace of 2 240 steps (same md5) and with 2 000 random scenarios on the VM and 2 000 on YYC, 640 000 steps each, with no difference in any field, including the last bit of the progress.
- Pinned by the tests in the suite `speed` under "Sprite durations", which use `__resnip_test_timed_sprite`, a copy of `red_cowboy_full` where sub-image 3 lasts 2 and sub-image 4 lasts 0.5. `a snip ignores the sprite durations unless it asks for them` pins the default. Each test was checked by breaking the code once (rule `T004`).
- A sprite copied with `sprite_duplicate` loses its durations in GameMaker, so a snip of the copy plays every frame with a duration of 1 even when it asks. A sprite that asks and has no `frame_info` plays the same way with no warning, because it cannot be told apart from a sprite whose frames all last 1.
- Without this decision, a snip ignores the durations of its sprite, or reads them for every user and makes creating a snip about 3 times slower on YYC, and a frame speed replaces a duration instead of multiplying it.
