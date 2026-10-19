// Scenarios, one step each
__resnip_test_scenario_tick();

// Playback of the debug panel scenario
if (debug_playback != undefined) {
	resnip_step(debug_playback);
}
