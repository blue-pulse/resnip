function __resnip_test_suite_flow() {
	var _suite = __resnip_test_suite("flow");

	// Next snip
	__resnip_test_case(_suite, "next plays after completion", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_snip_set_next(_a, _b);
		var _playback = __resnip_test_playback(_a);
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 4, true), ["0.1", "0.2", "3.0", "3.1"]);
	});

	__resnip_test_case(_suite, "completion runs before the next snip starts", function(_t) {
		var _log = [];
		var _a = __resnip_test_make(0, 2, { on_complete: __resnip_test_log_first_image, on_complete_argument: _log });
		var _b = __resnip_test_make(3, 5, { frame_scripts: [{ frame: 0, callback: __resnip_test_log_first_image, argument: _log }] });
		resnip_snip_set_next(_a, _b);
		var _playback = __resnip_test_playback(_a);
		__resnip_test_trace(_playback, 3);
		__resnip_test_equal(_t, _log, [0, 3]);
	});

	// Queue
	__resnip_test_case(_suite, "queue waits for completion", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		var _playback = __resnip_test_playback(_a);
		resnip_play(_playback, _b, { queue: true });
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 3, true), ["0.1", "0.2", "3.0"]);
	});

	__resnip_test_case(_suite, "cancel drops the queue", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		var _playback = __resnip_test_playback(_a);
		resnip_play(_playback, _b, { queue: true });
		resnip_cancel_next(_playback);
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 3, true), ["0.1", "0.2", "0.0"]);
	});

	__resnip_test_case(_suite, "a later queue replaces the earlier", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		var _c = __resnip_test_make(9, 11);
		var _playback = __resnip_test_playback(_a);
		resnip_play(_playback, _b, { queue: true });
		resnip_play(_playback, _c, { queue: true });
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 3, true), ["0.1", "0.2", "9.0"]);
	});

	__resnip_test_case(_suite, "queue on a stopped playback plays now", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		var _playback = __resnip_test_playback(_a);
		resnip_stop(_playback);
		resnip_play(_playback, _b, { queue: true });
		__resnip_test_true(_t, _playback.snip == _b, "plays the queued snip");
		__resnip_test_false(_t, _playback.stopped, "is no longer stopped");
	});

	// Restart option
	__resnip_test_case(_suite, "restart false skips a snip that plays", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _playback = __resnip_test_playback(_a);
		__resnip_test_trace(_playback, 1);
		__resnip_test_false(_t, resnip_play(_playback, _a, { restart: false }), "result");
		__resnip_test_equal(_t, _playback.frame, 1, "frame");
	});

	__resnip_test_case(_suite, "restart true starts again", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _playback = __resnip_test_playback(_a);
		__resnip_test_trace(_playback, 1);
		var _started = resnip_play(_playback, _a);
		__resnip_test_equal(_t, [_started, _playback.frame], [true, 0]);
	});

	__resnip_test_case(_suite, "frame script runs when the same snip restarts", function(_t) {
		var _log = [];
		var _a = __resnip_test_make(0, 2, { frame_scripts: [{ frame: 0, callback: __resnip_test_log_first_image, argument: _log }] });
		var _playback = __resnip_test_playback(_a);
		resnip_play(_playback, _a);
		__resnip_test_equal(_t, array_length(_log), 2);
	});

	// Transition
	__resnip_test_case(_suite, "transition plays at once", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		var _playback = __resnip_test_playback(_a);
		resnip_play(_playback, _b, { transition: true });
		__resnip_test_equal(_t, [_playback.snip.first_image, _playback.frame], [6, 0]);
	});

	__resnip_test_case(_suite, "transition leads to the target", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		var _playback = __resnip_test_playback(_a);
		resnip_play(_playback, _b, { transition: true });
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 3, true), ["6.1", "3.0", "3.1"]);
	});

	__resnip_test_case(_suite, "no transition without the option", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		var _playback = __resnip_test_playback(_a);
		resnip_play(_playback, _b);
		__resnip_test_true(_t, _playback.snip == _b);
	});

	__resnip_test_case(_suite, "no transition registered the other way", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		var _playback = __resnip_test_playback(_b);
		resnip_play(_playback, _a, { transition: true });
		__resnip_test_true(_t, _playback.snip == _a);
	});

	// Backward transition
	__resnip_test_case(_suite, "backward transition starts on the last frame", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 8), true);
		var _playback = __resnip_test_playback(_a);
		resnip_play(_playback, _b, { transition: true });
		__resnip_test_equal(_t, [_playback.snip.first_image, _playback.frame], [6, 2]);
	});

	__resnip_test_case(_suite, "backward transition leads to the target", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 8), true);
		var _playback = __resnip_test_playback(_a);
		resnip_play(_playback, _b, { transition: true });
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 3, true), ["6.1", "6.0", "3.0"]);
	});

	// Queue with transition
	__resnip_test_case(_suite, "queue with transition", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		var _playback = __resnip_test_playback(_a);
		resnip_play(_playback, _b, { queue: true, transition: true });
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 5, true), ["0.1", "0.2", "6.0", "6.1", "3.0"]);
	});

	__resnip_test_case(_suite, "next uses a transition", function(_t) {
		var _a = __resnip_test_make(0, 2);
		var _b = __resnip_test_make(3, 5);
		resnip_transition_add(_a, _b, __resnip_test_make(6, 7));
		resnip_snip_set_next(_a, _b);
		var _playback = __resnip_test_playback(_a);
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 3, true), ["0.1", "0.2", "6.0"]);
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
		var _playback = __resnip_test_playback(_a);
		resnip_play(_playback, _b, { transition: true });
		__resnip_test_true(_t, _playback.snip == _b);
	});

	// Completion script
	__resnip_test_case(_suite, "a completion script that plays a snip wins over next", function(_t) {
		var _b = __resnip_test_make(3, 5);
		var _c = __resnip_test_make(9, 11);
		var _owner = __resnip_test_make(0, 2, { on_complete: __resnip_test_take_over, on_complete_argument: _c, next: _b });
		var _playback = __resnip_test_playback(_owner);
		__resnip_test_trace(_playback, 3);
		__resnip_test_true(_t, _playback.snip == _c);
	});

	// Next that points to itself
	__resnip_test_case(_suite, "next that points to itself restarts", function(_t) {
		var _a = __resnip_test_make(0, 2);
		resnip_snip_set_next(_a, _a);
		var _playback = __resnip_test_playback(_a);
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 3, true), ["0.1", "0.2", "0.0"]);
	});

	// Callback arguments
	__resnip_test_case(_suite, "callbacks receive the argument and the playback", function(_t) {
		var _args = [];
		var _watched = __resnip_test_make(0, 2, { frame_scripts: [{ frame: 1, callback: __resnip_test_log_playback, argument: _args }] });
		var _playback = __resnip_test_playback(_watched);
		__resnip_test_trace(_playback, 1);
		__resnip_test_true(_t, _args[0] == _playback);
	});

	// Transitions
	__resnip_test_case(_suite, "the target of a transition wins over the next of the transition snip", function(_t) {
		var _from = __resnip_test_snip();
		var _to = __resnip_test_make(10, 11, { end_mode: RESNIP_END.HOLD });
		var _other = __resnip_test_make(17, 18, { end_mode: RESNIP_END.HOLD });
		var _use = __resnip_test_make(14, 15, { end_mode: RESNIP_END.HOLD, next: _other });
		resnip_transition_add(_from, _to, _use);
		var _playback = __resnip_test_playback(_from);
		resnip_play(_playback, _to, { transition: true });
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 5, true), ["14.1", "10.0", "10.1", "10.1", "10.1"]);
	});

	__resnip_test_case(_suite, "a transition plays its loops", function(_t) {
		var _from = __resnip_test_snip();
		var _to = __resnip_test_make(10, 11, { end_mode: RESNIP_END.HOLD });
		var _use = __resnip_test_make(14, 16, { end_mode: RESNIP_END.HOLD, loops: [{ first: 1, last: 1, repeats: 1 }] });
		resnip_transition_add(_from, _to, _use);
		var _playback = __resnip_test_playback(_from);
		resnip_play(_playback, _to, { transition: true });
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 5, true), ["14.1", "14.1", "14.2", "10.0", "10.1"]);
	});

	__resnip_test_case(_suite, "a queued snip asked with a transition continues from the target of the running transition", function(_t) {
		var _a = __resnip_test_snip();
		var _b = __resnip_test_make(10, 11, { end_mode: RESNIP_END.HOLD });
		var _c = __resnip_test_make(0, 1, { end_mode: RESNIP_END.HOLD });
		resnip_transition_add(_a, _b, __resnip_test_make(14, 15, { end_mode: RESNIP_END.HOLD }));
		resnip_transition_add(_b, _c, __resnip_test_make(17, 18, { end_mode: RESNIP_END.HOLD }));
		var _playback = __resnip_test_playback(_a);
		resnip_play(_playback, _b, { transition: true });
		resnip_play(_playback, _c, { transition: true, queue: true });
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 6, true), ["14.1", "17.0", "17.1", "0.0", "0.1", "0.1"]);
	});

	__resnip_test_case(_suite, "find returns the registered transition", function(_t) {
		var _from = __resnip_test_snip();
		var _to = __resnip_test_make(10, 11);
		var _added = resnip_transition_add(_from, _to, __resnip_test_make(14, 15));
		__resnip_test_true(_t, resnip_transition_find(_from, _to) == _added);
	});

	// Stop
	__resnip_test_case(_suite, "a stopped playback can play the target of a transition it left", function(_t) {
		var _from = __resnip_test_snip();
		var _to = __resnip_test_make(10, 11, { end_mode: RESNIP_END.HOLD });
		resnip_transition_add(_from, _to, __resnip_test_make(14, 15, { end_mode: RESNIP_END.HOLD }));
		var _playback = __resnip_test_playback(_from);
		resnip_play(_playback, _to, { transition: true });
		resnip_stop(_playback);
		__resnip_test_true(_t, resnip_play(_playback, _to, { restart: false }));
	});

	// Direction of what plays next
	__resnip_test_case(_suite, "a queued snip can play backward", function(_t) {
		var _other = __resnip_test_make(10, 12, { end_mode: RESNIP_END.HOLD });
		var _playback = __resnip_test_playback(__resnip_test_snip());
		resnip_play(_playback, _other, { queue: true, backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 6, true), ["2.1", "2.2", "2.3", "2.4", "10.2", "10.1"]);
	});

	__resnip_test_case(_suite, "a queued snip keeps the transition flag and the direction apart", function(_t) {
		var _from = __resnip_test_snip();
		var _to = __resnip_test_make(10, 12, { end_mode: RESNIP_END.HOLD });
		resnip_transition_add(_from, _to, __resnip_test_make(14, 15, { end_mode: RESNIP_END.HOLD }));
		var _playback = __resnip_test_playback(_from);
		resnip_play(_playback, _to, { queue: true, transition: true, backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 8, true), ["2.1", "2.2", "2.3", "2.4", "14.0", "14.1", "10.2", "10.1"]);
	});

	__resnip_test_case(_suite, "the target of a transition plays backward when asked", function(_t) {
		var _from = __resnip_test_snip();
		var _to = __resnip_test_make(10, 12, { end_mode: RESNIP_END.HOLD });
		resnip_transition_add(_from, _to, __resnip_test_make(14, 15, { end_mode: RESNIP_END.HOLD }));
		var _playback = __resnip_test_playback(_from);
		resnip_play(_playback, _to, { transition: true, backward: true });
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 4, true), ["14.1", "10.2", "10.1", "10.0"]);
	});

	__resnip_test_case(_suite, "the next of a snip can play backward", function(_t) {
		var _snip = __resnip_test_snip({ end_mode: RESNIP_END.HOLD });
		resnip_snip_set_next(_snip, __resnip_test_make(10, 12, { end_mode: RESNIP_END.HOLD }), { backward: true });
		var _playback = __resnip_test_playback(_snip);
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 6, true), ["2.1", "2.2", "2.3", "2.4", "10.2", "10.1"]);
	});

	__resnip_test_case(_suite, "the next of a snip uses a transition unless told not to", function(_t) {
		var _target = __resnip_test_make(10, 12, { end_mode: RESNIP_END.HOLD });
		var _with = __resnip_test_snip({ end_mode: RESNIP_END.HOLD });
		var _without = __resnip_test_snip({ end_mode: RESNIP_END.HOLD });
		resnip_snip_set_next(_with, _target);
		resnip_snip_set_next(_without, _target, { transition: false });
		var _use = __resnip_test_make(14, 15, { end_mode: RESNIP_END.HOLD });
		resnip_transition_add(_with, _target, _use);
		resnip_transition_add(_without, _target, _use);
		__resnip_test_equal(_t, __resnip_test_trace(__resnip_test_playback(_with), 5, true), ["2.1", "2.2", "2.3", "2.4", "14.0"], "default");
		__resnip_test_equal(_t, __resnip_test_trace(__resnip_test_playback(_without), 5, true), ["2.1", "2.2", "2.3", "2.4", "10.0"], "transition false");
	});

	__resnip_test_case(_suite, "a clone keeps how its next plays", function(_t) {
		var _snip = __resnip_test_snip();
		resnip_snip_set_next(_snip, __resnip_test_make(10, 12), { transition: false, backward: true });
		var _clone = resnip_snip_clone(_snip, { speed: 2 });
		__resnip_test_equal(_t, [_clone.next_transition, _clone.next_backward], [false, true]);
	});

	// Start frame
	__resnip_test_case(_suite, "a snip can start on a given frame", function(_t) {
		var _playback = resnip_playback_create();
		resnip_play_from(_playback, __resnip_test_snip(), 2);
		__resnip_test_equal(_t, _playback.frame, 2, "at once");
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 4), [3, 4, 0, 1], "after");
	});

	__resnip_test_case(_suite, "a snip started backward on a given frame plays down from it", function(_t) {
		var _playback = resnip_playback_create();
		resnip_play_from(_playback, __resnip_test_snip(), 2, true);
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 4), [1, 0, 4, 3]);
	});

	__resnip_test_case(_suite, "the script of the start frame runs when the snip starts", function(_t) {
		var _log = [];
		var _scripts = [{ frame: 0, callback: __resnip_test_log_frame, argument: _log }, { frame: 2, callback: __resnip_test_log_frame, argument: _log }];
		resnip_play_from(resnip_playback_create(), __resnip_test_snip({ frame_scripts: _scripts }), 2);
		__resnip_test_equal(_t, _log, [2]);
	});

	__resnip_test_case(_suite, "a start frame inside a loop plays the rest of the loop and then its repeats", function(_t) {
		var _playback = resnip_playback_create();
		resnip_play_from(_playback, __resnip_test_snip({ loops: [{ first: 1, last: 3, repeats: 1 }] }), 2);
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 6), [3, 1, 2, 3, 4, 0]);
	});

	__resnip_test_case(_suite, "a start frame inside a skipped loop starts after the loop", function(_t) {
		var _playback = resnip_playback_create();
		resnip_play_from(_playback, __resnip_test_snip({ loops: [{ first: 1, last: 2, repeats: -1 }] }), 1);
		__resnip_test_equal(_t, _playback.frame, 3);
	});

	__resnip_test_case(_suite, "a start frame starts at the beginning of that frame", function(_t) {
		var _snip = __resnip_test_snip({ speed: 0.25 });
		var _playback = __resnip_test_playback(_snip);
		resnip_step(_playback, 2);
		resnip_play_from(_playback, _snip, 0);
		resnip_step(_playback, 2);
		__resnip_test_equal(_t, _playback.frame, 0);
	});

	__resnip_test_case(_suite, "playing from a frame drops the queued snip", function(_t) {
		var _playback = __resnip_test_playback(__resnip_test_make(10, 11));
		resnip_play(_playback, __resnip_test_make(14, 15), { queue: true });
		resnip_play_from(_playback, __resnip_test_snip(), 2);
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 4, true), ["2.3", "2.4", "2.0", "2.1"]);
	});
}
