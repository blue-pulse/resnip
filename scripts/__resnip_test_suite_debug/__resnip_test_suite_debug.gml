function __resnip_test_suite_debug() {
	var _suite = __resnip_test_suite("debug");

	// The panel draws in the Draw event of the test object, so a drawing error ends the run without a result
	__resnip_test_scenario(_suite, "the debug panel draws while its player advances", 5, function(_t) {
		var _snip = resnip_snip_create(red_cowboy_full, {
			loops: [{ first: 5, last: 8, repeats: 2 }],
			frame_scripts: [{ frame: 6, callback: function() {} }],
		});
		var _player = resnip_player_create();
		resnip_player_play(_player, _snip);
		__resnip_test_state().owner.debug_player = _player;
	}, function(_t) {
		var _player = __resnip_test_state().owner.debug_player;
		__resnip_test_true(_t, _player.frame > 0);
	}, function(_t) {
		__resnip_test_state().owner.debug_player = undefined;
	});
}
