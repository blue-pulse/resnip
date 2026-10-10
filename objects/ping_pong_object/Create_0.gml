/// @desc Create the Snip and perform events

/*
This is just a quick object to showcase the pingpong end type,
nothing fancy
*/

my_snip = new Snip(sprite_index, 1);
snip_set_frame_speed(my_snip, 9, .5);
snip_set_frame_speed(my_snip, 0, .5);


add = function()
{
	if (!is_method(self))
	{
		image_angle += 5;
	}
}

//Turn a little bit every time the Snip finishes playing
snip_set_completion_script(my_snip, add)

//Adjust the end type to see how the different pingpong types change the behavior
//end_pingpong
//end_pingpong_head
//end_pingpong_tail
snip_set_end_type(my_snip, ae_snip_end.end_pingpong);

snip_create_event();

snip_start(my_snip);

//Set up the SnipPlayer to draw the Snip multiple times
my_player = new SnipPlayer();
my_player.snip_play(my_snip, false);