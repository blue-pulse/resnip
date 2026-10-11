function __resnip_snip_build_frame_scripts(_entries, _count)
{
	var _scripts = array_create(_count, undefined);
	for (var _i = 0; _i < array_length(_entries); _i++)
	{
		var _entry = _entries[_i];
		__resnip_check_frame(_entry.frame, _count, "resnip_snip_create frame_scripts");
		if (!is_callable(_entry.callback))
		{
			__resnip_error("resnip_snip_create frame_scripts received a callback for frame " + string(_entry.frame) + " that cannot be called. Pass a function or a method.");
		}
		if (_scripts[_entry.frame] != undefined)
		{
			__resnip_error("resnip_snip_create frame_scripts has two scripts for frame " + string(_entry.frame) + ". A frame holds one script, so merge them into one callback.");
		}
		_scripts[_entry.frame] = { callback: _entry.callback, argument: _entry[$ "argument"] };
	}
	return _scripts;
}
