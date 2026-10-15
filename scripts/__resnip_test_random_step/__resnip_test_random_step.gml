function __resnip_test_random_step(_random) {
	// Every value is exact in binary, so the sums in the properties lose nothing
	static _steps = [0.25, 0.5, 1, 1.5, 2, 3];
	return _steps[__resnip_test_random_next(_random, array_length(_steps))];
}
