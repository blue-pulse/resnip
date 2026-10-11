function __resnip_player_reset_loops(_player)
{
	_player.__loop = __RESNIP_NO_LOOP;
	_player.__passes = array_create(array_length(_player.snip.loops), 0);
}
