function __resnip_test_diff(_actual, _expected, _path = "value") {
	// Numbers compare by value whatever their storage type
	if (__resnip_test_is_number(_actual) && __resnip_test_is_number(_expected)) {
		return (_actual == _expected) ? "" : _path + ": expected " + __resnip_test_describe(_expected) + ", got " + __resnip_test_describe(_actual);
	}

	// Anything else of a different type is a difference, which also covers array against struct
	if (typeof(_actual) != typeof(_expected)) {
		return _path + ": expected " + __resnip_test_describe(_expected) + ", got " + __resnip_test_describe(_actual);
	}

	if (is_array(_expected)) {
		var _length = array_length(_expected);
		if (array_length(_actual) != _length) {
			return _path + ": expected length " + string(_length) + ", got " + string(array_length(_actual));
		}
		for (var _i = 0; _i < _length; _i++) {
			var _inner = __resnip_test_diff(_actual[_i], _expected[_i], _path + "[" + string(_i) + "]");
			if (_inner != "") {
				return _inner;
			}
		}
		return "";
	}

	if (is_struct(_expected)) {
		var _names = variable_struct_get_names(_expected);
		array_sort(_names, true);
		var _count = array_length(_names);
		if (array_length(variable_struct_get_names(_actual)) != _count) {
			return _path + ": expected " + string(_count) + " fields, got " + string(array_length(variable_struct_get_names(_actual)));
		}
		for (var _n = 0; _n < _count; _n++) {
			var _name = _names[_n];
			if (!variable_struct_exists(_actual, _name)) {
				return _path + "." + _name + ": missing";
			}
			var _field = __resnip_test_diff(_actual[$ _name], _expected[$ _name], _path + "." + _name);
			if (_field != "") {
				return _field;
			}
		}
		return "";
	}

	return (_actual == _expected) ? "" : _path + ": expected " + __resnip_test_describe(_expected) + ", got " + __resnip_test_describe(_actual);
}
