function __resnip_test_suite_state() {
	var _suite = __resnip_test_suite("state");

	// The instance sync test changes the owner, so the next test starts clean
	_suite.after_each = function(_t) {
		with (__resnip_test_state().owner) {
			sprite_index = -1;
			image_index = 0;
			image_speed = 1;
		}
	};

	// Stop and play
	__resnip_test_case(_suite, "stop here keeps the frame and stops the playback", function(_t) {
		var _playback = __resnip_test_playback(__resnip_test_snip());
		__resnip_test_trace(_playback, 2);
		resnip_stop(_playback);
		__resnip_test_equal(_t, [_playback.frame, _playback.stopped], [2, true]);
	});

	__resnip_test_case(_suite, "a stopped playback does not move", function(_t) {
		var _playback = __resnip_test_playback(__resnip_test_snip());
		__resnip_test_trace(_playback, 2);
		resnip_stop(_playback);
		__resnip_test_equal(_t, __resnip_test_trace(_playback, 2), [2, 2]);
	});

	__resnip_test_case(_suite, "play restarts a stopped playback", function(_t) {
		var _playback = __resnip_test_playback(__resnip_test_snip());
		__resnip_test_trace(_playback, 2);
		resnip_stop(_playback);
		resnip_play(_playback, _playback.snip);
		__resnip_test_equal(_t, [_playback.frame, _playback.stopped], [0, false]);
	});

	// Stop positions
	__resnip_test_case(_suite, "stop at the tail moves to the last frame", function(_t) {
		var _playback = __resnip_test_playback(__resnip_test_snip());
		resnip_stop(_playback, RESNIP_STOP.TAIL);
		__resnip_test_equal(_t, _playback.frame, 4);
	});

	__resnip_test_case(_suite, "stop at the head moves to the first frame", function(_t) {
		var _playback = __resnip_test_playback(__resnip_test_snip());
		__resnip_test_trace(_playback, 2);
		resnip_stop(_playback, RESNIP_STOP.HEAD);
		__resnip_test_equal(_t, _playback.frame, 0);
	});

	// Playback with no snip
	__resnip_test_case(_suite, "a playback with no snip ignores step and stop", function(_t) {
		var _empty = resnip_playback_create();
		resnip_step(_empty);
		resnip_stop(_empty);
		__resnip_test_equal(_t, [_empty.snip, _empty.frame], [undefined, 0]);
	});

	// Instance sync
	__resnip_test_case(_suite, "instance sync copies the sprite, the sub-image and stops image_speed", function(_t) {
		var _playback = __resnip_test_playback(__resnip_test_snip());
		__resnip_test_trace(_playback, 3);
		var _owner = __resnip_test_state().owner;
		with (_owner) {
			resnip_instance_sync(_playback);
		}
		__resnip_test_equal(_t, _owner.sprite_index, red_cowboy_full, "sprite");
		__resnip_test_equal(_t, _owner.image_index, 5, "sub-image");
		__resnip_test_equal(_t, _owner.image_speed, 0, "image speed");
	});
}
