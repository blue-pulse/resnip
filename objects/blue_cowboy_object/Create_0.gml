/// @description Create the snip and the players
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

// Players
main_player = resnip_player_create();
copy_player = resnip_player_create();
resnip_player_play(main_player, my_snip);
resnip_player_play(copy_player, my_snip);

// Variables
fire_count = 1;

// Loops start with 0 repeats, so each key press sets how many shots the loops play
set_fire_count = function(_count) {
	var _players = [main_player, copy_player];
	for (var _i = 0; _i < array_length(_players); _i++)
	{
		resnip_player_set_loop_repeats(_players[_i], my_snip.loops[1], _count - 1);
		resnip_player_set_loop_repeats(_players[_i], my_snip.loops[0], (_count == 0) ? -1 : 0);
	}
};
