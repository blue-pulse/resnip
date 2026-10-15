/// @description Create the snip and the players
// Snip
my_snip = resnip_snip_create(sprite_index, {
	frame_speeds: [
		{ frame: 0, speed: 0.5 },
		{ frame: 9, speed: 0.5 },
	],
	// Try RESNIP_COMPLETE.HEAD to complete only when the snip comes back to its first frame
	end_mode: RESNIP_END.PINGPONG,
	complete_on: RESNIP_COMPLETE.EDGE,
	on_complete: method(self, function(_argument, _player) {
		if (_player == main_player) {
			image_angle += 5;
		}
	}),
});

// Players
main_player = resnip_player_create();
copy_player = resnip_player_create();
resnip_player_play(main_player, my_snip);
resnip_player_play(copy_player, my_snip);
