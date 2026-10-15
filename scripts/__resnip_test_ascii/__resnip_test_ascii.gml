function __resnip_test_ascii(_text) {
	// Output stays ASCII, because some console readers fail on other characters
	var _out = "";
	var _length = string_length(_text);
	for (var _i = 1; _i <= _length; _i++) {
		var _code = string_ord_at(_text, _i);
		if (_code == 10) {
			_out += "\\n";
		} else if (_code >= 32 && _code <= 126) {
			_out += chr(_code);
		} else {
			_out += "?";
		}
	}
	return _out;
}
