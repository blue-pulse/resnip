function __resnip_test_equal(_t, _actual, _expected, _label = "") {
	var _diff = __resnip_test_diff(_actual, _expected);
	__resnip_test_record(_t, _diff == "", (_label == "" ? "" : _label + ": ") + _diff);
}
