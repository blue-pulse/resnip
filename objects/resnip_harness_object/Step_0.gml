// Debug player
if (debug_player != undefined) {
	resnip_player_step(debug_player);
}

// Benchmark
if (bench != undefined && __resnip_bench_step(bench)) {
	game_end();
}
