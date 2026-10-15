function __resnip_player_finish(_player) {
	// Variables
	var _snip = _player.snip;
	var _forward = _player.direction > 0;

	// Completion
	var _completes = true;
	if (_snip.end_mode == RESNIP_END.PINGPONG) {
		if (_snip.complete_on == RESNIP_COMPLETE.HEAD) {
			_completes = !_forward;
		} else if (_snip.complete_on == RESNIP_COMPLETE.TAIL) {
			_completes = _forward;
		}
	}
	if (_completes && __resnip_player_complete(_player)) {
		return;
	}

	// End mode
	switch (_snip.end_mode) {
		case RESNIP_END.HOLD:
			_player.frame = _forward ? _snip.count - 1 : 0;
			_player.stopped = true;
		break;

		case RESNIP_END.REWIND:
			_player.frame = 0;
			_player.stopped = true;
		break;

		case RESNIP_END.FASTFORWARD:
			_player.frame = _snip.count - 1;
			_player.stopped = true;
		break;

		case RESNIP_END.REPEAT:
			_player.frame = _forward ? 0 : _snip.count - 1;
			__resnip_player_reset_loops(_player);
			__resnip_player_enter(_player);
		break;

		case RESNIP_END.PINGPONG:
			_player.direction = -_player.direction;
			_player.frame = clamp(_forward ? _snip.count - 2 : 1, 0, _snip.count - 1);
			__resnip_player_reset_loops(_player);
			__resnip_player_enter(_player);
		break;
	}
}
