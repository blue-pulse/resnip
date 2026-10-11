function __resnip_player_complete(_player)
{
	var _snip = _player.snip;
	if (_snip.on_complete != undefined)
	{
		var _serial = _player.__serial;
		var _callback = _snip.on_complete;
		_callback(_snip.on_complete_argument, _player);
		if (_player.__serial != _serial)
		{
			return true;
		}
	}
	return __resnip_player_play_next(_player);
}
