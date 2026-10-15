function __resnip_test_near(_t, _actual, _expected, _tolerance = __RESNIP_TEST_TOLERANCE, _label = "") {
	var _ok = __resnip_test_is_number(_actual) && __resnip_test_is_number(_expected) && abs(_actual - _expected) <= _tolerance;
	var _message = "expected " + __resnip_test_describe(_expected) + " within " + __resnip_test_number_text(_tolerance) + ", got " + __resnip_test_describe(_actual);
	__resnip_test_record(_t, _ok, (_label == "" ? "" : _label + ": ") + _message);
}
