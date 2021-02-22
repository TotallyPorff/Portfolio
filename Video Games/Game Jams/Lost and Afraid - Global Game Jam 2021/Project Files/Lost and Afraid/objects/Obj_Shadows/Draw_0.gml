gpu_set_blendmode(bm_subtract);
draw_surface(light, view_xport[0], view_yport[0]);
gpu_set_blendmode(bm_normal);