function __resnip_test_player(_snip, _play_options = {})
{
	var _player = resnip_player_create();
	resnip_player_play(_player, _snip, _play_options);
	return _player;
}
