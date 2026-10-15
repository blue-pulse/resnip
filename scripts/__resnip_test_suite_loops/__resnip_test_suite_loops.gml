function __resnip_test_suite_loops() {
	var _suite = __resnip_test_suite("loops");

	// Repeat counts
	__resnip_test_case(_suite, "a loop plays once and then its repeats", function(_t) {
		var _snip = __resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 2, repeats: 2 }] });
		var _player = __resnip_test_player(_snip);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 9), [1, 2, 1, 2, 1, 2, 3, 4, 4]);
	});

	__resnip_test_case(_suite, "a loop with zero repeats plays once", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 2, repeats: 0 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 5), [1, 2, 3, 4, 4]);
	});

	__resnip_test_case(_suite, "a loop below zero is skipped", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 2, repeats: -1 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3), [3, 4, 4]);
	});

	// Player overrides
	__resnip_test_case(_suite, "the repeats of a player override the loop", function(_t) {
		var _snip = __resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 2, repeats: 0 }] });
		var _player = resnip_player_create();
		resnip_player_set_loop_repeats(_player, _snip.loops[0], 1);
		resnip_player_play(_player, _snip);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 7), [1, 2, 1, 2, 3, 4, 4]);
	});

	__resnip_test_case(_suite, "an override below zero skips the loop", function(_t) {
		var _snip = __resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 2, repeats: 5 }] });
		var _player = resnip_player_create();
		resnip_player_set_loop_repeats(_player, _snip.loops[0], -1);
		resnip_player_play(_player, _snip);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3), [3, 4, 4]);
	});

	__resnip_test_case(_suite, "clearing the override restores the loop", function(_t) {
		var _snip = __resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 2, repeats: 5 }] });
		var _player = resnip_player_create();
		resnip_player_set_loop_repeats(_player, _snip.loops[0], -1);
		resnip_player_play(_player, _snip);
		__resnip_test_trace(_player, 3);
		resnip_player_set_loop_repeats(_player, _snip.loops[0], undefined);
		resnip_player_play(_player, _snip);
		var _trace = __resnip_test_trace(_player, 14);
		__resnip_test_equal(_t, [_trace[12], _trace[13]], [3, 4]);
	});

	// Change inside a loop
	__resnip_test_case(_suite, "repeats lowered while inside the loop take effect", function(_t) {
		var _snip = __resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 2, repeats: 5 }] });
		var _player = __resnip_test_player(_snip);
		__resnip_test_trace(_player, 1);
		resnip_player_set_loop_repeats(_player, _snip.loops[0], 0);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 4), [2, 1, 2, 3]);
	});

	// Backward
	__resnip_test_case(_suite, "a loop plays backward", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 2, repeats: 1 }] }), { backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 7), [3, 2, 1, 2, 1, 0, 0]);
	});

	__resnip_test_case(_suite, "a skipped loop is skipped backward too", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 2, repeats: -1 }] }), { backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3), [3, 0, 0]);
	});

	// Reset
	__resnip_test_case(_suite, "loops reset when the snip repeats", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ loops: [{ first: 1, last: 2, repeats: 1 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 10), [1, 2, 1, 2, 3, 4, 0, 1, 2, 1]);
	});

	__resnip_test_case(_suite, "loops reset when pingpong turns", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG, loops: [{ first: 1, last: 2, repeats: 1 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 13), [1, 2, 1, 2, 3, 4, 3, 2, 1, 2, 1, 0, 1]);
	});

	// Several loops
	__resnip_test_case(_suite, "a loop that never repeats does not hide the next", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 3, repeats: 0 }, { first: 1, last: 2, repeats: 1 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 7), [1, 2, 1, 2, 3, 4, 4]);
	});

	__resnip_test_case(_suite, "overlapping loops use the first one in order", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 0, last: 4, repeats: 1 }, { first: 1, last: 2, repeats: 1 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 12), [1, 2, 3, 4, 0, 1, 2, 1, 2, 3, 4, 4]);
	});

	// Where the snip starts
	__resnip_test_case(_suite, "a skipped loop lands after its last frame on a snip that starts at image 0", function(_t) {
		var _player = __resnip_test_player(__resnip_test_make(0, 4, { end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 2, repeats: -1 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3), [3, 4, 4]);
	});

	__resnip_test_case(_suite, "a skipped loop lands before its first frame when playing backward from any image", function(_t) {
		var _loops = [{ first: 2, last: 3, repeats: -1 }];
		var _from_zero = __resnip_test_player(__resnip_test_make(0, 4, { end_mode: RESNIP_END.HOLD, loops: _loops }), { backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_from_zero, 4), [1, 0, 0, 0], "from image 0");
		var _from_two = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: _loops }), { backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_from_two, 4), [1, 0, 0, 0], "from image 2");
	});

	// Position of the loop
	__resnip_test_case(_suite, "loops in sequence each play in turn", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 0, last: 1, repeats: 1 }, { first: 3, last: 4, repeats: 1 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 12), [1, 0, 1, 2, 3, 4, 3, 4, 4, 4, 4, 4]);
	});

	__resnip_test_case(_suite, "a loop over the whole snip plays the snip again", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 0, last: 4, repeats: 1 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 10), [1, 2, 3, 4, 0, 1, 2, 3, 4, 4]);
	});

	__resnip_test_case(_suite, "a loop on the last frames plays before the snip ends", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 3, last: 4, repeats: 1 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 8), [1, 2, 3, 4, 3, 4, 4, 4]);
	});

	__resnip_test_case(_suite, "a loop on the last frames plays before the snip repeats", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ loops: [{ first: 3, last: 4, repeats: 1 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 9), [1, 2, 3, 4, 3, 4, 0, 1, 2]);
	});

	// Speed inside a loop
	__resnip_test_case(_suite, "a frame speed inside a loop applies on every pass", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, frame_speeds: [{ frame: 1, speed: 0.5 }], loops: [{ first: 1, last: 2, repeats: 1 }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 10), [1, 1, 2, 1, 1, 2, 3, 4, 4, 4]);
	});

	// Change while playing
	__resnip_test_case(_suite, "repeats raised inside the loop add passes", function(_t) {
		var _snip = __resnip_test_snip({ end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 2, repeats: 0 }] });
		var _player = __resnip_test_player(_snip);
		__resnip_test_trace(_player, 1);
		resnip_player_set_loop_repeats(_player, _snip.loops[0], 2);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 7), [2, 1, 2, 1, 2, 3, 4]);
	});
}
