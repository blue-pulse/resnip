/// @func resnip_set_game_speed(fps)
/// @desc Tells the library the speed of the game in frames per second, which it uses to read sprites set in frames per second. The library never reads it from the game, so call this once at start and again if the game changes its speed. It replaces reading game_get_speed inside the library.
/// @param {Real} fps The game speed in frames per second
function resnip_set_game_speed(_fps) {
	if (_fps <= 0) {
		__resnip_error("resnip_set_game_speed received " + string(_fps) + ". Pass the game speed in frames per second, above 0.");
	}
	__resnip_system().game_speed = _fps;
}
