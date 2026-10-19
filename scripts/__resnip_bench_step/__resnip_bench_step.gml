function __resnip_bench_step(_bench) {
	// Finish after the last configuration
	if (_bench.index >= array_length(_bench.configs)) {
		return true;
	}

	// Variables
	var _config = _bench.configs[_bench.index];

	// Create the playbacks
	if (array_length(_bench.playbacks) == 0) {
		for (var _i = 0; _i < _config.count; _i++) {
			var _playback = resnip_playback_create();
			resnip_play(_playback, _config.snip);
			array_push(_bench.playbacks, _playback);
		}
		_bench.steps = 0;
		_bench.micros = 0;
	}

	// Time the step
	var _start = get_timer();
	for (var _i = 0; _i < _config.count; _i++) {
		resnip_step(_bench.playbacks[_i]);
	}
	var _elapsed = get_timer() - _start;

	// Count the step
	_bench.steps += 1;
	if (_bench.steps > __RESNIP_BENCH_WARMUP) {
		_bench.micros += _elapsed;
	}

	// Report the result
	if (_bench.steps >= __RESNIP_BENCH_STEPS) {
		var _measured = __RESNIP_BENCH_STEPS - __RESNIP_BENCH_WARMUP;
		show_debug_message("[BENCH] playbacks=" + string(_config.count) + " loops=" + string(_config.loops) + " step_us=" + string(_bench.micros / _measured) + " playback_ns=" + string(_bench.micros * 1000 / _measured / _config.count));
		_bench.playbacks = [];
		_bench.index += 1;
	}
	return false;
}
