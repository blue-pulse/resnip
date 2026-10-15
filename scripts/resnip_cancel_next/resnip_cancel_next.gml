/// @func resnip_cancel_next(player)
/// @desc Drops the snip queued by resnip_play. While a transition plays, the snip it leads to stays, since that is where the player was going.
/// @param {Struct} player The player to change
function resnip_cancel_next(_player) {
	_player.__queue = undefined;
	_player.__queue_transition = false;
	_player.__queue_backward = false;
}
