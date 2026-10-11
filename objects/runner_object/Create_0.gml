/// @description Create the players
main_player = resnip_player_create();
copy_player = resnip_player_create();
resnip_player_play(main_player, runner_snip_holder.left_snip);
resnip_player_play(copy_player, runner_snip_holder.left_snip);

facing_left = true;

// Plays the snip for the side the runner now faces, now or after the current one
turn = function(_transition, _now)
{
	facing_left = !facing_left;
	var _snip = facing_left ? runner_snip_holder.left_snip : runner_snip_holder.right_snip;
	var _options = { transition: _transition, queue: !_now };
	resnip_player_play(main_player, _snip, _options);
	resnip_player_play(copy_player, _snip, _options);
};
