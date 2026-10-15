function __resnip_test_finish() {
	var _totals = __resnip_test_state().totals;
	show_debug_message("[RESULT] " + string(_totals.tests) + " tests, " + string(_totals.passed) + " passed, " + string(_totals.failed) + " failed, " + string(_totals.known) + " known");

	// Zero tests is a failure, because a run that checks nothing must not look green
	var _failed = (_totals.failed > 0 || _totals.tests == 0);
	game_end(_failed ? __RESNIP_TEST_EXIT_FAILED : __RESNIP_TEST_EXIT_PASSED);
}
