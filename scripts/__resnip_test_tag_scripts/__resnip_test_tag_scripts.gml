function __resnip_test_tag_scripts(_log, _frames) {
	var _scripts = [];
	for (var _i = 0; _i < array_length(_frames); _i++) {
		array_push(_scripts, { frame: _frames[_i], callback: __resnip_test_log_tag, argument: { log: _log, tag: "f" + string(_frames[_i]) } });
	}
	return _scripts;
}
