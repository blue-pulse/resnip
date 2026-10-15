function __resnip_test_suite_input() {
	var _suite = __resnip_test_suite("input");

	// Snip options
	__resnip_test_case(_suite, "the last image of the sprite is valid", function(_t) {
		var _snip = resnip_snip_create(red_cowboy_full, { last_image: 19 });
		__resnip_test_equal(_t, _snip.last_image, 19);
	});

	__resnip_test_case(_suite, "a last image past the sprite throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_create(red_cowboy_full, { last_image: 20 });
		});
	});

	__resnip_test_case(_suite, "a first image after the last throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_create(red_cowboy_full, { first_image: 5, last_image: 4 });
		});
	});

	__resnip_test_case(_suite, "a negative first image throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_create(red_cowboy_full, { first_image: -1 });
		});
	});

	__resnip_test_case(_suite, "a speed of zero throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_create(red_cowboy_full, { speed: 0 });
		});
	});

	__resnip_test_case(_suite, "a negative speed throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_create(red_cowboy_full, { speed: -1 });
		});
	});

	// Frame data
	__resnip_test_case(_suite, "a frame speed outside the snip throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ frame_speeds: [{ frame: 5, speed: 1 }] });
		});
	});

	__resnip_test_case(_suite, "a negative frame speed throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ frame_speeds: [{ frame: 1, speed: -1 }] });
		});
	});

	__resnip_test_case(_suite, "a loop that goes backward throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ loops: [{ first: 3, last: 1, repeats: 1 }] });
		});
	});

	__resnip_test_case(_suite, "a loop outside the snip throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ loops: [{ first: 0, last: 5, repeats: 1 }] });
		});
	});

	__resnip_test_case(_suite, "fractional repeats throw", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ loops: [{ first: 0, last: 1, repeats: 0.5 }] });
		});
	});

	__resnip_test_case(_suite, "a script that cannot be called throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ frame_scripts: [{ frame: 0, callback: "text" }] });
		});
	});

	__resnip_test_case(_suite, "two scripts on a frame throw", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ frame_scripts: [{ frame: 0, callback: __resnip_test_count }, { frame: 0, callback: __resnip_test_count }] });
		});
	});

	__resnip_test_case(_suite, "an unknown end mode throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ end_mode: 9 });
		});
	});

	__resnip_test_case(_suite, "set_next with a number throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_set_next(__resnip_test_snip(), 5);
		});
	});

	// Speed values
	__resnip_test_case(_suite, "a negative player speed throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_player_set_speed(resnip_player_create(), -1);
		});
	});

	__resnip_test_case(_suite, "a negative clock scale throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_clock_set_scale(resnip_clock_create(), -1);
		});
	});

	__resnip_test_case(_suite, "a game speed of zero throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_set_game_speed(0);
		});
	});

	__resnip_test_case(_suite, "fractional loop repeats on a player throw", function(_t) {
		__resnip_test_raises(_t, function() {
			var _snip = __resnip_test_snip({ loops: [{ first: 0, last: 1, repeats: 1 }] });
			resnip_player_set_loop_repeats(resnip_player_create(), _snip.loops[0], 1.5);
		});
	});

	// Clone
	__resnip_test_case(_suite, "clone replaces the option and leaves the original", function(_t) {
		var _original = __resnip_test_snip({ speed: 1 });
		var _clone = resnip_snip_clone(_original, { speed: 2 });
		__resnip_test_equal(_t, [_clone.speed, _original.speed], [2, 1]);
	});

	__resnip_test_case(_suite, "clone keeps the loop end", function(_t) {
		var _original = __resnip_test_snip({ loops: [{ first: 1, last: 3, repeats: 2 }] });
		var _clone = resnip_snip_clone(_original, { speed: 2 });
		__resnip_test_equal(_t, [_clone.loops[0].first, _clone.loops[0].last, _clone.loops[0].repeats], [1, 3, 2]);
	});

	__resnip_test_case(_suite, "clone makes new loops", function(_t) {
		var _original = __resnip_test_snip({ loops: [{ first: 1, last: 3, repeats: 2 }] });
		var _clone = resnip_snip_clone(_original, { speed: 2 });
		__resnip_test_true(_t, _clone.loops[0].__key != _original.loops[0].__key);
	});

	__resnip_test_case(_suite, "clone past the sprite throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_clone(__resnip_test_snip(), { last_image: 30 });
		});
	});

	__resnip_test_case(_suite, "clone keeps next", function(_t) {
		var _original = __resnip_test_snip();
		var _next = __resnip_test_snip();
		resnip_snip_set_next(_original, _next);
		__resnip_test_true(_t, resnip_snip_clone(_original).next == _next);
	});

	// Conversion helpers
	__resnip_test_case(_suite, "frame to image adds the first image", function(_t) {
		__resnip_test_equal(_t, resnip_frame_to_image(__resnip_test_snip(), 3), 5);
	});

	__resnip_test_case(_suite, "image to frame subtracts the first image", function(_t) {
		__resnip_test_equal(_t, resnip_image_to_frame(__resnip_test_snip(), 5), 3);
	});

	__resnip_test_case(_suite, "the snip counts its frames", function(_t) {
		__resnip_test_equal(_t, __resnip_test_snip().count, 5);
	});
}
