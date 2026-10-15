function __resnip_test_run() {
	// Register the suites
	__resnip_test_suite_end();
	__resnip_test_suite_speed();
	__resnip_test_suite_loops();
	__resnip_test_suite_flow();
	__resnip_test_suite_input();
	__resnip_test_suite_state();
	__resnip_test_suite_callbacks();
	__resnip_test_suite_properties();
	__resnip_test_suite_known();
	__resnip_test_suite_debug();

	// Plain tests run at once, one after the other
	var _suites = __resnip_test_state().suites;
	for (var _s = 0; _s < array_length(_suites); _s++) {
		var _suite = _suites[_s];
		for (var _i = 0; _i < array_length(_suite.tests); _i++) {
			var _test = _suite.tests[_i];
			var _t = __resnip_test_context(_suite.name, _test.name);
			_t.known = _test[$ "known"];
			if (_test.fn != undefined) {
				__resnip_test_execute(_t, _suite, _test.fn);
			}
			__resnip_test_close(_t);
		}
	}
}
