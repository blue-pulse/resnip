/// @description Create the snip and the playbacks
// Snip
my_snip = resnip_snip_create(sprite_index, {
	frame_speeds: [
		{ frame: 0, speed: 0.5 },
		{ frame: 9, speed: 0.5 },
	],
	// Try RESNIP_COMPLETE.HEAD to complete only when the snip comes back to its first frame
	end_mode: RESNIP_END.PINGPONG,
	complete_on: RESNIP_COMPLETE.EDGE,
	on_complete: method(self, function(_argument, _playback) {
		if (_playback == main_playback) {
			image_angle += 5;
		}
	}),
});

// Playbacks
main_playback = resnip_playback_create();
copy_playback = resnip_playback_create();
resnip_play(main_playback, my_snip);
resnip_play(copy_playback, my_snip);
