function __resnip_test_run(_owner) {
	// Variables
	var _context = { passed: 0, failed: 0 };
	var _game_speed = __resnip_system().game_speed;

	// Sprite red_cowboy_full runs at 15 frames per second, so this gives one frame per step
	resnip_set_game_speed(15);

	// Test groups
	__resnip_test_end(_context);
	__resnip_test_speed(_context);
	__resnip_test_loops(_context);
	__resnip_test_flow(_context);
	__resnip_test_input(_context);
	__resnip_test_state(_context, _owner);

	// Restore and report
	resnip_set_game_speed(_game_speed);
	show_debug_message("[RESULT] " + string(_context.passed) + " passed, " + string(_context.failed) + " failed");
	return _context.failed;
}
