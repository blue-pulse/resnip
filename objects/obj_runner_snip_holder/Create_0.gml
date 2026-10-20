/// @description Create the snips and the transitions that the runners share
// Frame speeds
var _turn_speeds = [
	{ frame: 2, speed: 0.9 },
	{ frame: 3, speed: 0.7 },
	{ frame: 4, speed: 0.9 },
];

// Snips
left_snip = resnip_snip_create(spr_run_left, { speed: 0.5 });
right_snip = resnip_snip_create(spr_run_right, { speed: 0.5 });
left_right_snip = resnip_snip_create(spr_run_left_to_right, { speed: 0.5, frame_speeds: _turn_speeds });
right_left_snip = resnip_snip_create(spr_run_right_to_left, { speed: 0.5, frame_speeds: _turn_speeds });

// Transitions
resnip_transition_add(right_snip, left_snip, right_left_snip);
resnip_transition_add(left_snip, right_snip, left_right_snip);
