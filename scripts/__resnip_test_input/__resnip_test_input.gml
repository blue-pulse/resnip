function __resnip_test_input(_context)
{
	__resnip_test_expect(_context, "last image of the sprite is valid", __resnip_test_throws(function() { resnip_snip_create(red_cowboy_full, { last_image: 19 }); }), false);
	__resnip_test_expect(_context, "last image past the sprite throws", __resnip_test_throws(function() { resnip_snip_create(red_cowboy_full, { last_image: 20 }); }), true);
	__resnip_test_expect(_context, "first image after the last throws", __resnip_test_throws(function() { resnip_snip_create(red_cowboy_full, { first_image: 5, last_image: 4 }); }), true);
	__resnip_test_expect(_context, "negative first image throws", __resnip_test_throws(function() { resnip_snip_create(red_cowboy_full, { first_image: -1 }); }), true);
	__resnip_test_expect(_context, "speed of zero throws", __resnip_test_throws(function() { resnip_snip_create(red_cowboy_full, { speed: 0 }); }), true);
	__resnip_test_expect(_context, "negative speed throws", __resnip_test_throws(function() { resnip_snip_create(red_cowboy_full, { speed: -1 }); }), true);
	__resnip_test_expect(_context, "frame speed outside the snip throws", __resnip_test_throws(function() { __resnip_test_snip({ frame_speeds: [{ frame: 5, speed: 1 }] }); }), true);
	__resnip_test_expect(_context, "negative frame speed throws", __resnip_test_throws(function() { __resnip_test_snip({ frame_speeds: [{ frame: 1, speed: -1 }] }); }), true);
	__resnip_test_expect(_context, "loop backward throws", __resnip_test_throws(function() { __resnip_test_snip({ loops: [{ first: 3, last: 1, repeats: 1 }] }); }), true);
	__resnip_test_expect(_context, "loop outside the snip throws", __resnip_test_throws(function() { __resnip_test_snip({ loops: [{ first: 0, last: 5, repeats: 1 }] }); }), true);
	__resnip_test_expect(_context, "fractional repeats throw", __resnip_test_throws(function() { __resnip_test_snip({ loops: [{ first: 0, last: 1, repeats: 0.5 }] }); }), true);
	__resnip_test_expect(_context, "script that cannot be called throws", __resnip_test_throws(function() { __resnip_test_snip({ frame_scripts: [{ frame: 0, callback: "text" }] }); }), true);
	__resnip_test_expect(_context, "two scripts on a frame throw", __resnip_test_throws(function() { __resnip_test_snip({ frame_scripts: [{ frame: 0, callback: function() {} }, { frame: 0, callback: function() {} }] }); }), true);
	__resnip_test_expect(_context, "unknown end mode throws", __resnip_test_throws(function() { __resnip_test_snip({ end_mode: 9 }); }), true);
	__resnip_test_expect(_context, "set_next with a number throws", __resnip_test_throws(function() { resnip_snip_set_next(__resnip_test_snip(), 5); }), true);
	__resnip_test_expect(_context, "negative player speed throws", __resnip_test_throws(function() { resnip_player_set_speed(resnip_player_create(), -1); }), true);
	__resnip_test_expect(_context, "negative clock scale throws", __resnip_test_throws(function() { resnip_clock_set_scale(resnip_clock_create(), -1); }), true);
	__resnip_test_expect(_context, "game speed of zero throws", __resnip_test_throws(function() { resnip_set_game_speed(0); }), true);
	__resnip_test_expect(_context, "fractional loop repeats on a player throw", __resnip_test_throws(function() {
		var _snip = __resnip_test_snip({ loops: [{ first: 0, last: 1, repeats: 1 }] });
		resnip_player_set_loop_repeats(resnip_player_create(), _snip.loops[0], 1.5);
	}), true);

	var _original = __resnip_test_snip({ speed: 1, loops: [{ first: 1, last: 3, repeats: 2 }] });
	var _clone = resnip_snip_clone(_original, { speed: 2 });
	__resnip_test_expect(_context, "clone replaces the option", [_clone.speed, _original.speed], [2, 1]);
	__resnip_test_expect(_context, "clone keeps the loop end", [_clone.loops[0].first, _clone.loops[0].last, _clone.loops[0].repeats], [1, 3, 2]);
	__resnip_test_expect(_context, "clone makes new loops", _clone.loops[0].__key != _original.loops[0].__key, true);
	__resnip_test_expect(_context, "clone past the sprite throws", __resnip_test_throws(function() { resnip_snip_clone(__resnip_test_snip(), { last_image: 30 }); }), true);

	var _next = __resnip_test_snip();
	resnip_snip_set_next(_original, _next);
	__resnip_test_expect(_context, "clone keeps next", resnip_snip_clone(_original).next == _next, true);

	var _snip = __resnip_test_snip();
	__resnip_test_expect(_context, "frame to image", resnip_frame_to_image(_snip, 3), 5);
	__resnip_test_expect(_context, "image to frame", resnip_image_to_frame(_snip, 5), 3);
	__resnip_test_expect(_context, "snip frame count", _snip.count, 5);
}
