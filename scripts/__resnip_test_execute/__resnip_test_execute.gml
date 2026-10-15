function __resnip_test_execute(_t, _suite, _fn) {
	// An exception fails this test only, so the next one still runs
	try {
		if (is_callable(_suite.before_each)) {
			_suite.before_each(_t);
		}
		_fn(_t);
	} catch (_error) {
		array_push(_t.failures, "exception: " + __resnip_test_exception_text(_error));
	}

	// The cleanup hook runs even when the test threw
	try {
		if (is_callable(_suite.after_each)) {
			_suite.after_each(_t);
		}
	} catch (_cleanup_error) {
		array_push(_t.failures, "exception in after_each: " + __resnip_test_exception_text(_cleanup_error));
	}
}
