function __resnip_bench_step(_bench) {
	// Finish after the last configuration
	if (_bench.index >= array_length(_bench.configs)) {
		return true;
	}

	// Variables
	var _config = _bench.configs[_bench.index];

	// Create the players
	if (array_length(_bench.players) == 0) {
		for (var _i = 0; _i < _config.count; _i++) {
			var _player = resnip_player_create();
			resnip_player_play(_player, _config.snip);
			array_push(_bench.players, _player);
		}
		_bench.steps = 0;
		_bench.micros = 0;
	}

	// Time the step
	var _start = get_timer();
	for (var _i = 0; _i < _config.count; _i++) {
		resnip_player_step(_bench.players[_i]);
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
		show_debug_message("[BENCH] players=" + string(_config.count) + " loops=" + string(_config.loops) + " step_us=" + string(_bench.micros / _measured) + " player_ns=" + string(_bench.micros * 1000 / _measured / _config.count));
		_bench.players = [];
		_bench.index += 1;
	}
	return false;
}
