function __resnip_test_suite_flow() {
	var _suite = __resnip_test_suite("flow");

	// Next snip
	__resnip_test_case(_suite, "next plays after completion", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_snip_set_next(_a, _b);
		var _player = __resnip_test_player(_a);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 4, true), ["0.1", "0.2", "3.0", "3.1"]);
	});

	__resnip_test_case(_suite, "completion runs before the next snip starts", function(_t) {
		var _log = [];
		var _a = __resnip_test_make(0, 2, { on_complete: __resnip_test_log_first_image, on_complete_argument: _log });
		var _b = __resnip_test_make(3, 5, { frame_scripts: [{ frame: 0, callback: __resnip_test_log_first_image, argument: _log }] });
		resnip_snip_set_next(_a, _b);
		var _player = __resnip_test_player(_a);
		__resnip_test_trace(_player, 3);
		__resnip_test_equal(_t, _log, [0, 3]);
	});

	// Queue
	__resnip_test_case(_suite, "queue waits for completion", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		var _player = __resnip_test_player(_a);
		resnip_player_play(_player, _b, { queue: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3, true), ["0.1", "0.2", "3.0"]);
	});

	__resnip_test_case(_suite, "cancel drops the queue", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		var _player = __resnip_test_player(_a);
		resnip_player_play(_player, _b, { queue: true });
		resnip_player_cancel_next(_player);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3, true), ["0.1", "0.2", "0.0"]);
	});

	__resnip_test_case(_suite, "a later queue replaces the earlier", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		var _c = __resnip_test_make(9, 11);
		var _player = __resnip_test_player(_a);
		resnip_player_play(_player, _b, { queue: true });
		resnip_player_play(_player, _c, { queue: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3, true), ["0.1", "0.2", "9.0"]);
	});

	__resnip_test_case(_suite, "queue on a stopped player plays now", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		var _player = __resnip_test_player(_a);
		resnip_player_stop(_player);
		resnip_player_play(_player, _b, { queue: true });
		__resnip_test_true(_t, _player.snip == _b, "plays the queued snip");
		__resnip_test_false(_t, _player.stopped, "is no longer stopped");
	});

	// Restart option
	__resnip_test_case(_suite, "restart false skips a snip that plays", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _player = __resnip_test_player(_a);
		__resnip_test_trace(_player, 1);
		__resnip_test_false(_t, resnip_player_play(_player, _a, { restart: false }), "result");
		__resnip_test_equal(_t, _player.frame, 1, "frame");
	});

	__resnip_test_case(_suite, "restart true starts again", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _player = __resnip_test_player(_a);
		__resnip_test_trace(_player, 1);
		var _started = resnip_player_play(_player, _a);
		__resnip_test_equal(_t, [_started, _player.frame], [true, 0]);
	});

	__resnip_test_case(_suite, "frame script runs when the same snip restarts", function(_t) {
		var _log = [];
		var _a = __resnip_test_make(0, 2, { frame_scripts: [{ frame: 0, callback: __resnip_test_log_first_image, argument: _log }] });
		var _player = __resnip_test_player(_a);
		resnip_player_play(_player, _a);
		__resnip_test_equal(_t, array_length(_log), 2);
	});

	// Transition
	__resnip_test_case(_suite, "transition plays at once", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		var _player = __resnip_test_player(_a);
		resnip_player_play(_player, _b, { transition: true });
		__resnip_test_equal(_t, [_player.snip.first_image, _player.frame], [6, 0]);
	});

	__resnip_test_case(_suite, "transition leads to the target", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		var _player = __resnip_test_player(_a);
		resnip_player_play(_player, _b, { transition: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3, true), ["6.1", "3.0", "3.1"]);
	});

	__resnip_test_case(_suite, "no transition without the option", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		var _player = __resnip_test_player(_a);
		resnip_player_play(_player, _b);
		__resnip_test_true(_t, _player.snip == _b);
	});

	__resnip_test_case(_suite, "no transition registered the other way", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		var _player = __resnip_test_player(_b);
		resnip_player_play(_player, _a, { transition: true });
		__resnip_test_true(_t, _player.snip == _a);
	});

	// Backward transition
	__resnip_test_case(_suite, "backward transition starts on the last frame", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 8), true);
		var _player = __resnip_test_player(_a);
		resnip_player_play(_player, _b, { transition: true });
		__resnip_test_equal(_t, [_player.snip.first_image, _player.frame], [6, 2]);
	});

	__resnip_test_case(_suite, "backward transition leads to the target", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 8), true);
		var _player = __resnip_test_player(_a);
		resnip_player_play(_player, _b, { transition: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3, true), ["6.1", "6.0", "3.0"]);
	});

	// Queue with transition
	__resnip_test_case(_suite, "queue with transition", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		var _player = __resnip_test_player(_a);
		resnip_player_play(_player, _b, { queue: true, transition: true });
		__resnip_test_equal(_t, __resnip_test_trace(_player, 5, true), ["0.1", "0.2", "6.0", "6.1", "3.0"]);
	});

	__resnip_test_case(_suite, "next uses a transition", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		resnip_snip_set_next(_a, _b);
		var _player = __resnip_test_player(_a);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3, true), ["0.1", "0.2", "6.0"]);
	});

	// Remove transition
	__resnip_test_case(_suite, "find returns nothing after remove", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		resnip_transition_remove(_a, _b);
		__resnip_test_equal(_t, resnip_transition_find(_a, _b), undefined);
	});

	__resnip_test_case(_suite, "no transition plays after remove", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		resnip_transition_remove(_a, _b);
		var _player = __resnip_test_player(_a);
		resnip_player_play(_player, _b, { transition: true });
		__resnip_test_true(_t, _player.snip == _b);
	});

	// Completion script
	__resnip_test_case(_suite, "a completion script that plays a snip wins over next", function(_t) {
		var _b = __resnip_test_make(3, 5);
		var _c = __resnip_test_make(9, 11);
		var _owner = __resnip_test_make(0, 2, { on_complete: __resnip_test_take_over, on_complete_argument: _c, next: _b });
		var _player = __resnip_test_player(_owner);
		__resnip_test_trace(_player, 3);
		__resnip_test_true(_t, _player.snip == _c);
	});

	// Next that points to itself
	__resnip_test_case(_suite, "next that points to itself restarts", function(_t) {
		var _a = __resnip_test_make(0, 2);
		resnip_snip_set_next(_a, _a);
		var _player = __resnip_test_player(_a);
		__resnip_test_equal(_t, __resnip_test_trace(_player, 3, true), ["0.1", "0.2", "0.0"]);
	});

	// Callback arguments
	__resnip_test_case(_suite, "callbacks receive the argument and the player", function(_t) {
		var _args = [];
		var _watched = __resnip_test_make(0, 2, { frame_scripts: [{ frame: 1, callback: __resnip_test_log_player, argument: _args }] });
		var _player = __resnip_test_player(_watched);
		__resnip_test_trace(_player, 1);
		__resnip_test_true(_t, _args[0] == _player);
	});
}
