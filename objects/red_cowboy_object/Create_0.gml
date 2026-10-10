/// @description Set up the snips
snip_create_event();

//Create Snips
idle_snip = snip_create_ext(red_cowboy_full, .5, 0, 2, ae_snip_end.end_repeat, undefined);
draw_snip = snip_create_ext(red_cowboy_full, 1, 3, 6, ae_snip_end.end_stop_head, undefined);
fire_snip = snip_create_ext(red_cowboy_full, 1, 7, 10, ae_snip_end.end_stop_tail, undefined);
holster_snip = snip_create_ext(red_cowboy_full, 1, 11, 19, ae_snip_end.end_stop, undefined);
//Set the idle Snip as the fire Snip's successor and automatically create a precursor
snip_set_successor(fire_snip, idle_snip, true);
//Set some snips as transitions
//Add a transition between the idle snip and the firing snip
draw_transition = new Transition(idle_snip, fire_snip, draw_snip);
//Add a transition between firing and idling
holster_transition = new Transition(fire_snip, idle_snip, holster_snip);
//Add a loop to twirl the gun multiple times
twirl_loop = new Loop(holster_snip, 0, 2, 3);

//Add a script to the gun fire frame that creates a bullet with a value to be passed into the script
//Uses a value of -6 as the bullet's speed
snip_set_frame_script(fire_snip, 1, cowboy_fire_bullet, -6);

//Play the idle snip
snip_start(idle_snip);

//Set up the SnipPlayer to draw the Snip multiple times
my_player = new SnipPlayer();
my_player.snip_start(idle_snip);