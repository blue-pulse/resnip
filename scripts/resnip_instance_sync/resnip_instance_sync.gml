/// @func resnip_instance_sync(player)
/// @desc Copies the sprite and the sub-image of a player to the instance that calls it and sets image_speed to 0, so the mask, draw_self and any code that reads sprite_index and image_index follow the player. Call it in the Step event after resnip_player_step. It adds no state to the instance.
/// @param {Struct} player The player to copy from
function resnip_instance_sync(_player)
{
	var _snip = _player.snip;
	if (_snip != undefined)
	{
		sprite_index = _snip.sprite;
		image_index = resnip_frame_to_image(_snip, _player.frame);
		image_speed = 0;
	}
}
