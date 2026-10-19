function __resnip_playback_reset_loops(_playback) {
	_playback.__loop = __RESNIP_NO_LOOP;
	_playback.__passes = array_create(array_length(_playback.snip.loops), 0);
}
