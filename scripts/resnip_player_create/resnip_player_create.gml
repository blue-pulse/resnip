/// @func resnip_player_create([clock])
/// @desc Creates a player, which holds the playback state of one animation apart from any instance. Read its fields snip, frame, direction, speed, paused and stopped, and set paused to pause it. Set direction only to 1 or -1. Do not write the other fields, and use the functions for them. It has no native equivalent, since a sprite state lives on the instance.
/// @param {Struct} [clock] The clock the player follows, from resnip_clock_create (default the clock of resnip_clock_default)
/// @returns {Struct} The player
function resnip_player_create(_clock = undefined)
{
	return {
		clock: _clock ?? resnip_clock_default(),
		snip: undefined,
		frame: 0,
		direction: RESNIP_FORWARD,
		speed: 1,
		paused: false,
		stopped: false,
		__progress: 0,
		__loop: __RESNIP_NO_LOOP,
		__passes: [],
		__repeats: {},
		__queue: undefined,
		__queue_transition: false,
		__target: undefined,
		__start_direction: RESNIP_FORWARD,
		__serial: 0,
	};
}
