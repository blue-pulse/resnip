function __resnip_test_true(_t, _value, _label = "") {
	// The real 1 counts, because many built-in functions return 0 or 1
	var _ok = (is_bool(_value) && _value) || (__resnip_test_is_number(_value) && _value == 1);
	__resnip_test_record(_t, _ok, (_label == "" ? "" : _label + ": ") + "expected true, got " + __resnip_test_describe(_value));
}
