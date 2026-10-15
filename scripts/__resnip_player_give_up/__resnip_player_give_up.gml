function __resnip_player_give_up(_player) {
	show_debug_message("[WARNING] A player holds its last frame because loops with a count below 0 skip every frame of its snip. Give a loop a count of 0 or above, or leave a frame outside the loops.");
	_player.frame = (_player.direction > 0) ? _player.snip.count - 1 : 0;
	_player.stopped = true;
}
