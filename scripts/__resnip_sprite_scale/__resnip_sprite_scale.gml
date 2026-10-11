function __resnip_sprite_scale(_snip)
{
	gml_pragma("forceinline");
	if (_snip.sprite_speed_type == spritespeed_framespergameframe)
	{
		return _snip.sprite_speed;
	}
	return _snip.sprite_speed / __resnip_system().game_speed;
}
