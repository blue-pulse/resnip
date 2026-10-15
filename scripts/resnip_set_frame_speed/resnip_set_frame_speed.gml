/// @func resnip_set_frame_speed(player, frame, speed)
/// @desc Changes the speed of one frame for one player, while the game runs, without changing the shared snip. A speed of 0 holds the player on that frame until its speed changes or the player plays another snip. The change lasts while the player plays the same snip. It replaces snip_set_frame_speed of AESnips, which changed the snip for every user.
/// @param {Struct} player The player to change, which must play a snip
/// @param {Real} frame The frame of that snip, counted from 0
/// @param {Real} speed The speed of that frame, 0 or above, or undefined to use the value of the snip again
function resnip_set_frame_speed(_player, _frame, _speed) {
	// Prevent a player with no snip
	var _snip = _player.snip;
	if (_snip == undefined) {
		__resnip_error("resnip_set_frame_speed received a player that plays no snip. Play a snip with resnip_play first.");
	}

	// Prevent a frame outside the snip
	__resnip_check_frame(_frame, _snip.count, "resnip_set_frame_speed");

	// Prevent a speed that cannot be used
	if (_speed != undefined && _speed < 0) {
		__resnip_error("resnip_set_frame_speed received speed " + string(_speed) + ". Use a speed of 0 or above, and play backward with the backward option of resnip_play.");
	}

	// Copy the speeds of the snip on the first change
	if (!_player.__own_frame_speeds) {
		_player.__frame_speeds = array_create(_snip.count);
		array_copy(_player.__frame_speeds, 0, _snip.frame_speeds, 0, _snip.count);
		_player.__own_frame_speeds = true;
	}
	_player.__frame_speeds[_frame] = _speed ?? _snip.frame_speeds[_frame];
}
