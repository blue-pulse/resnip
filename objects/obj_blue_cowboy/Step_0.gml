/// @description Step the players and read the shot count
// Players
resnip_step(main_player);
resnip_step(copy_player);
resnip_instance_sync(main_player);

// Shot count
if (keyboard_lastkey >= ord("0") && keyboard_lastkey <= ord("9")) {
	fire_count = keyboard_lastkey - ord("0");
	set_fire_count(fire_count);
}
keyboard_lastkey = -1;
