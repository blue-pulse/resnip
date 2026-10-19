/// @func resnip_playback_create([clock])
/// @desc Creates a playback, which holds the state of one animation apart from any instance. Read its fields snip, frame, direction, speed, paused and stopped, and set paused to pause it. Set direction only to 1 or -1. Do not write the other fields, and use the functions for them. It has no native equivalent, since a sprite state lives on the instance.
/// @param {Struct} [clock] The clock the playback follows, from resnip_clock_create (default the clock of resnip_clock_default)
/// @returns {Struct} The playback
function resnip_playback_create(_clock = undefined) {
	return {
		// Public fields
		clock: _clock ?? resnip_clock_default(),
		snip: undefined,
		frame: 0,
		direction: RESNIP_FORWARD,
		speed: 1,
		paused: false,
		stopped: false,
		// Private fields
		__progress: 0,
		__loop: __RESNIP_NO_LOOP,
		__passes: [],
		__repeats: {},
		__frame_speeds: undefined,
		__own_frame_speeds: false,
		__queue: undefined,
		__queue_transition: false,
		__queue_backward: false,
		__target: undefined,
		__target_backward: false,
		__serial: 0,
		__skips: 0,
	};
}
