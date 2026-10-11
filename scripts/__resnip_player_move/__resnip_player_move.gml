function __resnip_player_move(_player) {
	// Variables
	var _snip = _player.snip;
	var _forward = _player.direction > 0;
	var _next = _player.frame + _player.direction;

	// Loop edge
	if (_player.__loop != __RESNIP_NO_LOOP) {
		var _loop = _snip.loops[_player.__loop];
		if (_player.frame == (_forward ? _loop.last : _loop.first)) {
			_player.__passes[_player.__loop] += 1;
			_next = _forward ? _loop.first : _loop.last;
			if (_player.__passes[_player.__loop] >= __resnip_loop_repeat(_player, _loop)) {
				_player.__loop = __RESNIP_NO_LOOP;
			}
		}
	}

	// Snip edge
	if (_next < 0 || _next >= _snip.count) {
		__resnip_player_finish(_player);
		return;
	}

	// Enter the next frame
	_player.frame = _next;
	__resnip_player_enter(_player);
}
