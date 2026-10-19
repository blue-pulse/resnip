function __resnip_test_trace(_playback, _steps, _full = false) {
	var _trace = [];
	for (var _i = 0; _i < _steps; _i++) {
		resnip_step(_playback);
		array_push(_trace, _full ? string(_playback.snip.first_image) + "." + string(_playback.frame) : _playback.frame);
	}
	return _trace;
}
