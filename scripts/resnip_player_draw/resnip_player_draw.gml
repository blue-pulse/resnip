/// @func resnip_player_draw(player, x, y)
/// @desc Draws the current frame of a player. It works like draw_sprite and takes the sprite and the sub-image from the player. It draws nothing if the player plays no snip.
/// @param {Struct} player The player to draw
/// @param {Real} x The x position
/// @param {Real} y The y position
function resnip_player_draw(_player, _x, _y) {
	var _snip = _player.snip;
	if (_snip != undefined)
	{
		draw_sprite(_snip.sprite, resnip_frame_to_image(_snip, _player.frame), _x, _y);
	}
}
