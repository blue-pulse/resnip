function __resnip_test_end(_context)
{
	var _count = function(_counter, _player) { _counter.hits += 1; };

	var _player = __resnip_test_player(__resnip_test_snip());
	__resnip_test_expect(_context, "repeat forward", __resnip_test_trace(_player, 12), [1, 2, 3, 4, 0, 1, 2, 3, 4, 0, 1, 2]);

	_player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD }));
	__resnip_test_expect(_context, "hold forward", __resnip_test_trace(_player, 8), [1, 2, 3, 4, 4, 4, 4, 4]);
	__resnip_test_expect(_context, "hold stops the player", _player.stopped, true);

	_player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.REWIND }));
	__resnip_test_expect(_context, "rewind forward", __resnip_test_trace(_player, 7), [1, 2, 3, 4, 0, 0, 0]);

	_player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG }));
	__resnip_test_expect(_context, "pingpong forward", __resnip_test_trace(_player, 12), [1, 2, 3, 4, 3, 2, 1, 0, 1, 2, 3, 4]);

	_player = __resnip_test_player(__resnip_test_snip(), { backward: true });
	__resnip_test_expect(_context, "repeat backward", __resnip_test_trace(_player, 6), [3, 2, 1, 0, 4, 3]);

	_player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD }), { backward: true });
	__resnip_test_expect(_context, "hold backward", __resnip_test_trace(_player, 5), [3, 2, 1, 0, 0]);

	var _counter = { hits: 0 };
	_player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG, complete_on: RESNIP_COMPLETE.EDGE, on_complete: _count, on_complete_argument: _counter }));
	__resnip_test_trace(_player, 12);
	__resnip_test_expect(_context, "pingpong edge completes at each edge", _counter.hits, 2);

	_counter = { hits: 0 };
	_player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG, complete_on: RESNIP_COMPLETE.CYCLE, on_complete: _count, on_complete_argument: _counter }));
	__resnip_test_trace(_player, 12);
	__resnip_test_expect(_context, "pingpong cycle completes on return", _counter.hits, 1);

	_counter = { hits: 0 };
	_player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.PINGPONG, complete_on: RESNIP_COMPLETE.CYCLE, on_complete: _count, on_complete_argument: _counter }), { backward: true });
	__resnip_test_expect(_context, "cycle backward trace", __resnip_test_trace(_player, 8), [3, 2, 1, 0, 1, 2, 3, 4]);
	__resnip_test_expect(_context, "cycle backward waits before the return", _counter.hits, 0);
	__resnip_test_trace(_player, 1);
	__resnip_test_expect(_context, "cycle backward completes on return", _counter.hits, 1);

	_counter = { hits: 0 };
	_player = __resnip_test_player(__resnip_test_snip({ on_complete: _count, on_complete_argument: _counter }));
	__resnip_test_trace(_player, 12);
	__resnip_test_expect(_context, "repeat completes at each wrap", _counter.hits, 2);

	_counter = { hits: 0 };
	_player = __resnip_test_player(__resnip_test_snip({ end_mode: RESNIP_END.HOLD, on_complete: _count, on_complete_argument: _counter }));
	__resnip_test_trace(_player, 8);
	__resnip_test_expect(_context, "hold completes once", _counter.hits, 1);
}
