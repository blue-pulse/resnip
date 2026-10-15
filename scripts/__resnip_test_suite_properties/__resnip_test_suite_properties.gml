function __resnip_test_suite_properties() {
	var _suite = __resnip_test_suite("properties");

	// Every case comes from a seed, so a failure names the seed that reproduces it
	__resnip_test_case(_suite, "the frame stays inside the snip", function(_t) {
		for (var _seed = 1; _seed <= __RESNIP_TEST_CASES; _seed++) {
			var _random = __resnip_test_random(_seed);
			var _snip = __resnip_test_random_snip(_random);
			var _player = __resnip_test_player(_snip, { backward: __resnip_test_random_next(_random, 2) == 1 });
			var _bad = -1;
			for (var _step = 0; _step < __RESNIP_TEST_STEPS && _bad < 0; _step++) {
				resnip_player_step(_player, __resnip_test_random_step(_random));
				if (_player.frame < 0 || _player.frame >= _snip.count) {
					_bad = _step;
				}
			}
			__resnip_test_record(_t, _bad < 0, "seed " + string(_seed) + ": frame " + string(_player.frame) + " of " + string(_snip.count) + " at step " + string(_bad));
		}
	});

	__resnip_test_case(_suite, "two steps give the same result as one step of their sum", function(_t) {
		for (var _seed = 1; _seed <= __RESNIP_TEST_CASES; _seed++) {
			var _random = __resnip_test_random(_seed);
			var _snip = __resnip_test_random_snip(_random);
			var _split = __resnip_test_player(_snip);
			var _whole = __resnip_test_player(_snip);
			var _bad = -1;
			for (var _step = 0; _step < __RESNIP_TEST_STEPS && _bad < 0; _step++) {
				var _first = __resnip_test_random_step(_random);
				var _second = __resnip_test_random_step(_random);
				resnip_player_step(_split, _first);
				resnip_player_step(_split, _second);
				resnip_player_step(_whole, _first + _second);
				if (_split.frame != _whole.frame || _split.direction != _whole.direction || _split.stopped != _whole.stopped) {
					_bad = _step;
				}
			}
			__resnip_test_record(_t, _bad < 0, "seed " + string(_seed) + ": split frame " + string(_split.frame) + ", whole frame " + string(_whole.frame) + " at step " + string(_bad));
		}
	});

	__resnip_test_case(_suite, "a backward run mirrors the forward run", function(_t) {
		for (var _seed = 1; _seed <= __RESNIP_TEST_CASES; _seed++) {
			var _snip = __resnip_test_random_plain(__resnip_test_random(_seed));
			var _forward = __resnip_test_trace(__resnip_test_player(_snip), __RESNIP_TEST_STEPS);
			var _backward = __resnip_test_trace(__resnip_test_player(_snip, { backward: true }), __RESNIP_TEST_STEPS);
			var _mirrored = [];
			for (var _i = 0; _i < array_length(_forward); _i++) {
				array_push(_mirrored, _snip.count - 1 - _forward[_i]);
			}
			__resnip_test_equal(_t, _backward, _mirrored, "seed " + string(_seed));
		}
	});

	__resnip_test_case(_suite, "a player speed of two runs a step as two steps", function(_t) {
		for (var _seed = 1; _seed <= __RESNIP_TEST_CASES; _seed++) {
			var _snip = __resnip_test_random_plain(__resnip_test_random(_seed));
			var _fast = __resnip_test_player(_snip);
			resnip_player_set_speed(_fast, 2);
			var _slow = __resnip_test_player(_snip);
			__resnip_test_trace(_fast, 10);
			__resnip_test_trace(_slow, 20);
			__resnip_test_equal(_t, [_fast.frame, _fast.direction], [_slow.frame, _slow.direction], "seed " + string(_seed));
		}
	});

	__resnip_test_case(_suite, "a clone plays like its source", function(_t) {
		for (var _seed = 1; _seed <= __RESNIP_TEST_CASES; _seed++) {
			var _snip = __resnip_test_random_snip(__resnip_test_random(_seed));
			var _clone = resnip_snip_clone(_snip);
			var _a = __resnip_test_trace(__resnip_test_player(_snip), __RESNIP_TEST_STEPS);
			var _b = __resnip_test_trace(__resnip_test_player(_clone), __RESNIP_TEST_STEPS);
			__resnip_test_equal(_t, _b, _a, "seed " + string(_seed));
		}
	});

	__resnip_test_case(_suite, "players on one snip do not affect each other", function(_t) {
		for (var _seed = 1; _seed <= __RESNIP_TEST_CASES; _seed++) {
			var _snip = __resnip_test_random_snip(__resnip_test_random(_seed));
			var _busy = __resnip_test_player(_snip);
			var _idle = __resnip_test_player(_snip);
			__resnip_test_trace(_busy, __RESNIP_TEST_STEPS);
			var _alone = __resnip_test_trace(__resnip_test_player(_snip), __RESNIP_TEST_STEPS);
			__resnip_test_equal(_t, __resnip_test_trace(_idle, __RESNIP_TEST_STEPS), _alone, "seed " + string(_seed));
		}
	});

	__resnip_test_case(_suite, "playing never changes the snip", function(_t) {
		for (var _seed = 1; _seed <= __RESNIP_TEST_CASES; _seed++) {
			var _random = __resnip_test_random(_seed);
			var _snip = __resnip_test_random_snip(_random);
			var _before = variable_clone(_snip);
			var _player = __resnip_test_player(_snip);
			if (array_length(_snip.loops) > 0) {
				resnip_player_set_loop_repeats(_player, _snip.loops[0], 1);
			}
			__resnip_test_trace(_player, __RESNIP_TEST_STEPS);
			__resnip_test_equal(_t, _snip, _before, "seed " + string(_seed));
		}
	});

	__resnip_test_case(_suite, "a loop adds its length once for every repeat", function(_t) {
		for (var _seed = 1; _seed <= __RESNIP_TEST_CASES; _seed++) {
			var _random = __resnip_test_random(_seed);
			var _count = 2 + __resnip_test_random_next(_random, 6);
			var _first = __resnip_test_random_next(_random, _count);
			var _last = _first + __resnip_test_random_next(_random, _count - _first);
			var _repeats = __resnip_test_random_next(_random, 4);
			var _snip = __resnip_test_make(0, _count - 1, { end_mode: RESNIP_END.HOLD, loops: [{ first: _first, last: _last, repeats: _repeats }] });
			var _player = __resnip_test_player(_snip);
			var _expected = _count + (_last - _first + 1) * _repeats;
			var _steps = 0;
			while (!_player.stopped && _steps < 100) {
				resnip_player_step(_player);
				_steps++;
			}
			__resnip_test_equal(_t, _steps, _expected, "seed " + string(_seed) + " frames " + string(_first) + " to " + string(_last) + " repeats " + string(_repeats) + " of " + string(_count));
		}
	});
}
