/// @description Insert description here
// You can write your code in this editor
snip_draw_debug(0, y + 64);
draw_self();

my_player.draw_ext(x+64,y, image_xscale, image_yscale, image_angle, c_white, 1);
my_player.draw_ext(x-64,y, image_xscale, image_yscale, image_angle, c_white, 1);