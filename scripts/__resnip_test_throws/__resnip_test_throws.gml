function __resnip_test_throws(_action) {
	try {
		_action();
	} catch (_error) {
		return true;
	}
	return false;
}
