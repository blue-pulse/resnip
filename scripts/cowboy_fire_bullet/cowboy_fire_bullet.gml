///@func cowboy_fire_bullet
///@desc Fires a bullet and resizes it to the firing object's scale and gives it speed
function cowboy_fire_bullet(_bullet_speed)
{
	if (!is_struct(self))
	{
		var _bullet = instance_create_depth(x + (10*image_xscale), y + (12*image_xscale), 1, bullet_object);
		_bullet.image_xscale = self.image_xscale;
		_bullet.image_yscale = self.image_yscale;
		_bullet.hspeed = _bullet_speed;
	}
}