/// @description Manage music
if (room == Rm_Main) {
	if (mainMusicVol != 1) {
		mainMusicVol = Approach(mainMusicVol, 1, 0.5 / room_speed);
		audio_sound_gain(mainMusic, mainMusicVol, 0);
	}
	
	if (!Obj_GameManager.generateSmoke) {
		audio_stop_sound(mainMusic);
	}
}

if (room == Rm_Darkness) {
	//check state
	if (Obj_Consci.gameState == state.calm) {
		//Fade out all sounds
		softPianoVol = Approach(softPianoVol, 0, 0.15 / room_speed);
		stringsVol = Approach(stringsVol, 0, 0.15 / room_speed);
		sawBassVol = Approach(sawBassVol, 0, 0.20 / room_speed);
		sqrBassVol = Approach(sqrBassVol, 0, 0.25 / room_speed);
		kickVol = Approach(kickVol, 0, 0.30 / room_speed);
		whisperVol = Approach(whisperVol, 0, 0.20 / room_speed);
	} else {
		//Adjust strings volume
		if (Obj_Consci.lightRadius - 125 >= 0) {
			stringsVol = 1 - (((Obj_Consci.lightRadius - 125) * 2) / 100);
		}
		//Adjust sawBass Volume
		if (Obj_Consci.lightRadius - 75 >= 0) {
			sawBassVol = 1 - (((Obj_Consci.lightRadius - 75) * 2) / 100);
		}
		//Adjust sqrBass Volume
		if (Obj_Consci.lightRadius - 25 >= 0) {
			sqrBassVol = 1 - (((Obj_Consci.lightRadius - 25) * 2) / 100);
		}
		//Adjust kick Volume
		if (Obj_Consci.lightRadius - 25 >= 0) {
			kickVol = 1 - (((Obj_Consci.lightRadius - 25) * 1) / 100);
		}
		//Adjust whisper Volume
		if (Obj_Consci.lightRadius - 50 >= 0) {
			whisperVol = 1 - (((Obj_Consci.lightRadius - 50) * 1) / 100);
		}
	}
	
	//Apply to respective indexes
	audio_sound_gain(softPiano, softPianoVol, 0);
	audio_sound_gain(strings, stringsVol, 0);
	audio_sound_gain(sawBass, sawBassVol, 0);
	audio_sound_gain(sqrBass, sqrBassVol, 0);
	audio_sound_gain(kick, kickVol, 0);
	audio_sound_gain(whisper, whisperVol, 0);
}