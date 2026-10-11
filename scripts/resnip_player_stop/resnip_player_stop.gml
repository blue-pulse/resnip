/// @func resnip_player_stop(player, [where])
/// @desc Stops a player where it is, on the first frame or on the last frame, until it is told to play again. Pause is different, since it keeps the state and resumes. It does nothing if the player plays no snip.
/// @param {Struct} player The player to stop
/// @param {Constant.RESNIP_STOP} [where] Where to leave it (default RESNIP_STOP.HERE)
function resnip_player_stop(_player, _where = RESNIP_STOP.HERE) {
	// Prevent stopping a player with no snip
	if (_player.snip == undefined) {
		return;
	}

	// Move to the chosen frame
	if (_where == RESNIP_STOP.HEAD) {
		_player.frame = 0;
		_player.__progress = 0;
	} else if (_where == RESNIP_STOP.TAIL) {
		_player.frame = _player.snip.count - 1;
		_player.__progress = 0;
	}

	// Stop
	_player.stopped = true;
}
