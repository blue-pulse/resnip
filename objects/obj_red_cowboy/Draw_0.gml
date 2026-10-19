/// @description Draw the debug panel, the instance and the copies
// Debug panel and instance
resnip_debug_draw(main_playback, 0, y + 64);
draw_self();

// Copies
resnip_draw_ext(copy_playback, x + 64, y, image_xscale, image_yscale, image_angle, c_white, 1);
resnip_draw_ext(copy_playback, x - 64, y, image_xscale, image_yscale, image_angle, c_white, 1);
