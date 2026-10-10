/// @description Initialize object

//Call the snip create event
snip_create_event();

//Create a new Snip with the cowboy sprite
my_snip = new Snip(blue_cowboy_sprite, 1);

//Create two loops that the user controls
shoot_loop_with_twirl = new Loop(my_snip, 5, 12, 0);
shoot_loop = new Loop(my_snip, 5, 8, 0);
//Since they repeat 0 times they don't do anything until the user presses a number

//A loop to make the cowboy look a little fancier
twirl_loop = new Loop(my_snip, 9, 11, 3);

//Customize the speed of a couple of the frames
snip_set_frame_speed(my_snip, 4, .2);
snip_set_frame_speed(my_snip, 8, .2);
snip_set_frame_speed(my_snip, 16, .2);

//Add the fire bullet script to the shooting frame
//Uses a value of -10 as the argument for the script, it will be used as the bullet speed
snip_set_frame_script(my_snip, 6, cowboy_fire_bullet, -10);

//Play the snip
snip_play(my_snip, true);

//A variable to tell the cowboy how many times to shoot
fire_count = 1;

//Set up a SnipPlayer to draw the Snip multiple times
my_player = new SnipPlayer();
my_player.snip_start(my_snip, false);
