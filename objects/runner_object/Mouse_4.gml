/// @description Mouse click flip
var _shift = keyboard_check(vk_shift);
if (snip_is_playing(runner_snip_holder.left_snip, true))
{
	if (_shift)
	{
		snip_play(runner_snip_holder.right_snip, true);
		my_player.snip_play(runner_snip_holder.right_snip, true);
	}
	else
	{
		snip_play_next(runner_snip_holder.right_snip, true);
		my_player.snip_play_next(runner_snip_holder.right_snip, true);
	}
}
else
{
	if (_shift)
	{
		snip_play(runner_snip_holder.left_snip, true);
		my_player.snip_play(runner_snip_holder.left_snip, true);
	}
	else
	{
		snip_play_next(runner_snip_holder.left_snip, true);
		my_player.snip_play_next(runner_snip_holder.left_snip, true);
	}
}