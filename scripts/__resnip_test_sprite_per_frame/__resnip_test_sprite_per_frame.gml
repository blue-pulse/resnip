function __resnip_test_sprite_per_frame(_speed = 1) {
	var _sprite = sprite_duplicate(spr_red_cowboy_full);
	sprite_set_speed(_sprite, _speed, spritespeed_framespergameframe);
	return _sprite;
}
