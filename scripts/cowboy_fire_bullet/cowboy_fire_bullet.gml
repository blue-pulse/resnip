///@func cowboy_fire_bullet(bullet_speed, playback)
///@desc Fires a bullet from the instance when its own playback reaches the shooting frame, and ignores the extra playbacks that draw the same snip
function cowboy_fire_bullet(_bullet_speed, _playback) {
	// Prevent extra playbacks from firing
	if (_playback != main_playback) {
		return;
	}

	// Create the bullet
	var _bullet = instance_create_depth(x + (10 * image_xscale), y + (12 * image_xscale), 1, obj_bullet);
	_bullet.image_xscale = image_xscale;
	_bullet.image_yscale = image_yscale;
	_bullet.hspeed = _bullet_speed;
}
