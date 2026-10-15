/// @description Draw the debug panel, the instance and the copies
// Debug panel and instance
resnip_debug_draw(main_player, 0, y + 64);
draw_self();

// Copies
resnip_draw(copy_player, x + 64, y);
resnip_draw(copy_player, x - 64, y);
