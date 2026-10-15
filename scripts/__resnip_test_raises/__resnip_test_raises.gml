function __resnip_test_raises(_t, _fn, _contains = "", _label = "") {
	var _threw = false;
	var _text = "";
	try {
		_fn();
	} catch (_error) {
		_threw = true;
		_text = __resnip_test_exception_text(_error);
	}
	var _ok = _threw && (_contains == "" || string_pos(_contains, _text) > 0);
	var _message = _threw ? "expected a message containing \"" + _contains + "\", got \"" + _text + "\"" : "expected an exception, none was thrown";
	__resnip_test_record(_t, _ok, (_label == "" ? "" : _label + ": ") + _message);
}
