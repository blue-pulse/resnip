function __resnip_test_case(_suite, _name, _fn) {
	array_push(_suite.tests, { name: _name, fn: _fn });
}
