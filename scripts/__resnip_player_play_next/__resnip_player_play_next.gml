function __resnip_player_play_next(_player) {
	// Pick what plays next
	var _next = _player.__queue;
	var _transition = _player.__queue_transition;
	if (_next == undefined)
	{
		_next = _player.__target;
		_transition = false;
	}
	if (_next == undefined)
	{
		_next = _player.snip.next;
		_transition = true;
	}
	if (_next == undefined)
	{
		return false;
	}

	// Start it
	if (_next == _player.snip)
	{
		_transition = false;
	}
	resnip_player_play(_player, _next, { transition: _transition });
	return true;
}
