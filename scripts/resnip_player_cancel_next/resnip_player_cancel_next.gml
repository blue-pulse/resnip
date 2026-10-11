/// @func resnip_player_cancel_next(player)
/// @desc Drops the snip queued by resnip_player_play. While a transition plays, the snip it leads to stays, since that is where the player was going.
/// @param {Struct} player The player to change
function resnip_player_cancel_next(_player) {
	_player.__queue = undefined;
	_player.__queue_transition = false;
}
