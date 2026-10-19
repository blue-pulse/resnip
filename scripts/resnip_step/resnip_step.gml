/// @func resnip_step(playback, [steps])
/// @desc Advances a playback by some game steps. Call it once per step. It moves frame by frame, so a script runs for every frame the playback enters even at a high speed. It replaces the automatic advance of image_speed, which the library does not use. For delta time pass delta_time / 1000000 * game_get_speed(gamespeed_fps) as the steps.
/// @param {Struct} playback The playback to advance
/// @param {Real} [steps] How many steps to advance, a fraction for delta time (default 1)
function resnip_step(_playback, _steps = 1) {
	// Prevent a playback that cannot move from advancing
	if (_playback.snip == undefined || _playback.stopped || _playback.paused || _playback.clock.paused) {
		return;
	}

	// Variables
	var _remaining = _steps;
	while (_remaining > __RESNIP_EPSILON && !_playback.stopped) {
		// Speed of the current frame
		var _snip = _playback.snip;
		var _rate = _playback.__frame_speeds[_playback.frame] * _snip.speed * _playback.speed * _playback.clock.scale * __resnip_sprite_scale(_snip);
		if (_rate <= 0) {
			return;
		}

		// Stay in the frame when the steps do not finish it
		var _room = 1 - _playback.__progress;
		if (_remaining * _rate < _room - __RESNIP_EPSILON) {
			_playback.__progress += _remaining * _rate;
			return;
		}

		// Finish the frame and move on
		_remaining -= max(_room, 0) / _rate;
		_playback.__progress = 0;
		__resnip_playback_move(_playback);

		// Stop for a pause that a callback set
		if (_playback.paused || _playback.clock.paused) {
			return;
		}
	}
}
