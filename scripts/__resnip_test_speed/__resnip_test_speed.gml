function __resnip_test_speed(_context) {
	// Helpers
	var _log_frame = function(_log, _player) {
		array_push(_log, _player.frame);
	};

	// Speeds
	var _player = __resnip_test_player(__resnip_test_snip({ frame_speeds: [{ frame: 1, speed: 0.5 }] }));
	__resnip_test_expect(_context, "frame speed", __resnip_test_trace(_player, 6), [1, 1, 2, 3, 4, 0]);

	_player = __resnip_test_player(__resnip_test_snip({ speed: 2 }));
	__resnip_test_expect(_context, "snip speed", __resnip_test_trace(_player, 6), [2, 4, 1, 3, 0, 2]);

	_player = __resnip_test_player(__resnip_test_snip());
	resnip_player_set_speed(_player, 2);
	__resnip_test_expect(_context, "player speed", __resnip_test_trace(_player, 6), [2, 4, 1, 3, 0, 2]);

	// Scripts at high speed
	var _log = [];
	var _scripts = [];
	for (var _i = 0; _i < 5; _i++) {
		array_push(_scripts, { frame: _i, callback: _log_frame, argument: _log });
	}
	_player = __resnip_test_player(__resnip_test_snip({ speed: 2, frame_scripts: _scripts }));
	__resnip_test_trace(_player, 3);
	__resnip_test_expect(_context, "scripts run for every frame entered at high speed", _log, [0, 1, 2, 3, 4, 0, 1]);

	// Fractional speed
	_player = __resnip_test_player(__resnip_test_snip({ speed: 0.25 }));
	__resnip_test_expect(_context, "fractional speed", __resnip_test_trace(_player, 8), [0, 0, 0, 1, 1, 1, 1, 2]);

	// Sprite speed in frames per second
	resnip_set_game_speed(60);
	_player = __resnip_test_player(__resnip_test_snip());
	__resnip_test_expect(_context, "sprite in frames per second at 60", __resnip_test_trace(_player, 8), [0, 0, 0, 1, 1, 1, 1, 2]);
	resnip_set_game_speed(15);

	// Drift
	_player = __resnip_test_player(__resnip_test_snip({ speed: 0.1, end_mode: RESNIP_END.HOLD }));
	__resnip_test_trace(_player, 39);
	__resnip_test_expect(_context, "no drift before the tenth step of a frame", _player.frame, 3);
	__resnip_test_trace(_player, 1);
	__resnip_test_expect(_context, "no drift on the tenth step of a frame", _player.frame, 4);

	// Several steps at once
	_player = __resnip_test_player(__resnip_test_snip());
	resnip_player_step(_player, 2.5);
	__resnip_test_expect(_context, "several steps at once", _player.frame, 2);
	resnip_player_step(_player, 0.5);
	__resnip_test_expect(_context, "a fraction completes a frame", _player.frame, 3);
	resnip_player_step(_player, 7);
	__resnip_test_expect(_context, "more steps than frames wrap", _player.frame, 0);

	_player = __resnip_test_player(__resnip_test_snip({ speed: 10 }));
	__resnip_test_expect(_context, "a speed of two cycles per step", __resnip_test_trace(_player, 3), [0, 0, 0]);

	// Clock and pause
	var _clock = resnip_clock_create();
	_player = resnip_player_create(_clock);
	resnip_player_play(_player, __resnip_test_snip());
	resnip_clock_set_scale(_clock, 0.5);
	__resnip_test_expect(_context, "clock scale", __resnip_test_trace(_player, 6), [0, 1, 1, 2, 2, 3]);
	_clock.paused = true;
	__resnip_test_expect(_context, "clock pause", __resnip_test_trace(_player, 3), [3, 3, 3]);
	_clock.paused = false;
	_player.paused = true;
	__resnip_test_expect(_context, "player pause", __resnip_test_trace(_player, 3), [3, 3, 3]);

	// Default clock
	_player = __resnip_test_player(__resnip_test_snip());
	resnip_clock_default().paused = true;
	__resnip_test_expect(_context, "default clock pause", __resnip_test_trace(_player, 3), [0, 0, 0]);
	resnip_clock_default().paused = false;
	__resnip_test_expect(_context, "default clock resume", __resnip_test_trace(_player, 2), [1, 2]);
}
