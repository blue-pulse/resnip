function __resnip_test_reset(_t) {
	// Shared state of the library, so one test cannot leak into the next
	var _system = __resnip_system();
	_system.game_speed = __RESNIP_TEST_GAME_SPEED;
	_system.clock.paused = false;
	_system.clock.scale = 1;
	_system.transitions = {};
}
