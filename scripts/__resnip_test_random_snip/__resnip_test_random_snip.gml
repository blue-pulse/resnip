function __resnip_test_random_snip(_random) {
	var _count = 1 + __resnip_test_random_next(_random, 6);
	var _first_image = __resnip_test_random_next(_random, 14);
	var _end_mode = __resnip_test_random_next(_random, 4);
	var _repeating = (_end_mode == RESNIP_END.REPEAT || _end_mode == RESNIP_END.PINGPONG);
	var _speeds = [0.5, 1, 2];

	// Loops below zero are left out when the snip repeats, since a skipped snip would never end
	var _loops = [];
	var _lowest = _repeating ? 0 : -1;
	var _loop_count = __resnip_test_random_next(_random, 3);
	for (var _i = 0; _i < _loop_count; _i++) {
		var _first = __resnip_test_random_next(_random, _count);
		var _last = _first + __resnip_test_random_next(_random, _count - _first);
		var _repeats = _lowest + __resnip_test_random_next(_random, 3 - _lowest);
		array_push(_loops, { first: _first, last: _last, repeats: _repeats });
	}

	// Frame speeds
	var _frame_speeds = [];
	for (var _f = 0; _f < _count; _f++) {
		if (__resnip_test_random_next(_random, 3) == 0) {
			array_push(_frame_speeds, { frame: _f, speed: _speeds[__resnip_test_random_next(_random, 3)] });
		}
	}

	return resnip_snip_create(red_cowboy_full, {
		first_image: _first_image,
		last_image: _first_image + _count - 1,
		speed: _speeds[__resnip_test_random_next(_random, 3)],
		end_mode: _end_mode,
		complete_on: __resnip_test_random_next(_random, 2),
		loops: _loops,
		frame_speeds: _frame_speeds,
	});
}
