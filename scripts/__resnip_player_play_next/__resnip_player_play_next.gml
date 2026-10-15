function __resnip_player_play_next(_player) {
	// Pick what plays next
	var _next = _player.__queue;
	var _transition = false;
	var _backward = false;
	if (_next != undefined) {
		_transition = _player.__queue_transition;
		_backward = _player.__queue_backward;
	} else {
		_next = _player.__target;
		if (_next != undefined) {
			_backward = _player.__target_backward;
		} else {
			_next = _player.snip.next;
			if (_next == undefined) {
				return false;
			}
			_transition = _player.snip.next_transition;
			_backward = _player.snip.next_backward;
		}
	}

	// Start it
	if (_next == _player.snip) {
		_transition = false;
	}
	resnip_player_play(_player, _next, { transition: _transition, backward: _backward });
	return true;
}
