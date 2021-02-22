/// @description yes

//Organise Animation
if (xVelocity != 0 || yVelocity != 0) {
	sprite_index = Spr_Consci_Walk;
	//Play footsteps
	if (!audio_is_playing(footsteps)) {
		footsteps = audio_play_sound(footsteps, 0, true);
	}
} else {
	sprite_index = Spr_Consci_Idle;
	//stop footsteps
	if (audio_is_playing(footsteps)) {
		audio_stop_sound(footsteps);
	}
}

if (xVelocity > 0) {
	image_xscale = 1;
} else if (xVelocity < 0) {
	image_xscale = -1;
}

//draw shade
if (image_xscale == 1) {
	draw_sprite_ext(Spr_Shade, 0, x + 1, y + 16, 1, 1, 0, c_white, 1);
} else {
	draw_sprite_ext(Spr_Shade, 0, x - 1, y + 16, -1, 1, 0, c_white, 1);
}

draw_self()