//PLAY MUSIC
if (!audio_is_playing(Snd_BackgroundMusic)) {
	audio_play_sound(Snd_BackgroundMusic, 0, true);
}

//BOBBING
if (y <= mainYPos - 5) {
	bobDirection = "Down";	
} else if (y >= mainYPos + 5) {
	bobDirection = "Up";
}

if (bobDirection == "Up") {
	if (bobMoment > -0.5) {
		bobMoment += -0.01;
	}
} else if (bobDirection == "Down") {
	if (bobMoment < 0.5) {
		bobMoment += 0.01;
	}
}

y += bobMoment;

//Start
if (position_meeting(mouse_x, mouse_y, startButton)) {
	startButton.image_index = 1;
	if (mouse_check_button_pressed(mb_left)) {
		room = Rm_Heart;
	}
} else {
	startButton.image_index = 0;
}

//End game
if (keyboard_check_pressed(vk_escape)) {
	game_end();
}