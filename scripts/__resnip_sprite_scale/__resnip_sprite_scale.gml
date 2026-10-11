function __resnip_sprite_scale(_snip) {
	gml_pragma("forceinline");
	if (_snip.sprite_speed_type == spritespeed_framespergameframe)
	{
		return _snip.sprite_speed;
	}

	// Convert frames per second to frames per step
	return _snip.sprite_speed / __resnip_system().game_speed;
}
