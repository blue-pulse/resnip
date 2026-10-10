/// @description Perform the snip step event

show_debug_message("image_index: " + string(image_index) + " player_image_index: " + string(my_player.ae_snip_player_image_index));

snip_step_event();
my_player.step();

//The user can press numbers 1-9 to change how many times the cowboy shoots his gun
if (keyboard_lastkey != -1) //If a key has been pressed
{
	//If a number was pressed
	if (keyboard_lastkey >= 48 and keyboard_lastkey <= 57)
	{
		//Find out which number was pressed
		fire_count = keyboard_lastkey - ord("0");
		
		//Set the shoot loop repeat count to fire_count
		//Subtract 1 because a loop count of 0 means the loop will still play through once (without repeating)
		//A loop count of -1 means the loop should be skipped
		snip_set_loop_repeat(shoot_loop, fire_count - 1);
		
		//If the gun shot should be entirely skipped
		if (fire_count == 0)
		{
			//Skip the entire firing and gun twirling sequence
			snip_set_loop_repeat(shoot_loop_with_twirl, -1);
		}
		else //If the gun is shooting at least once
		{
			//Play the long loop
			snip_set_loop_repeat(shoot_loop_with_twirl, 0);
		}
	}
	keyboard_lastkey = -1; //Mark it as handled
}