function __resnip_test_exception_text(_error) {
	if (is_struct(_error) && variable_struct_exists(_error, "message")) {
		return string(_error.message);
	}
	return string(_error);
}
