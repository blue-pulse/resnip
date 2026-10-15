function __resnip_test_suite(_name) {
	var _suite = { name: _name, tests: [], before_each: __resnip_test_reset, after_each: undefined };
	array_push(__resnip_test_state().suites, _suite);
	return _suite;
}
