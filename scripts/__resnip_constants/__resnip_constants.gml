// Library data
#macro RESNIP_VERSION "0.1.0"
#macro RESNIP_DATE "2026-10-10"

// Direction of playback
#macro RESNIP_FORWARD 1
#macro RESNIP_BACKWARD -1

// Internal values
#macro __RESNIP_NO_LOOP -1
#macro __RESNIP_EPSILON 0.000001

// What a snip does when it passes its last frame
enum RESNIP_END {
	HOLD,
	REWIND,
	FASTFORWARD,
	REPEAT,
	PINGPONG,
}

// When a pingpong snip counts as complete
enum RESNIP_COMPLETE {
	EDGE,
	HEAD,
	TAIL,
}

// Where resnip_player_stop leaves the player
enum RESNIP_STOP {
	HERE,
	HEAD,
	TAIL,
}
