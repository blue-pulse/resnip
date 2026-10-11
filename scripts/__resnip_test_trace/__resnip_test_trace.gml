function __resnip_test_trace(_player, _steps, _full = false) {
	var _trace = [];
	for (var _i = 0; _i < _steps; _i++)
	{
		resnip_player_step(_player);
		array_push(_trace, _full ? string(_player.snip.first_image) + "." + string(_player.frame) : _player.frame);
	}
	return _trace;
}
