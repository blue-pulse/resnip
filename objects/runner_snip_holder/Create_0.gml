/// @description Create the snips and transitions that the runners will use
left_snip = new Snip(run_left_sprite, .5);
right_snip = new Snip(run_right_sprite, .5);
left_right_snip = new Snip(run_left_to_right, .5);
right_left_snip = new Snip(run_right_to_left, .5);

//Create transitions with the snips
r_l_transition = new Transition(right_snip, left_snip, right_left_snip);
l_r_transition = new Transition(left_snip, right_snip, left_right_snip);

//Set the frame speed for certain frames
snip_set_frame_speed(right_left_snip, 2, .9);
snip_set_frame_speed(right_left_snip, 3, .7);
snip_set_frame_speed(right_left_snip, 4, .9);

snip_set_frame_speed(left_right_snip, 2, .9);
snip_set_frame_speed(left_right_snip, 3, .7);
snip_set_frame_speed(left_right_snip, 4, .9);