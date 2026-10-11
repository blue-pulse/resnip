function __resnip_test_expect(_context, _name, _actual, _expected) {
	if (json_stringify(_actual) == json_stringify(_expected))
	{
		_context.passed += 1;
		return;
	}
	_context.failed += 1;
	show_debug_message("[ERROR] FAIL " + _name + ", expected " + json_stringify(_expected) + " and got " + json_stringify(_actual));
}
