/// @func resnip_player_step(player, [steps])
/// @desc Advances a player by some game steps. Call it once per step. It moves frame by frame, so a script runs for every frame the player enters even at a high speed. It replaces the automatic advance of image_speed, which the library does not use.
/// @param {Struct} player The player to advance
/// @param {Real} [steps] How many steps to advance, a fraction for delta time (default 1)
function resnip_player_step(_player, _steps = 1) {
	// Prevent a player that cannot move from advancing
	if (_player.snip == undefined || _player.stopped || _player.paused || _player.clock.paused)
	{
		return;
	}

	// Variables
	var _remaining = _steps;
	while (_remaining > __RESNIP_EPSILON && !_player.stopped)
	{
		// Speed of the current frame
		var _snip = _player.snip;
		var _rate = _snip.frame_speeds[_player.frame] * _snip.speed * _player.speed * _player.clock.scale * __resnip_sprite_scale(_snip);
		if (_rate <= 0)
		{
			return;
		}

		// Stay in the frame when the steps do not finish it
		var _room = 1 - _player.__progress;
		if (_remaining * _rate < _room - __RESNIP_EPSILON)
		{
			_player.__progress += _remaining * _rate;
			return;
		}

		// Finish the frame and move on
		_remaining -= max(_room, 0) / _rate;
		_player.__progress = 0;
		__resnip_player_move(_player);
	}
}
