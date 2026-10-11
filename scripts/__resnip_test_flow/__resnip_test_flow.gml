function __resnip_test_flow(_context) {
	// Helpers
	var _make = function(_first, _last, _options = {}) {
		return resnip_snip_create(red_cowboy_full, __resnip_options_merge({ first_image: _first, last_image: _last }, _options));
	};
	var _push = function(_log, _player) {
		array_push(_log, _player.snip.first_image);
	};

	// Next snip
	var _a = _make(0, 2);
	var _b = _make(3, 5);
	var _c = _make(9, 11);
	resnip_snip_set_next(_a, _b);
	var _player = __resnip_test_player(_a);
	__resnip_test_expect(_context, "next plays after completion", __resnip_test_trace(_player, 4, true), ["0.1", "0.2", "3.0", "3.1"]);

	// Completion before the next snip
	var _log = [];
	_a = _make(0, 2, { on_complete: _push, on_complete_argument: _log });
	_b = _make(3, 5, { frame_scripts: [{ frame: 0, callback: _push, argument: _log }] });
	resnip_snip_set_next(_a, _b);
	_player = __resnip_test_player(_a);
	__resnip_test_trace(_player, 3);
	__resnip_test_expect(_context, "completion runs before the next snip starts", _log, [0, 3]);

	// Queue
	_a = _make(0, 2);
	_b = _make(3, 5);
	_player = __resnip_test_player(_a);
	resnip_player_play(_player, _b, { queue: true });
	__resnip_test_expect(_context, "queue waits for completion", __resnip_test_trace(_player, 3, true), ["0.1", "0.2", "3.0"]);

	_player = __resnip_test_player(_a);
	resnip_player_play(_player, _b, { queue: true });
	resnip_player_cancel_next(_player);
	__resnip_test_expect(_context, "cancel drops the queue", __resnip_test_trace(_player, 3, true), ["0.1", "0.2", "0.0"]);

	_player = __resnip_test_player(_a);
	resnip_player_play(_player, _b, { queue: true });
	resnip_player_play(_player, _c, { queue: true });
	__resnip_test_expect(_context, "a later queue replaces the earlier", __resnip_test_trace(_player, 3, true), ["0.1", "0.2", "9.0"]);

	_player = __resnip_test_player(_a);
	resnip_player_stop(_player);
	resnip_player_play(_player, _b, { queue: true });
	__resnip_test_expect(_context, "queue on a stopped player plays now", _player.snip == _b && !_player.stopped, true);

	// Restart option
	_player = __resnip_test_player(_a);
	__resnip_test_trace(_player, 1);
	__resnip_test_expect(_context, "restart false skips a snip that plays", resnip_player_play(_player, _a, { restart: false }), false);
	__resnip_test_expect(_context, "restart false keeps the frame", _player.frame, 1);
	var _started = resnip_player_play(_player, _a);
	__resnip_test_expect(_context, "restart true starts again", [_started, _player.frame], [true, 0]);

	// Frame script on restart
	_log = [];
	_a = _make(0, 2, { frame_scripts: [{ frame: 0, callback: _push, argument: _log }] });
	_player = __resnip_test_player(_a);
	resnip_player_play(_player, _a);
	__resnip_test_expect(_context, "frame script runs when the same snip restarts", array_length(_log), 2);

	// Transition
	_a = _make(0, 2);
	_b = _make(3, 5);
	var _use = _make(6, 7);
	resnip_transition_add(_a, _b, _use);
	_player = __resnip_test_player(_a);
	resnip_player_play(_player, _b, { transition: true });
	__resnip_test_expect(_context, "transition plays at once", [_player.snip.first_image, _player.frame], [6, 0]);
	__resnip_test_expect(_context, "transition leads to the target", __resnip_test_trace(_player, 3, true), ["6.1", "3.0", "3.1"]);

	_player = __resnip_test_player(_a);
	resnip_player_play(_player, _b);
	__resnip_test_expect(_context, "no transition without the option", _player.snip == _b, true);

	_player = __resnip_test_player(_b);
	resnip_player_play(_player, _a, { transition: true });
	__resnip_test_expect(_context, "no transition registered the other way", _player.snip == _a, true);

	// Backward transition
	_use = _make(6, 8);
	resnip_transition_add(_a, _b, _use, true);
	_player = __resnip_test_player(_a);
	resnip_player_play(_player, _b, { transition: true });
	__resnip_test_expect(_context, "backward transition starts on the last frame", [_player.snip.first_image, _player.frame], [6, 2]);
	__resnip_test_expect(_context, "backward transition leads to the target", __resnip_test_trace(_player, 3, true), ["6.1", "6.0", "3.0"]);

	// Queue with transition
	_use = _make(6, 7);
	resnip_transition_add(_a, _b, _use);
	_player = __resnip_test_player(_a);
	resnip_player_play(_player, _b, { queue: true, transition: true });
	__resnip_test_expect(_context, "queue with transition", __resnip_test_trace(_player, 5, true), ["0.1", "0.2", "6.0", "6.1", "3.0"]);

	resnip_snip_set_next(_a, _b);
	_player = __resnip_test_player(_a);
	__resnip_test_expect(_context, "next uses a transition", __resnip_test_trace(_player, 3, true), ["0.1", "0.2", "6.0"]);

	// Remove transition
	resnip_transition_remove(_a, _b);
	__resnip_test_expect(_context, "find after remove", resnip_transition_find(_a, _b), undefined);
	_player = __resnip_test_player(_a);
	resnip_player_play(_player, _b, { transition: true });
	__resnip_test_expect(_context, "no transition after remove", _player.snip == _b, true);

	// Completion script that plays a snip
	_a = _make(0, 2);
	_b = _make(3, 5);
	resnip_snip_set_next(_a, _b);
	var _take_over = function(_target, _player) {
		resnip_player_play(_player, _target);
	};
	var _owner = _make(0, 2, { on_complete: _take_over, on_complete_argument: _c, next: _b });
	_player = __resnip_test_player(_owner);
	__resnip_test_trace(_player, 3);
	__resnip_test_expect(_context, "a completion script that plays a snip wins over next", _player.snip == _c, true);

	// Next that points to itself
	_a = _make(0, 2);
	resnip_snip_set_next(_a, _a);
	_player = __resnip_test_player(_a);
	__resnip_test_expect(_context, "next that points to itself restarts", __resnip_test_trace(_player, 3, true), ["0.1", "0.2", "0.0"]);

	_player = __resnip_test_player(_a);

	// Callback arguments
	var _args = [];
	var _record = function(_list, _player) {
		array_push(_list, _player);
	};
	var _watched = _make(0, 2, { frame_scripts: [{ frame: 1, callback: _record, argument: _args }] });
	_player = __resnip_test_player(_watched);
	__resnip_test_trace(_player, 1);
	__resnip_test_expect(_context, "callbacks receive the argument and the player", _args[0] == _player, true);
}
