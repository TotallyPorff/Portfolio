//Restart and End
if (keyboard_check_pressed(ord("R"))) {
	//prevent restarting during cutscene
	if (room == Rm_Darkness && instance_exists(Obj_Consci)) {
		if (Obj_Consci.gameState == state.playing) {
			game_restart();
		}
	} else {
		game_restart();
	}
}
if (keyboard_check_pressed(vk_escape)) {
	game_end();
}

//Do things depending on room
if (room == Rm_Darkness) {
	if (instance_number(Obj_IOH) < numberOfItems) {
		instance_create_depth(0, 0, -1, Obj_IOH);
	}
}

if (room == Rm_Main) {
	if (keyboard_check_pressed(vk_space)) {
		//Stop Smoke
		generateSmoke = false;
		instance_destroy(Obj_Smoke);
		
		//Remove all objects
		instance_destroy(Obj_Controls);
		instance_destroy(Obj_GameTitle);
		instance_destroy(Obj_Start);
		
		//Clear text
		bottomText = "";
		SaveHighscore = "";
		SavePrevious = "";
		
		//play click sfx
		audio_play_sound(SFX_Button, 5, false);
		
		//switch rooms
		alarm[1] = 1 * room_speed;
	}
}