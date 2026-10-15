function __resnip_test_suite_speed() {
	var _suite = __resnip_test_suite("speed");

	// Speeds
	__resnip_test_case(_suite, "a frame speed slows only its frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ frame_speeds: [{ frame: 1, speed: 0.5 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 6), [1, 1, 2, 3, 4, 0]);
	});

	__resnip_test_case(_suite, "the snip speed multiplies every frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ speed: 2 }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 6), [2, 4, 1, 3, 0, 2]);
	});

	__resnip_test_case(_suite, "the player speed multiplies every frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip());
		resnip_player_set_speed(_player, 2);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 6), [2, 4, 1, 3, 0, 2]);
	});

	__resnip_test_case(_suite, "scripts run for every frame entered at high speed", function(_t) {
		var _log = [];
		var _scripts = [];
		for (var _i = 0; _i < 5; _i++) {
			array_push(_scripts, { frame: _i, callback: __resnip_test_log_frame, argument: _log });
		}
		var _player = __resnip_test_player(__resnip_test_snip({ speed: 2, frame_scripts: _scripts }));
		__resnip_test_trace(_player, 3);
		__resnip_test_equal(_t, _log, [0, 1, 2, 3, 4, 0, 1]);
	});

	__resnip_test_case(_suite, "a fractional speed holds a frame for several steps", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ speed: 0.25 }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 8), [0, 0, 0, 1, 1, 1, 1, 2]);
	});

	__resnip_test_case(_suite, "a sprite in frames per second follows the game speed", function(_t) {
		resnip_set_game_speed(60);
		var _player = __resnip_test_player(__resnip_test_snip());
		__resnip_test_equal(_t, __resnip_test_trace(_player, 8), [0, 0, 0, 1, 1, 1, 1, 2]);
	});

	// Drift
	__resnip_test_case(_suite, "no drift before the tenth step of a frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ speed: 0.1, end_mode: RESNIP_END.HOLD }));
		__resnip_test_trace(_player, 39);
		__resnip_test_equal(_t, _player.frame, 3);
	});

	__resnip_test_case(_suite, "no drift on the tenth step of a frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ speed: 0.1, end_mode: RESNIP_END.HOLD }));
		__resnip_test_trace(_player, 40);
		__resnip_test_equal(_t, _player.frame, 4);
	});

	// Several steps at once
	__resnip_test_case(_suite, "several steps at once move several frames", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip());
		resnip_player_step(_player, 2.5);
		__resnip_test_equal(_t, _player.frame, 2, "after 2.5 steps");
		resnip_player_step(_player, 0.5);
		__resnip_test_equal(_t, _player.frame, 3, "after a fraction that completes a frame");
		resnip_player_step(_player, 7);
		__resnip_test_equal(_t, _player.frame, 0, "after more steps than frames");
	});

	__resnip_test_case(_suite, "a speed of two cycles per step stays on the same frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ speed: 10 }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3), [0, 0, 0]);
	});

	// Clock and pause
	__resnip_test_case(_suite, "the clock scale slows the player", function(_t) {
		var _clock = resnip_clock_create();
		var _player = resnip_player_create(_clock);
		resnip_player_play(_player, __resnip_test_snip());
		resnip_clock_set_scale(_clock, 0.5);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 6), [0, 1, 1, 2, 2, 3]);
	});

	__resnip_test_case(_suite, "a paused clock holds the player", function(_t) {
		var _clock = resnip_clock_create();
		var _player = resnip_player_create(_clock);
		resnip_player_play(_player, __resnip_test_snip());
		resnip_clock_set_scale(_clock, 0.5);
		__resnip_test_trace(_player, 6);
		_clock.paused = true;
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3), [3, 3, 3]);
	});

	__resnip_test_case(_suite, "a paused player holds even when the clock runs", function(_t) {
		var _clock = resnip_clock_create();
		var _player = resnip_player_create(_clock);
		resnip_player_play(_player, __resnip_test_snip());
		resnip_clock_set_scale(_clock, 0.5);
		__resnip_test_trace(_player, 6);
		_player.paused = true;
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3), [3, 3, 3]);
	});

	// Default clock
	__resnip_test_case(_suite, "the default clock pauses its players", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip());
		resnip_clock_default().paused = true;
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3), [0, 0, 0]);
	});

	__resnip_test_case(_suite, "the default clock resumes its players", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip());
		resnip_clock_default().paused = true;
		__resnip_test_trace(_player, 3);
		resnip_clock_default().paused = false;
		__resnip_test_equal(_t, __resnip_test_trace(_player, 2), [1, 2]);
	});
}
