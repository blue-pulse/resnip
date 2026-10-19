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
		}, "last_image 20");
	});

	__resnip_test_case(_suite, "a first image after the last throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_create(red_cowboy_full, { first_image: 5, last_image: 4 });
		}, "first_image 5");
	});

	__resnip_test_case(_suite, "a negative first image throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_create(red_cowboy_full, { first_image: -1 });
		}, "first_image -1");
	});

	__resnip_test_case(_suite, "a negative speed throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_create(red_cowboy_full, { speed: -1 });
		}, "received speed -1");
	});

	// Frame data
	__resnip_test_case(_suite, "a frame speed outside the snip throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ frame_speeds: [{ frame: 5, speed: 1 }] });
		}, "received frame 5");
	});

	__resnip_test_case(_suite, "a negative frame speed throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ frame_speeds: [{ frame: 1, speed: -1 }] });
		}, "frame_speeds received speed -1");
	});

	__resnip_test_case(_suite, "a loop that goes backward throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ loops: [{ first: 3, last: 1, repeats: 1 }] });
		}, "starts at frame 3");
	});

	__resnip_test_case(_suite, "a loop outside the snip throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ loops: [{ first: 0, last: 5, repeats: 1 }] });
		}, "received frame 5");
	});

	__resnip_test_case(_suite, "fractional repeats throw", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ loops: [{ first: 0, last: 1, repeats: 0.5 }] });
		}, "received repeats 0.5");
	});

	__resnip_test_case(_suite, "a script that cannot be called throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ frame_scripts: [{ frame: 0, callback: "text" }] });
		}, "cannot be called");
	});

	__resnip_test_case(_suite, "two scripts on a frame throw", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ frame_scripts: [{ frame: 0, callback: __resnip_test_count }, { frame: 0, callback: __resnip_test_count }] });
		}, "two scripts for frame 0");
	});

	__resnip_test_case(_suite, "an unknown end mode throws", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ end_mode: 9 });
		}, "received end_mode 9");
	});

	__resnip_test_case(_suite, "set_next with a number throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_set_next(__resnip_test_snip(), 5);
		}, "resnip_snip_set_next received a next");
	});

	// Speed values
	__resnip_test_case(_suite, "a negative playback speed throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_set_speed(resnip_playback_create(), -1);
		}, "resnip_set_speed received -1");
	});

	__resnip_test_case(_suite, "a negative clock scale throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_clock_set_scale(resnip_clock_create(), -1);
		}, "resnip_clock_set_scale received -1");
	});

	__resnip_test_case(_suite, "fractional loop repeats on a playback throw", function(_t) {
		__resnip_test_raises(_t, function() {
			var _snip = __resnip_test_snip({ loops: [{ first: 0, last: 1, repeats: 1 }] });
			resnip_set_loop_repeats(resnip_playback_create(), _snip.loops[0], 1.5);
		}, "resnip_set_loop_repeats received 1.5");
	});

	// Clone
	__resnip_test_case(_suite, "clone replaces the option and leaves the source", function(_t) {
		var _source = __resnip_test_snip({ speed: 1 });
		var _clone = resnip_snip_clone(_source, { speed: 2 });
		__resnip_test_equal(_t, [_clone.speed, _source.speed], [2, 1]);
	});

	__resnip_test_case(_suite, "clone keeps the loop end", function(_t) {
		var _source = __resnip_test_snip({ loops: [{ first: 1, last: 3, repeats: 2 }] });
		var _clone = resnip_snip_clone(_source, { speed: 2 });
		__resnip_test_equal(_t, [_clone.loops[0].first, _clone.loops[0].last, _clone.loops[0].repeats], [1, 3, 2]);
	});

	__resnip_test_case(_suite, "clone makes new loops", function(_t) {
		var _source = __resnip_test_snip({ loops: [{ first: 1, last: 3, repeats: 2 }] });
		var _clone = resnip_snip_clone(_source, { speed: 2 });
		__resnip_test_true(_t, _clone.loops[0].__key != _source.loops[0].__key);
	});

	__resnip_test_case(_suite, "clone past the sprite throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_clone(__resnip_test_snip(), { last_image: 30 });
		}, "last_image 30");
	});

	__resnip_test_case(_suite, "clone keeps next", function(_t) {
		var _source = __resnip_test_snip();
		var _next = __resnip_test_snip();
		resnip_snip_set_next(_source, _next);
		__resnip_test_true(_t, resnip_snip_clone(_source).next == _next);
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

	__resnip_test_case(_suite, "set_next with options that are not a struct throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_snip_set_next(__resnip_test_snip(), __resnip_test_snip(), 5);
		}, "received options that are not a struct");
	});

	__resnip_test_case(_suite, "next_options that are not a struct throw", function(_t) {
		__resnip_test_raises(_t, function() {
			__resnip_test_snip({ next_options: 5 });
		}, "received next_options that are not a struct");
	});

	__resnip_test_case(_suite, "a frame speed on a playback with no snip throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_set_frame_speed(resnip_playback_create(), 0, 1);
		}, "plays no snip");
	});

	__resnip_test_case(_suite, "a frame speed for a frame outside the snip throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_set_frame_speed(__resnip_test_playback(__resnip_test_snip()), 9, 1);
		}, "received frame 9");
	});

	__resnip_test_case(_suite, "a negative frame speed on a playback throws", function(_t) {
		__resnip_test_raises(_t, function() {
			resnip_set_frame_speed(__resnip_test_playback(__resnip_test_snip()), 1, -1);
		}, "received speed -1");
	});
}
