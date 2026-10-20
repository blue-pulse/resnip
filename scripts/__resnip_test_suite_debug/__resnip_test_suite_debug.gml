function __resnip_test_suite_debug() {
	var _suite = __resnip_test_suite("debug");

	// The panel draws in the Draw event of the test object, so a drawing error ends the run without a result
	__resnip_test_scenario(_suite, "the debug panel draws while its playback advances", 5, function(_t) {
		var _snip = resnip_snip_create(spr_red_cowboy_full, {
			loops: [{ first: 5, last: 8, repeats: 2 }],
			frame_scripts: [{ frame: 6, callback: function() {} }],
		});
		var _playback = resnip_playback_create();
		resnip_play(_playback, _snip);
		__resnip_test_state().owner.debug_playback = _playback;
	}, function(_t) {
		var _playback = __resnip_test_state().owner.debug_playback;
		__resnip_test_true(_t, _playback.frame > 0);
	}, function(_t) {
		__resnip_test_state().owner.debug_playback = undefined;
	});
}
