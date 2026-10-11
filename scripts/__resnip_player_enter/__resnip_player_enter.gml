function __resnip_player_enter(_player)
{
	var _snip = _player.snip;
	if (_player.__loop == __RESNIP_NO_LOOP)
	{
		for (var _i = 0; _i < array_length(_snip.loops); _i++)
		{
			var _loop = _snip.loops[_i];
			if (_player.frame < _loop.first || _player.frame > _loop.last)
			{
				continue;
			}

			var _repeats = __resnip_loop_repeat(_player, _loop);
			var _passes = _player.__passes[_i];
			if (_repeats < 0 && _passes <= 0)
			{
				_player.__passes[_i] += 1;
				var _target = (_player.direction > 0) ? _loop.last + 1 : _loop.first - 1;
				if (_target < 0 || _target >= _snip.count)
				{
					__resnip_player_finish(_player);
					return;
				}
				_player.frame = _target;
				__resnip_player_enter(_player);
				return;
			}

			if (_passes < _repeats)
			{
				_player.__loop = _i;
				break;
			}
		}
	}

	var _script = _snip.frame_scripts[_player.frame];
	if (_script != undefined)
	{
		var _callback = _script.callback;
		_callback(_script.argument, _player);
	}
}
