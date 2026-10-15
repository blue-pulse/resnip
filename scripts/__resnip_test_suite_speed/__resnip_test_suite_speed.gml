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

	// Time inside a step
	__resnip_test_case(_suite, "a frame speed above one shortens only its own frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, frame_speeds: [{ frame: 1, speed: 4 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 6), [1, 2, 3, 4, 4, 4]);
	});

	__resnip_test_case(_suite, "a zero step changes nothing", function(_t) {
		var _log = [];
		var _player = __resnip_test_player(__resnip_test_snip({ frame_scripts: __resnip_test_tag_scripts(_log, [0, 1]) }));
		resnip_player_step(_player, 0);
		__resnip_test_equal(_t, _player.frame, 0);
		__resnip_test_equal(_t, _log, ["f0"]);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 1), [1]);
	});

	__resnip_test_case(_suite, "the rest of a step passes to the next snip", function(_t) {
		var _next = __resnip_test_make(10, 12, { end_mode: RESNIP_END.HOLD });
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, next: _next }));
		resnip_player_step(_player, 6);
		__resnip_test_equal(_t, string(_player.snip.first_image) + "." + string(_player.frame), "10.1");
	});

	// Sprite speed type
	__resnip_test_case(_suite, "a sprite in frames per game frame ignores the game speed", function(_t) {
		var _whole = __resnip_test_sprite_per_frame(1);
		var _half = __resnip_test_sprite_per_frame(0.5);
		resnip_set_game_speed(60);
		var _options = { first_image: 2, last_image: 6, end_mode: RESNIP_END.HOLD };
		__resnip_test_equal(_t, __resnip_test_trace(__resnip_test_player(resnip_snip_create(_whole, _options)), 4), [1, 2, 3, 4], "one per game frame");
		__resnip_test_equal(_t, __resnip_test_trace(__resnip_test_player(resnip_snip_create(_half, _options)), 6), [0, 1, 1, 2, 2, 3], "half per game frame");
		sprite_delete(_whole);
		sprite_delete(_half);
	});

	__resnip_test_case(_suite, "a game speed set during play changes the pace of a sprite in frames per second", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 2), [1, 2], "at 15");
		resnip_set_game_speed(30);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 4), [2, 3, 3, 4], "at 30");
	});

	// Speed of zero
	__resnip_test_case(_suite, "a snip speed of zero holds the first frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ speed: 0 }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3), [0, 0, 0]);
	});

	__resnip_test_case(_suite, "a frame speed of zero holds that frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, frame_speeds: [{ frame: 2, speed: 0 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 6), [1, 2, 2, 2, 2, 2]);
	});

	// Frame speed of a player
	__resnip_test_case(_suite, "changing the speed of a held frame releases it", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, frame_speeds: [{ frame: 2, speed: 0 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 4), [1, 2, 2, 2], "held");
		resnip_player_set_frame_speed(_player, 2, 1);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3), [3, 4, 4], "released");
	});

	__resnip_test_case(_suite, "a frame speed set on a player leaves the snip and other players alone", function(_t) {
		var _snip = __resnip_test_snip({ end_mode: RESNIP_END.HOLD });
		var _slow = __resnip_test_player(_snip);
		var _normal = __resnip_test_player(_snip);
		resnip_player_set_frame_speed(_slow, 1, 0.5);
		__resnip_test_equal(_t, __resnip_test_trace(_slow, 6), [1, 1, 2, 3, 4, 4], "the player that changed");
		__resnip_test_equal(_t, __resnip_test_trace(_normal, 4), [1, 2, 3, 4], "the other player");
		__resnip_test_equal(_t, _snip.frame_speeds[1], 1, "the snip");
	});

	__resnip_test_case(_suite, "an undefined frame speed gives the speed of the snip back", function(_t) {
		var _snip = __resnip_test_snip({ end_mode: RESNIP_END.HOLD, frame_speeds: [{ frame: 1, speed: 0.5 }] });
		var _player = __resnip_test_player(_snip);
		resnip_player_set_frame_speed(_player, 1, 4);
		resnip_player_set_frame_speed(_player, 1, undefined);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 6), [1, 1, 2, 3, 4, 4]);
	});

	__resnip_test_case(_suite, "restarting the same snip keeps the frame speeds of a player", function(_t) {
		var _snip = __resnip_test_snip({ end_mode: RESNIP_END.HOLD });
		var _player = __resnip_test_player(_snip);
		resnip_player_set_frame_speed(_player, 1, 0);
		resnip_player_play(_player, _snip);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3), [1, 1, 1]);
	});

	__resnip_test_case(_suite, "playing another snip drops the frame speeds of a player", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD }));
		resnip_player_set_frame_speed(_player, 1, 0);
		resnip_player_play(_player, __resnip_test_make(10, 14, { end_mode: RESNIP_END.HOLD }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 4), [1, 2, 3, 4]);
	});

	__resnip_test_case(_suite, "a frame speed of a player works while the player plays backward", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD }), { backward: true });
		resnip_player_set_frame_speed(_player, 3, 0.5);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 6), [3, 3, 2, 1, 0, 0]);
	});
}
