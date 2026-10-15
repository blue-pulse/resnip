function __resnip_test_describe(_value) {
	var _text;
	if (is_array(_value) || is_struct(_value)) {
		try {
			_text = json_stringify(_value);
		} catch (_error) {
			_text = string(_value);
		}
	} else if (is_string(_value)) {
		_text = "\"" + _value + "\"";
	} else if (__resnip_test_is_number(_value)) {
		_text = __resnip_test_number_text(_value) + " (" + typeof(_value) + ")";
	} else {
		_text = string(_value) + " (" + typeof(_value) + ")";
	}
	return string_copy(_text, 1, __RESNIP_TEST_DESCRIBE_LENGTH);
}
