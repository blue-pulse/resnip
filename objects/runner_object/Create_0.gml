/// @description Setup snip
snip_create_event();

//Start the animation
snip_start(runner_snip_holder.left_snip);

//Set up the SnipPlayer to draw the Snip multiple times
my_player = new SnipPlayer();
my_player.snip_start(runner_snip_holder.left_snip);