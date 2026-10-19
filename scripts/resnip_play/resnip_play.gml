/// @func resnip_play(playback, snip, [options])
/// @desc Plays a snip on a playback now, or queues it for when the current one completes. The queue, the target of a transition and the next of a snip all answer what plays next, in that order. It replaces setting sprite_index and image_index by hand, and it covers snip_play, snip_play_next and snip_play_request of AESnips. A transition plays in its own direction, and the snip it leads to plays in the direction asked.
/// @param {Struct} playback The playback that plays it
/// @param {Struct} snip The snip to play
/// @param {Struct} [options] Optional fields: transition (look for a transition from the current snip, default false), queue (wait for the current snip to complete, default false), restart (play even if it already plays, default true), backward (play from its last frame down, default false)
/// @returns {Bool} Whether the playback started it or queued it
function resnip_play(_playback, _snip, _options = {}) {
	// Options
	var _transition = _options[$ "transition"] ?? false;
	var _queue = _options[$ "queue"] ?? false;
	var _restart = _options[$ "restart"] ?? true;
	var _backward = _options[$ "backward"] ?? false;

	// Prevent a restart when asked not to
	var _playing = (_playback.snip == _snip && !_playback.stopped) || _playback.__target == _snip;
	if (!_restart && _playing) {
		return false;
	}

	// Queue for later
	if (_queue && _playback.snip != undefined && !_playback.stopped) {
		_playback.__queue = _snip;
		_playback.__queue_transition = _transition;
		_playback.__queue_backward = _backward;
		return true;
	}

	// Transition
	var _use = _snip;
	var _target = undefined;
	var _target_backward = _backward;
	var _from = _playback.__target ?? _playback.snip;
	if (_transition && _from != undefined) {
		var _found = resnip_transition_find(_from, _snip);
		if (_found != undefined) {
			_use = _found.use;
			_target = _snip;
			_backward = _found.backward;
		}
	}

	// Reset the state
	if (_use != _playback.snip) {
		_playback.__frame_speeds = _use.frame_speeds;
		_playback.__own_frame_speeds = false;
	}
	_playback.snip = _use;
	_playback.direction = _backward ? RESNIP_BACKWARD : RESNIP_FORWARD;
	_playback.frame = _backward ? _use.count - 1 : 0;
	_playback.stopped = false;
	_playback.__progress = 0;
	_playback.__queue = undefined;
	_playback.__queue_transition = false;
	_playback.__queue_backward = false;
	_playback.__target = _target;
	_playback.__target_backward = _target_backward;
	_playback.__serial += 1;
	_playback.__skips = 0;
	__resnip_playback_reset_loops(_playback);
	__resnip_playback_enter(_playback);
	return true;
}
