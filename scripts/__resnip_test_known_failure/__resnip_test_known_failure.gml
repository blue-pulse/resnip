function __resnip_test_known_failure(_suite, _name, _reason, _fn = undefined) {
	array_push(_suite.tests, { name: _name, fn: _fn, known: _reason });
}
