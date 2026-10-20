/// @description Create the snips, the transitions and the playbacks
// Snips
idle_snip = resnip_snip_create(spr_red_cowboy_full, { first_image: 0, last_image: 2, speed: 0.5 });
draw_snip = resnip_snip_create(spr_red_cowboy_full, { first_image: 3, last_image: 6, end_mode: RESNIP_END.HOLD });
fire_snip = resnip_snip_create(spr_red_cowboy_full, {
	first_image: 7,
	last_image: 10,
	end_mode: RESNIP_END.HOLD,
	frame_scripts: [{ frame: 1, callback: method(self, cowboy_fire_bullet), argument: -6 }],
});
holster_snip = resnip_snip_create(spr_red_cowboy_full, {
	first_image: 11,
	last_image: 19,
	end_mode: RESNIP_END.HOLD,
	loops: [{ first: 0, last: 2, repeats: 3 }],
});

// Firing leads back to idle, and both changes play a snip in between
resnip_snip_set_next(fire_snip, idle_snip);
resnip_transition_add(idle_snip, fire_snip, draw_snip);
resnip_transition_add(fire_snip, idle_snip, holster_snip);

// Playbacks
main_playback = resnip_playback_create();
copy_playback = resnip_playback_create();
resnip_play(main_playback, idle_snip);
resnip_play(copy_playback, idle_snip);
