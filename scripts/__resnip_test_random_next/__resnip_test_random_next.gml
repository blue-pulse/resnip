function __resnip_test_random_next(_random, _count) {
	// A linear congruential generator, so VM and YYC give the same numbers
	_random.state = (_random.state * __RESNIP_TEST_RANDOM_MULTIPLIER + __RESNIP_TEST_RANDOM_INCREMENT) & __RESNIP_TEST_RANDOM_MASK;
	return (_random.state >> __RESNIP_TEST_RANDOM_SHIFT) % _count;
}
