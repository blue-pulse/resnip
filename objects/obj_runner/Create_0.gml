/// @description Create the playbacks
// Playbacks
main_playback = resnip_playback_create();
copy_playback = resnip_playback_create();
resnip_play(main_playback, obj_runner_snip_holder.left_snip);
resnip_play(copy_playback, obj_runner_snip_holder.left_snip);

// Variables
facing_left = true;

// Plays the snip for the side the runner now faces, now or after the current one
turn = function(_transition, _now) {
	facing_left = !facing_left;
	var _snip = facing_left ? obj_runner_snip_holder.left_snip : obj_runner_snip_holder.right_snip;
	var _options = { transition: _transition, queue: !_now };
	resnip_play(main_playback, _snip, _options);
	resnip_play(copy_playback, _snip, _options);
};
