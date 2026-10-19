/// @description Step the playbacks and read the shot count
// Playbacks
resnip_step(main_playback);
resnip_step(copy_playback);
resnip_instance_sync(main_playback);

// Shot count
if (keyboard_lastkey >= ord("0") && keyboard_lastkey <= ord("9")) {
	fire_count = keyboard_lastkey - ord("0");
	set_fire_count(fire_count);
}
keyboard_lastkey = -1;
