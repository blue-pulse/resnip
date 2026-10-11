///@func cowboy_fire_bullet(bullet_speed, player)
///@desc Fires a bullet from the instance when its own player reaches the shooting frame, and ignores the extra players that draw the same snip
function cowboy_fire_bullet(_bullet_speed, _player)
{
	if (_player != main_player)
	{
		return;
	}

	var _bullet = instance_create_depth(x + (10 * image_xscale), y + (12 * image_xscale), 1, bullet_object);
	_bullet.image_xscale = image_xscale;
	_bullet.image_yscale = image_yscale;
	_bullet.hspeed = _bullet_speed;
}
