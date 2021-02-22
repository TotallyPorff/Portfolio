surface_set_target(light);
draw_set_color(make_color_rgb(255, 255, 255));
draw_rectangle(0, 0, view_wport[0], view_hport[0], false);
surface_reset_target();