function __resnip_test_scenario_tick() {
	var _state = __resnip_test_state();
	var _active = _state.active_scenario;

	// Idle, so start the next scenario or finish
	if (_active == undefined) {
		if (_state.next_scenario >= array_length(_state.scenarios)) {
			__resnip_test_finish();
			return;
		}
		var _scenario = _state.scenarios[_state.next_scenario];
		_state.next_scenario += 1;
		_active = {
			scenario: _scenario,
			t: __resnip_test_context(_scenario.suite.name, _scenario.name),
			remaining: max(0, _scenario.steps - 1),
		};
		_state.active_scenario = _active;
		try {
			if (is_callable(_scenario.suite.before_each)) {
				_scenario.suite.before_each(_active.t);
			}
			_scenario.setup(_active.t);
		} catch (_error) {
			array_push(_active.t.failures, "exception in setup: " + __resnip_test_exception_text(_error));
			_active.remaining = 0;
		}
		return;
	}

	// Waiting for the requested steps
	if (_active.remaining > 0) {
		_active.remaining -= 1;
		return;
	}

	// Steps are done, so check, clean up and close
	var _t = _active.t;
	if (array_length(_t.failures) == 0) {
		try {
			_active.scenario.check(_t);
		} catch (_check_error) {
			array_push(_t.failures, "exception in check: " + __resnip_test_exception_text(_check_error));
		}
	}
	try {
		if (is_callable(_active.scenario.teardown)) {
			_active.scenario.teardown(_t);
		}
	} catch (_teardown_error) {
		array_push(_t.failures, "exception in teardown: " + __resnip_test_exception_text(_teardown_error));
	}
	__resnip_test_close(_t);
	_state.active_scenario = undefined;
}
