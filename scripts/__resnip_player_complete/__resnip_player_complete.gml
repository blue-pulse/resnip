function __resnip_player_complete(_player) {
	// Variables
	var _snip = _player.snip;

	// Completion script
	if (_snip.on_complete != undefined) {
		var _serial = _player.__serial;
		var _callback = _snip.on_complete;
		_callback(_snip.on_complete_argument, _player);

		// Prevent a second snip when the script started one
		if (_player.__serial != _serial) {
			return true;
		}
	}

	// Next snip
	return __resnip_player_play_next(_player);
}
