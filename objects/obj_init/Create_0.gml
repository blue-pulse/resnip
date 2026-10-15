/// @description Choose the environment to enter
var _mode = environment_get_variable(__RESNIP_RUN_VARIABLE);
if (_mode == __RESNIP_RUN_TEST) {
	room_goto(rm_test);
} else if (_mode == __RESNIP_RUN_BENCH) {
	room_goto(rm_bench);
} else {
	if (_mode != "") {
		show_debug_message("[WARNING] The environment variable " + __RESNIP_RUN_VARIABLE + " is \"" + _mode + "\". Use \"" + __RESNIP_RUN_TEST + "\" or \"" + __RESNIP_RUN_BENCH + "\", or leave it empty to run the demo.");
	}
	room_goto(rm_main);
}
