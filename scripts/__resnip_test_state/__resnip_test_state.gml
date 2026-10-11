function __resnip_test_state(_context, _owner) {
	// Stop and play
	var _player = __resnip_test_player(__resnip_test_snip());
	__resnip_test_trace(_player, 2);
	resnip_player_stop(_player);
	__resnip_test_expect(_context, "stop here keeps the frame", [_player.frame, _player.stopped], [2, true]);
	__resnip_test_expect(_context, "a stopped player does not move", __resnip_test_trace(_player, 2), [2, 2]);
	resnip_player_play(_player, _player.snip);
	__resnip_test_expect(_context, "play restarts a stopped player", [_player.frame, _player.stopped], [0, false]);

	// Stop positions
	resnip_player_stop(_player, RESNIP_STOP.TAIL);
	__resnip_test_expect(_context, "stop at the tail", _player.frame, 4);
	resnip_player_stop(_player, RESNIP_STOP.HEAD);
	__resnip_test_expect(_context, "stop at the head", _player.frame, 0);

	// Player with no snip
	var _empty = resnip_player_create();
	resnip_player_step(_empty);
	resnip_player_stop(_empty);
	__resnip_test_expect(_context, "a player with no snip ignores step and stop", [_empty.snip, _empty.frame], [undefined, 0]);

	// Instance sync
	_player = __resnip_test_player(__resnip_test_snip());
	__resnip_test_trace(_player, 3);
	with (_owner) {
		resnip_instance_sync(_player);
	}
	__resnip_test_expect(_context, "instance sync copies the sprite", _owner.sprite_index, red_cowboy_full);
	__resnip_test_expect(_context, "instance sync copies the sub-image", _owner.image_index, 5);
	__resnip_test_expect(_context, "instance sync stops image_speed", _owner.image_speed, 0);
}
