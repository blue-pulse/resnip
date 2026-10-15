function __resnip_test_record(_t, _ok, _message) {
	_t.assertions += 1;
	if (!_ok) {
		array_push(_t.failures, _message);
	}
}
