function __resnip_test_random_plain(_random) {
	// Plain snips have no loops and no frame speeds, and they never rewind, so a backward run mirrors a forward run
	static _modes = [RESNIP_END.HOLD, RESNIP_END.REPEAT, RESNIP_END.PINGPONG];
	static _speeds = [0.5, 1, 2];
	var _count = 1 + __resnip_test_random_next(_random, 6);
	var _first_image = __resnip_test_random_next(_random, 14);
	return resnip_snip_create(red_cowboy_full, {
		first_image: _first_image,
		last_image: _first_image + _count - 1,
		speed: _speeds[__resnip_test_random_next(_random, 3)],
		end_mode: _modes[__resnip_test_random_next(_random, 3)],
	});
}
