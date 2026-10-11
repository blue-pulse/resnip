function __resnip_system()
{
	static _state = {
		game_speed: RESNIP_DEFAULT_GAME_SPEED,
		clock: { paused: false, scale: 1 },
		transitions: {},
		last_id: 0,
	};
	return _state;
}
