function __resnip_test_reset(_t) {
	// Gamespeed of the engine and shared state of the library, so one test cannot leak into the next
	game_set_speed(__RESNIP_TEST_GAMESPEED, gamespeed_fps);
	var _system = __resnip_system();
	_system.clock.paused = false;
	_system.clock.scale = 1;
	_system.transitions = {};
}
