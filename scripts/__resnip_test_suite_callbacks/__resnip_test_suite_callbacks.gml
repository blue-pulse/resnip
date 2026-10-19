function __resnip_test_suite_callbacks() {
	var _suite = __resnip_test_suite("callbacks");

	// Arguments
	__resnip_test_case(_suite, "a frame script receives its argument", function(_t) {
		var _log = [];
		var _snip = __resnip_test_snip({ frame_scripts: [{ frame: 1, callback: __resnip_test_log_tag, argument: { log: _log, tag: "one" } }] });
		var _playback = __resnip_test_playback(_snip);
		__resnip_test_trace(_playback, 2);
		__resnip_test_equal(_t, _log, ["one"]);
	});

	__resnip_test_case(_suite, "a frame script receives the playback that entered the frame", function(_t) {
		var _log = [];
		var _snip = __resnip_test_snip({ frame_scripts: [{ frame: 2, callback: __resnip_test_log_playback, argument: _log }] });
		var _playback = __resnip_test_playback(_snip);
		__resnip_test_trace(_playback, 3);
		__resnip_test_true(_t, array_length(_log) == 1 && _log[0] == _playback);
	});

	__resnip_test_case(_suite, "a completion script receives its argument", function(_t) {
		var _log = [];
		var _snip = __resnip_test_snip({ end_mode: RESNIP_END.HOLD, on_complete: __resnip_test_log_tag, on_complete_argument: { log: _log, tag: "done" } });
		var _playback = __resnip_test_playback(_snip);
		__resnip_test_trace(_playback, 5);
		__resnip_test_equal(_t, _log, ["done"]);
	});

	// Order
	__resnip_test_case(_suite, "completion runs before the script of the frame it wraps to", function(_t) {
		var _log = [];
		var _snip = __resnip_test_snip({
			frame_scripts: __resnip_test_tag_scripts(_log, [0]),
			on_complete: __resnip_test_log_tag,
			on_complete_argument: { log: _log, tag: "done" },
		});
		var _playback = __resnip_test_playback(_snip);
		__resnip_test_trace(_playback, 5);
		__resnip_test_equal(_t, _log, ["f0", "done", "f0"]);
	});

	__resnip_test_case(_suite, "the script of the last frame runs when it is entered", function(_t) {
		var _log = [];
		var _snip = __resnip_test_snip({
			end_mode: RESNIP_END.HOLD,
			frame_scripts: __resnip_test_tag_scripts(_log, [4]),
			on_complete: __resnip_test_log_tag,
			on_complete_argument: { log: _log, tag: "done" },
		});
		var _playback = __resnip_test_playback(_snip);
		__resnip_test_trace(_playback, 4);
		__resnip_test_equal(_t, _log, ["f4"], "on the last frame");
		__resnip_test_trace(_playback, 4);
		__resnip_test_equal(_t, _log, ["f4", "done"], "after the end");
	});

	__resnip_test_case(_suite, "the frames a large step crosses run their scripts in order", function(_t) {
		var _log = [];
		var _playback = __resnip_test_playback(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, frame_scripts: __resnip_test_tag_scripts(_log, [1, 2, 3]) }));
		resnip_step(_playback, 3.5);
		__resnip_test_equal(_t, _log, ["f1", "f2", "f3"]);
		__resnip_test_equal(_t, _playback.frame, 3);
	});

	__resnip_test_case(_suite, "scripts run in reverse order while playing backward", function(_t) {
		var _log = [];
		var _playback = __resnip_test_playback(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, frame_scripts: __resnip_test_tag_scripts(_log, [0, 1, 2, 3, 4]) }), { backward: true });
		__resnip_test_trace(_playback, 8);
		__resnip_test_equal(_t, _log, ["f4", "f3", "f2", "f1", "f0"]);
	});

	// Callbacks that change the playback
	__resnip_test_case(_suite, "a callback that stops the playback holds it on that frame", function(_t) {
		var _stop = function(_argument, _playback) {
			resnip_stop(_playback);
		};
		var _playback = __resnip_test_playback(__resnip_test_snip({ frame_scripts: [{ frame: 2, callback: _stop }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 6), [1, 2, 2, 2, 2, 2]);
		__resnip_test_true(_t, _playback.stopped);
	});

	__resnip_test_case(_suite, "a callback that changes the speed applies from the next step", function(_t) {
		var _faster = function(_argument, _playback) {
			resnip_set_speed(_playback, 2);
		};
		var _playback = __resnip_test_playback(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, frame_scripts: [{ frame: 1, callback: _faster }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 4), [1, 3, 4, 4]);
	});

	__resnip_test_case(_suite, "a callback that plays another snip replaces the current one", function(_t) {
		var _other = __resnip_test_make(10, 11, { end_mode: RESNIP_END.HOLD });
		var _switch = function(_target, _playback) {
			resnip_play(_playback, _target);
		};
		var _playback = __resnip_test_playback(__resnip_test_snip({ frame_scripts: [{ frame: 1, callback: _switch, argument: _other }] }));
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 3, true), ["10.0", "10.1", "10.1"]);
	});

	__resnip_test_case(_suite, "the rest of a step runs at the speed of the snip a callback started", function(_t) {
		var _slow = __resnip_test_make(10, 13, { speed: 0.5, end_mode: RESNIP_END.HOLD });
		var _switch = function(_target, _playback) {
			resnip_play(_playback, _target);
		};
		var _playback = __resnip_test_playback(__resnip_test_snip({ frame_scripts: [{ frame: 1, callback: _switch, argument: _slow }] }));
		resnip_step(_playback, 3);
		__resnip_test_equal(_t, [_playback.snip == _slow, _playback.frame], [true, 1]);
	});

	__resnip_test_case(_suite, "a callback that pauses the playback ends the step in progress", function(_t) {
		var _pause = function(_argument, _playback) {
			_playback.paused = true;
		};
		var _playback = __resnip_test_playback(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, frame_scripts: [{ frame: 1, callback: _pause }] }));
		resnip_step(_playback, 3);
		__resnip_test_equal(_t, _playback.frame, 1);
	});

	__resnip_test_case(_suite, "a callback that pauses the clock ends the step in progress", function(_t) {
		var _pause = function(_argument, _playback) {
			_playback.clock.paused = true;
		};
		var _playback = __resnip_test_playback(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, frame_scripts: [{ frame: 1, callback: _pause }] }));
		resnip_step(_playback, 3);
		__resnip_test_equal(_t, _playback.frame, 1);
	});
}
