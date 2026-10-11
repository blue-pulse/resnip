/// @description Run the tests or the benchmark when tools/gm.py asks
mode = environment_get_variable("RESNIP_MODE");
failures = 0;
bench = undefined;
debug_player = undefined;

if (mode == "test")
{
	failures = __resnip_test_run(id);

	// A player for the debug panel, which runs here so a drawing error shows up
	var _snip = resnip_snip_create(red_cowboy_full, {
		loops: [{ first: 5, last: 8, repeats: 2 }],
		frame_scripts: [{ frame: 6, callback: function() {} }],
	});
	debug_player = resnip_player_create();
	resnip_player_play(debug_player, _snip);
	alarm[0] = 5;
}
else if (mode == "bench")
{
	bench = __resnip_bench_create();
}
else
{
	instance_destroy();
}
