/// @func resnip_snip_set_next(snip, next)
/// @desc Sets the snip that plays after this one completes. It is the only change allowed to a snip, and only during setup, because a snip cannot name another snip that does not exist yet as in A to B to A. It has no native equivalent.
/// @param {Struct} snip The snip to change
/// @param {Struct} next The snip to play after it, or undefined for none
function resnip_snip_set_next(_snip, _next) {
	if (_next != undefined && !is_struct(_next))
	{
		__resnip_error("resnip_snip_set_next received a next that is not a snip. Pass the result of resnip_snip_create, or undefined for none.");
	}
	_snip.next = _next;
	_snip.__options.next = _next;
}
