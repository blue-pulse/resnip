function __resnip_test_suite_known() {
	var _suite = __resnip_test_suite("known");

	// Each test says what should happen and is reported apart until the library does it
	__resnip_test_known_failure(_suite, "a loop below zero over the whole snip does not stop a repeating snip", "the skip and the wrap call each other without end, so the test is not run");

	__resnip_test_known_failure(_suite, "a queued snip can play backward", "the queue keeps the snip and the transition flag but not the direction", function(_t) {
		var _other = __resnip_test_make(10, 12, { end_mode: RESNIP_END.HOLD });
		var _player = __resnip_test_player(__resnip_test_snip());
		resnip_player_play(_player, _other, { queue: true, backward: true });
		__resnip_test_trace(_player, 5);
		__resnip_test_equal(_t, _player.frame, 2);
	});

	__resnip_test_known_failure(_suite, "a stopped player can play the target of a transition it left", "stop keeps the target of the transition, so restart false thinks it still plays", function(_t) {
		var _from = __resnip_test_snip();
		var _to = __resnip_test_make(10, 11, { end_mode: RESNIP_END.HOLD });
		resnip_transition_add(_from, _to, __resnip_test_make(14, 15, { end_mode: RESNIP_END.HOLD }));
		var _player = __resnip_test_player(_from);
		resnip_player_play(_player, _to, { transition: true });
		resnip_player_stop(_player);
		__resnip_test_true(_t, resnip_player_play(_player, _to, { restart: false }));
	});

	__resnip_test_known_failure(_suite, "a callback that pauses the player ends the step in progress", "the step loop checks stopped but not paused", function(_t) {
		var _pause = function(_argument, _player) {
			_player.paused = true;
		};
		var _player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, frame_scripts: [{ frame: 1, callback: _pause }] }));
		resnip_player_step(_player, 3);
		__resnip_test_equal(_t, _player.frame, 1);
	});
}
