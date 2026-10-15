function __resnip_test_close_known(_t) {
	var _totals = __resnip_test_state().totals;
	var _label = _t.suite + " > " + _t.name;

	// A known failure that now passes means the mark is out of date
	if (_t.assertions > 0 && array_length(_t.failures) == 0) {
		_totals.failed += 1;
		show_debug_message("[ERROR] " + _label + ": it passes now, so remove the known failure mark");
		return;
	}

	_totals.known += 1;
	show_debug_message("[KNOWN] " + _label + ": " + _t.known);
}
