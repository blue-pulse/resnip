function __resnip_test_false(_t, _value, _label = "") {
	var _ok = (is_bool(_value) && !_value) || (__resnip_test_is_number(_value) && _value == 0);
	__resnip_test_record(_t, _ok, (_label == "" ? "" : _label + ": ") + "expected false, got " + __resnip_test_describe(_value));
}
