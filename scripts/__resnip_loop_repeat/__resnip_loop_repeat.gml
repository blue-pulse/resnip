function __resnip_loop_repeat(_player, _loop)
{
	gml_pragma("forceinline");
	return _player.__repeats[$ _loop.__key] ?? _loop.repeats;
}
