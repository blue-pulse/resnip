/// @func resnip_player_set_speed(player, speed)
/// @desc Sets the speed of one player, which multiplies the speed of the snip and of each frame. It replaces changing image_speed.
/// @param {Struct} player The player to change
/// @param {Real} speed The multiplier, 0 or above
function resnip_player_set_speed(_player, _speed)
{
	if (_speed < 0)
	{
		__resnip_error("resnip_player_set_speed received " + string(_speed) + ". Use 0 or above, and play backward with the backward option of resnip_player_play.");
	}
	_player.speed = _speed;
}
