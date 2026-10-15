/// @description Create the players
// Players
main_player = resnip_player_create();
copy_player = resnip_player_create();
resnip_play(main_player, obj_runner_snip_holder.left_snip);
resnip_play(copy_player, obj_runner_snip_holder.left_snip);

// Variables
facing_left = true;

// Plays the snip for the side the runner now faces, now or after the current one
turn = function(_transition, _now) {
	facing_left = !facing_left;
	var _snip = facing_left ? obj_runner_snip_holder.left_snip : obj_runner_snip_holder.right_snip;
	var _options = { transition: _transition, queue: !_now };
	resnip_play(main_player, _snip, _options);
	resnip_play(copy_player, _snip, _options);
};
