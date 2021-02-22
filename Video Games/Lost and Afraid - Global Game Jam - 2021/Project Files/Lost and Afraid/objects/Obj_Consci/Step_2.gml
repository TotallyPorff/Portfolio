/// @description Light Code
if (gameState == state.playing) {
	if (circleIncrease) {
		lightRadius = Approach(lightRadius, 200, 16 / room_speed);
	} else {
		lightRadius = Approach(lightRadius, 32, 4 / room_speed);
	}
	
	//Change state
	if (lightRadius <= 32) {
		gameState = state.panicStart;
		instance_destroy(Obj_Spikes);
		sprite_index = Spr_Consci_PanicStart;
		image_index = 0;
		image_xscale = 1;
	}
}

gpu_set_blendmode(bm_subtract);
surface_set_target(light);
draw_ellipse_color(x - lightRadius, y - lightRadius, x + lightRadius, y + lightRadius, c_white, c_black, false);
surface_reset_target();
gpu_set_blendmode(bm_normal);
