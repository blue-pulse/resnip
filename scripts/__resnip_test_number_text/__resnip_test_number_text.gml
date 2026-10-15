function __resnip_test_number_text(_value) {
	// string() rounds to two decimals, which hides small differences in a failure message
	if (_value == floor(_value)) {
		return string(_value);
	}
	var _text = string_format(_value, 1, 6);
	while (string_char_at(_text, string_length(_text)) == "0") {
		_text = string_delete(_text, string_length(_text), 1);
	}
	return _text;
}
