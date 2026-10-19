function __resnip_test_playback(_snip, _play_options = {}) {
	var _playback = resnip_playback_create();
	resnip_play(_playback, _snip, _play_options);
	return _playback;
}
