/// @description Create the snip and the playbacks
// Snip
my_snip = resnip_snip_create(blue_cowboy_sprite, {
	frame_speeds: [
		{ frame: 4, speed: 0.2 },
		{ frame: 8, speed: 0.2 },
		{ frame: 16, speed: 0.2 },
	],
	frame_scripts: [
		{ frame: 6, callback: method(self, cowboy_fire_bullet), argument: -10 },
	],
	loops: [
		{ first: 5, last: 12, repeats: 0 },
		{ first: 5, last: 8, repeats: 0 },
		{ first: 9, last: 11, repeats: 3 },
	],
});

// Playbacks
main_playback = resnip_playback_create();
copy_playback = resnip_playback_create();
resnip_play(main_playback, my_snip);
resnip_play(copy_playback, my_snip);

// Variables
fire_count = 1;

// Loops start with 0 repeats, so each key press sets how many shots the loops play
set_fire_count = function(_count) {
	var _playbacks = [main_playback, copy_playback];
	for (var _i = 0; _i < array_length(_playbacks); _i++) {
		resnip_set_loop_repeats(_playbacks[_i], my_snip.loops[1], _count - 1);
		resnip_set_loop_repeats(_playbacks[_i], my_snip.loops[0], (_count == 0) ? -1 : 0);
	}
};
