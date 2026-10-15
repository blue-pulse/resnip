function __resnip_test_close(_t) {
	var _totals = __resnip_test_state().totals;
	_totals.tests += 1;

	// A test that checked nothing proves nothing
	if (_t.assertions == 0 && array_length(_t.failures) == 0) {
		array_push(_t.failures, "no assertions ran");
	}

	var _failure_count = array_length(_t.failures);
	if (_failure_count == 0) {
		_totals.passed += 1;
		return;
	}

	_totals.failed += 1;
	for (var _i = 0; _i < _failure_count; _i++) {
		show_debug_message("[ERROR] " + _t.suite + " > " + _t.name + ": " + __resnip_test_ascii(_t.failures[_i]));
	}
}
