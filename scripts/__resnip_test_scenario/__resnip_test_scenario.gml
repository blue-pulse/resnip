function __resnip_test_scenario(_suite, _name, _steps, _setup, _check, _teardown = undefined) {
	array_push(__resnip_test_state().scenarios, { suite: _suite, name: _name, steps: _steps, setup: _setup, check: _check, teardown: _teardown });
}
