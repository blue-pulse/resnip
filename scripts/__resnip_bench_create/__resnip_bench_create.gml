#macro __RESNIP_BENCH_STEPS 130
#macro __RESNIP_BENCH_WARMUP 10
#macro __RESNIP_BENCH_LOOP_COUNT 4

function __resnip_bench_create()
{
	// Sprite red_cowboy_full runs at 15 frames per second, so this gives one frame per step
	resnip_set_game_speed(15);

	var _loops = [];
	for (var _i = 0; _i < __RESNIP_BENCH_LOOP_COUNT; _i++)
	{
		array_push(_loops, { first: _i * 4, last: _i * 4 + 3, repeats: 1 });
	}

	var _plain = resnip_snip_create(red_cowboy_full);
	var _looped = resnip_snip_create(red_cowboy_full, { loops: _loops });

	var _configs = [];
	var _sizes = [1000, 5000, 10000];
	for (var _i = 0; _i < array_length(_sizes); _i++)
	{
		array_push(_configs, { count: _sizes[_i], snip: _plain, loops: 0 });
		array_push(_configs, { count: _sizes[_i], snip: _looped, loops: __RESNIP_BENCH_LOOP_COUNT });
	}

	return { configs: _configs, index: 0, players: [], steps: 0, micros: 0 };
}
