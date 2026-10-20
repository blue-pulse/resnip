function __resnip_test_make(_first, _last, _options = {}) {
	return resnip_snip_create(spr_red_cowboy_full, __resnip_options_merge({ first_image: _first, last_image: _last }, _options));
}
