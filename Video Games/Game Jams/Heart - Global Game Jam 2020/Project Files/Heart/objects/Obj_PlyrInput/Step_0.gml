//Check for player input
if (position_meeting(mouse_x, mouse_y, badInput)) {
	badInput.image_index = 1;
	if (mouse_check_button_pressed(mb_left)) {
		//Check if player is yet to input
		if (!inputted) {
			inputted = true;
			if (Obj_Heart.responded) {
				Obj_Heart.responded = false;
			}
		}
		//Set colour flash
		Obj_Heart.hue = 0;
		Obj_Heart.sat = 255;
		
		audio_play_sound(Snd_BadResponse, 1, false);
		
		//Set input
		input = "Bad";
	}
} else {
	badInput.image_index = 0;
}

if (position_meeting(mouse_x, mouse_y, neutralInput)) {
	neutralInput.image_index = 1;
	if (mouse_check_button_pressed(mb_left)) {
		//Check if player is yet to input
		if (!inputted) {
			inputted = true;
			if (Obj_Heart.responded) {
				Obj_Heart.responded = false;
			}
		}
		
		//Set colour flash
		Obj_Heart.hue = 50;
		Obj_Heart.sat = 255;
		
		audio_play_sound(Snd_NeutralResponse, 1, false);
		
		//Set input
		input = "Neutral";
	}
} else {
	neutralInput.image_index = 0;
}

if (position_meeting(mouse_x, mouse_y, goodInput)) {
	goodInput.image_index = 1;
	if (mouse_check_button_pressed(mb_left)) {
		//Check if player is yet to input
		if (!inputted) {
			inputted = true;
			if (Obj_Heart.responded) {
				Obj_Heart.responded = false;
			}
		}
		
		//Set colour flash
		Obj_Heart.hue = 120;
		Obj_Heart.sat = 255;
		
		audio_play_sound(Snd_GoodResponse, 1, false);
		
		//Set input
		input = "Good";
	}
} else {
	goodInput.image_index = 0;
}

//Moving buttons
if (!shownInputs && !inputted) {
	//Find spot for badInput
	foundSpot = false;
	while(!foundSpot) {
		chooseSpot = irandom_range(0, 2);
		if (chooseSpot == 0) {
			if (!position_meeting(spot1X, spot1Y, Obj_InptBox)) {
				badInput.x = spot1X;
				badInput.y = spot1Y;
				foundSpot = true;
			}
		} else if (chooseSpot == 1) {
			if (!position_meeting(spot2X, spot2Y, Obj_InptBox)) {
				badInput.x = spot2X;
				badInput.y = spot2Y;
				foundSpot = true;
			}
		} else if (chooseSpot == 2) {
			if (!position_meeting(spot3X, spot3Y, Obj_InptBox)) {
				badInput.x = spot3X;
				badInput.y = spot3Y;
				foundSpot = true;
			}
		}
	}
	//Find spot for neutralInput
	foundSpot = false;
	while(!foundSpot) {
		chooseSpot = irandom_range(0, 2);
		if (chooseSpot == 0) {
			if (!position_meeting(spot1X, spot1Y, Obj_InptBox)) {
				neutralInput.x = spot1X;
				neutralInput.y = spot1Y;
				foundSpot = true;
			}
		} else if (chooseSpot == 1) {
			if (!position_meeting(spot2X, spot2Y, Obj_InptBox)) {
				neutralInput.x = spot2X;
				neutralInput.y = spot2Y;
				foundSpot = true;
			}
		} else if (chooseSpot == 2) {
			if (!position_meeting(spot3X, spot3Y, Obj_InptBox)) {
				neutralInput.x = spot3X;
				neutralInput.y = spot3Y;
				foundSpot = true;
			}
		}
	}
	//Find spot for goodInput
	foundSpot = false;
	while(!foundSpot) {
		chooseSpot = irandom_range(0, 2);
		if (chooseSpot == 0) {
			if (!position_meeting(spot1X, spot1Y, Obj_InptBox)) {
				goodInput.x = spot1X;
				goodInput.y = spot1Y;
				foundSpot = true;
			}
		} else if (chooseSpot == 1) {
			if (!position_meeting(spot2X, spot2Y, Obj_InptBox)) {
				goodInput.x = spot2X;
				goodInput.y = spot2Y;
				foundSpot = true;
			}
		} else if (chooseSpot == 2) {
			if (!position_meeting(spot3X, spot3Y, Obj_InptBox)) {
				goodInput.x = spot3X;
				goodInput.y = spot3Y;
				foundSpot = true;
			}
		}
	}
	
	//Assigns appropriate text to each box
	if (Obj_Heart.currentStage == "Locked") {
		if (Obj_Heart.lockedTrust >= 0 && Obj_Heart.lockedTrust <= 2) {
			//Calculates what the first element is in the persRespArray relative to the heart's response
			hrtRspIndx = (Obj_Heart.lockedTrust * 3) + Obj_Heart.newResp;
			//Changes text to appropriate buttons
			badInput.text = persRespArray[hrtRspIndx, 0];
			badInput.charCount = 0;
			neutralInput.text = persRespArray[hrtRspIndx, 1];
			neutralInput.charCount = 0;
			goodInput.text = persRespArray[hrtRspIndx, 2];
			goodInput.charCount = 0;
		}
	} else if (Obj_Heart.currentStage == "Broken") {
		if (Obj_Heart.brokenTrust >= 0 && Obj_Heart.brokenTrust <= 2) {
			//Calculates what the first element is in the persRespArray relative to the heart's response
			hrtRspIndx = (Obj_Heart.brokenTrust * 3) + Obj_Heart.newResp;
			//Changes text to appropriate buttons
			badInput.text = probRespArray[hrtRspIndx, 0];
			badInput.charCount = 0;
			neutralInput.text = probRespArray[hrtRspIndx, 1];
			neutralInput.charCount = 0;
			goodInput.text = probRespArray[hrtRspIndx, 2];
			goodInput.charCount = 0;
		}
	}
	
	shownInputs = true;
	
} else if (inputted) {
	shownInputs = false;
	//Moves all buttons off screen
	badInput.x = -200;
	badInput.y = -200;
	neutralInput.x = -200;
	neutralInput.y = -200;
	goodInput.x = -200;
	goodInput.y = -200;
}