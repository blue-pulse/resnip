function __resnip_test_state() {
	static _state = {
		suites: [],
		scenarios: [],
		next_scenario: 0,
		active_scenario: undefined,
		totals: { tests: 0, passed: 0, failed: 0 },
		owner: noone,
	};
	return _state;
}
