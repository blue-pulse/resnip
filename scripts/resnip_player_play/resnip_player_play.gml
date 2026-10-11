/// @func resnip_player_play(player, snip, [options])
/// @desc Plays a snip on a player now, or queues it for when the current one completes. The queue, the target of a transition and the next of a snip all answer what plays next, in that order. It replaces setting sprite_index and image_index by hand.
/// @param {Struct} player The player that plays it
/// @param {Struct} snip The snip to play
/// @param {Struct} [options] Optional fields: transition (look for a transition from the current snip, default false), queue (wait for the current snip to complete, default false), restart (play even if it already plays, default true), backward (play from its last frame down, default false)
/// @returns {Bool} Whether the player started it or queued it
function resnip_player_play(_player, _snip, _options = {})
{
	var _transition = _options[$ "transition"] ?? false;
	var _queue = _options[$ "queue"] ?? false;
	var _restart = _options[$ "restart"] ?? true;
	var _backward = _options[$ "backward"] ?? false;

	var _playing = (_player.snip == _snip && !_player.stopped) || _player.__target == _snip;
	if (!_restart && _playing)
	{
		return false;
	}

	if (_queue && _player.snip != undefined && !_player.stopped)
	{
		_player.__queue = _snip;
		_player.__queue_transition = _transition;
		return true;
	}

	var _use = _snip;
	var _target = undefined;
	var _from = _player.__target ?? _player.snip;
	if (_transition && _from != undefined)
	{
		var _found = resnip_transition_find(_from, _snip);
		if (_found != undefined)
		{
			_use = _found.use;
			_target = _snip;
			_backward = _found.backward;
		}
	}

	_player.snip = _use;
	_player.direction = _backward ? RESNIP_BACKWARD : RESNIP_FORWARD;
	_player.frame = _backward ? _use.count - 1 : 0;
	_player.stopped = false;
	_player.__progress = 0;
	_player.__queue = undefined;
	_player.__queue_transition = false;
	_player.__target = _target;
	_player.__start_direction = _player.direction;
	_player.__serial += 1;
	__resnip_player_reset_loops(_player);
	__resnip_player_enter(_player);
	return true;
}
