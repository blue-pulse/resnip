function __resnip_test_loops(_context) {
	// Variables
	var _hold = RESNIP_END.HOLD;

	// Repeat counts
	var _snip = __resnip_test_snip({ end_mode: _hold, loops: [{ first: 1, last: 2, repeats: 2 }] });
	var _player = __resnip_test_player(_snip);
	__resnip_test_expect(_context, "loop plays repeats plus one", __resnip_test_trace(_player, 9), [1, 2, 1, 2, 1, 2, 3, 4, 4]);

	_player = __resnip_test_player(__resnip_test_snip({ end_mode: _hold, loops: [{ first: 1, last: 2, repeats: 0 }] }));
	__resnip_test_expect(_context, "loop with zero repeats plays once", __resnip_test_trace(_player, 5), [1, 2, 3, 4, 4]);

	_player = __resnip_test_player(__resnip_test_snip({ end_mode: _hold, loops: [{ first: 1, last: 2, repeats: -1 }] }));
	__resnip_test_expect(_context, "loop below zero is skipped", __resnip_test_trace(_player, 3), [3, 4, 4]);

	// Player overrides
	_snip = __resnip_test_snip({ end_mode: _hold, loops: [{ first: 1, last: 2, repeats: 0 }] });
	_player = resnip_player_create();
	resnip_player_set_loop_repeats(_player, _snip.loops[0], 1);
	resnip_player_play(_player, _snip);
	__resnip_test_expect(_context, "player repeats override the loop", __resnip_test_trace(_player, 7), [1, 2, 1, 2, 3, 4, 4]);

	_snip = __resnip_test_snip({ end_mode: _hold, loops: [{ first: 1, last: 2, repeats: 5 }] });
	_player = resnip_player_create();
	resnip_player_set_loop_repeats(_player, _snip.loops[0], -1);
	resnip_player_play(_player, _snip);
	__resnip_test_expect(_context, "player override can skip a loop", __resnip_test_trace(_player, 3), [3, 4, 4]);
	resnip_player_set_loop_repeats(_player, _snip.loops[0], undefined);
	resnip_player_play(_player, _snip);
	var _trace = __resnip_test_trace(_player, 14);
	__resnip_test_expect(_context, "clearing the override restores the loop", [_trace[12], _trace[13]], [3, 4]);

	// Change inside a loop
	_snip = __resnip_test_snip({ end_mode: _hold, loops: [{ first: 1, last: 2, repeats: 5 }] });
	_player = __resnip_test_player(_snip);
	__resnip_test_trace(_player, 1);
	resnip_player_set_loop_repeats(_player, _snip.loops[0], 0);
	__resnip_test_expect(_context, "repeats lowered while inside the loop", __resnip_test_trace(_player, 4), [2, 1, 2, 3]);

	// Backward
	_player = __resnip_test_player(__resnip_test_snip({ end_mode: _hold, loops: [{ first: 1, last: 2, repeats: 1 }] }), { backward: true });
	__resnip_test_expect(_context, "loop backward", __resnip_test_trace(_player, 7), [3, 2, 1, 2, 1, 0, 0]);

	_player = __resnip_test_player(__resnip_test_snip({ end_mode: _hold, loops: [{ first: 1, last: 2, repeats: -1 }] }), { backward: true });
	__resnip_test_expect(_context, "skip backward", __resnip_test_trace(_player, 3), [3, 0, 0]);

	// Reset on repeat
	_player = __resnip_test_player(__resnip_test_snip({ loops: [{ first: 1, last: 2, repeats: 1 }] }));
	__resnip_test_expect(_context, "loops reset when the snip repeats", __resnip_test_trace(_player, 10), [1, 2, 1, 2, 3, 4, 0, 1, 2, 1]);

	// Several loops
	_player = __resnip_test_player(__resnip_test_snip({ end_mode: _hold, loops: [{ first: 1, last: 3, repeats: 0 }, { first: 1, last: 2, repeats: 1 }] }));
	__resnip_test_expect(_context, "a loop that never repeats does not hide the next", __resnip_test_trace(_player, 7), [1, 2, 1, 2, 3, 4, 4]);

	_player = __resnip_test_player(__resnip_test_snip({ end_mode: _hold, loops: [{ first: 0, last: 4, repeats: 1 }, { first: 1, last: 2, repeats: 1 }] }));
	__resnip_test_expect(_context, "overlapping loops use the first one in order", __resnip_test_trace(_player, 12), [1, 2, 3, 4, 0, 1, 2, 1, 2, 3, 4, 4]);

	_player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG, loops: [{ first: 1, last: 2, repeats: 1 }] }));
	__resnip_test_expect(_context, "loops reset when pingpong turns", __resnip_test_trace(_player, 13), [1, 2, 1, 2, 3, 4, 3, 2, 1, 2, 1, 0, 1]);
}
