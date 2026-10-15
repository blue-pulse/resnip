function __resnip_test_suite_end() {
	var _suite = __resnip_test_suite("end");

	// Forward
	__resnip_test_case(_suite, "repeat wraps to the first frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip());
		__resnip_test_equal(_t, __resnip_test_trace(_player, 12), [1, 2, 3, 4, 0, 1, 2, 3, 4, 0, 1, 2]);
	});

	__resnip_test_case(_suite, "hold stays on the last frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 8), [1, 2, 3, 4, 4, 4, 4, 4]);
	});

	__resnip_test_case(_suite, "hold stops the player", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD }));
		__resnip_test_trace(_player, 8);
		__resnip_test_true(_t, _player.stopped);
	});

	__resnip_test_case(_suite, "rewind goes back to the first frame and stays", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.REWIND }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 7), [1, 2, 3, 4, 0, 0, 0]);
	});

	__resnip_test_case(_suite, "pingpong turns at both ends", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 12), [1, 2, 3, 4, 3, 2, 1, 0, 1, 2, 3, 4]);
	});

	// Backward
	__resnip_test_case(_suite, "repeat backward wraps to the last frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip(), { backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 6), [3, 2, 1, 0, 4, 3]);
	});

	__resnip_test_case(_suite, "hold backward stays on the first frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD }), { backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 5), [3, 2, 1, 0, 0]);
	});

	// Completion counts
	__resnip_test_case(_suite, "pingpong with edge completes at each edge", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG, complete_on: RESNIP_COMPLETE.EDGE, on_complete: __resnip_test_count, on_complete_argument: _counter }));
		__resnip_test_trace(_player, 12);
		__resnip_test_equal(_t, _counter.hits, 2);
	});

	__resnip_test_case(_suite, "pingpong with head completes when it returns to the first frame", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG, complete_on: RESNIP_COMPLETE.HEAD, on_complete: __resnip_test_count, on_complete_argument: _counter }));
		__resnip_test_trace(_player, 12);
		__resnip_test_equal(_t, _counter.hits, 1);
	});

	__resnip_test_case(_suite, "pingpong with tail completes each time it reaches the last frame", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG, complete_on: RESNIP_COMPLETE.TAIL, on_complete: __resnip_test_count, on_complete_argument: _counter }));
		__resnip_test_trace(_player, 5);
		__resnip_test_equal(_t, _counter.hits, 1, "at the first tail");
		__resnip_test_trace(_player, 7);
		__resnip_test_equal(_t, _counter.hits, 1, "before the second tail");
		__resnip_test_trace(_player, 1);
		__resnip_test_equal(_t, _counter.hits, 2, "at the second tail");
	});

	__resnip_test_case(_suite, "pingpong with head backward turns the same way", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG, complete_on: RESNIP_COMPLETE.HEAD }), { backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 8), [3, 2, 1, 0, 1, 2, 3, 4]);
	});

	__resnip_test_case(_suite, "pingpong with tail backward completes only on the return", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG, complete_on: RESNIP_COMPLETE.TAIL, on_complete: __resnip_test_count, on_complete_argument: _counter }), { backward: true });
		__resnip_test_trace(_player, 8);
		__resnip_test_equal(_t, _counter.hits, 0, "before the return");
		__resnip_test_trace(_player, 1);
		__resnip_test_equal(_t, _counter.hits, 1, "on the return");
	});

	__resnip_test_case(_suite, "pingpong with head backward completes when it first reaches the first frame", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG, complete_on: RESNIP_COMPLETE.HEAD, on_complete: __resnip_test_count, on_complete_argument: _counter }), { backward: true });
		__resnip_test_trace(_player, 4);
		__resnip_test_equal(_t, _counter.hits, 0, "before the first frame");
		__resnip_test_trace(_player, 1);
		__resnip_test_equal(_t, _counter.hits, 1, "at the first frame");
		__resnip_test_trace(_player, 7);
		__resnip_test_equal(_t, _counter.hits, 1, "on the way back");
	});

	__resnip_test_case(_suite, "repeat completes at each wrap", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_snip({ on_complete: __resnip_test_count, on_complete_argument: _counter }));
		__resnip_test_trace(_player, 12);
		__resnip_test_equal(_t, _counter.hits, 2);
	});

	__resnip_test_case(_suite, "hold completes once", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, on_complete: __resnip_test_count, on_complete_argument: _counter }));
		__resnip_test_trace(_player, 8);
		__resnip_test_equal(_t, _counter.hits, 1);
	});

	// More directions and sizes
	__resnip_test_case(_suite, "rewind backward goes back to the first frame and stays", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.REWIND }), { backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 7), [3, 2, 1, 0, 0, 0, 0]);
	});

	__resnip_test_case(_suite, "pingpong backward turns at both ends", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG }), { backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 16), [3, 2, 1, 0, 1, 2, 3, 4, 3, 2, 1, 0, 1, 2, 3, 4]);
	});

	__resnip_test_case(_suite, "repeat backward completes at each wrap", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_snip({ on_complete: __resnip_test_count, on_complete_argument: _counter }), { backward: true });
		__resnip_test_trace(_player, 12);
		__resnip_test_equal(_t, _counter.hits, 2);
	});

	__resnip_test_case(_suite, "hold backward completes once", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, on_complete: __resnip_test_count, on_complete_argument: _counter }), { backward: true });
		__resnip_test_trace(_player, 8);
		__resnip_test_equal(_t, _counter.hits, 1);
	});

	__resnip_test_case(_suite, "pingpong with edge backward completes at each edge", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG, on_complete: __resnip_test_count, on_complete_argument: _counter }), { backward: true });
		__resnip_test_trace(_player, 12);
		__resnip_test_equal(_t, _counter.hits, 2);
	});

	__resnip_test_case(_suite, "a snip of one frame repeats in place and completes every step", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_make(2, 2, { on_complete: __resnip_test_count, on_complete_argument: _counter }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 4), [0, 0, 0, 0]);
		__resnip_test_equal(_t, _counter.hits, 4);
	});

	__resnip_test_case(_suite, "a snip of one frame holds in place and completes once", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_make(2, 2, { end_mode: RESNIP_END.HOLD, on_complete: __resnip_test_count, on_complete_argument: _counter }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 4), [0, 0, 0, 0]);
		__resnip_test_equal(_t, _counter.hits, 1);
	});

	__resnip_test_case(_suite, "a step larger than the snip holds on the last frame", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD }));
		resnip_player_step(_player, 20);
		__resnip_test_equal(_t, _player.frame, 4);
		__resnip_test_true(_t, _player.stopped);
	});

	// Fast forward
	__resnip_test_case(_suite, "fastforward jumps to the last frame and stays", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.FASTFORWARD }));
		__resnip_test_equal(_t, __resnip_test_trace(_player, 6), [1, 2, 3, 4, 4, 4]);
		__resnip_test_true(_t, _player.stopped);
	});

	__resnip_test_case(_suite, "fastforward backward jumps to the last frame and stays", function(_t) {
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.FASTFORWARD }), { backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 7), [3, 2, 1, 0, 4, 4, 4]);
		__resnip_test_true(_t, _player.stopped);
	});

	__resnip_test_case(_suite, "fastforward completes once", function(_t) {
		var _counter = { hits: 0 };
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.FASTFORWARD, on_complete: __resnip_test_count, on_complete_argument: _counter }), { backward: true });
		__resnip_test_trace(_player, 10);
		__resnip_test_equal(_t, _counter.hits, 1);
	});

	__resnip_test_case(_suite, "an unknown completion mode throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ complete_on: 9 });
		}, "received complete_on 9");
	});
}
