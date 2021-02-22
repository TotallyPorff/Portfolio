//BOBBING
if (y <= mainYPos - 3) {
	bobDirection = "Down";	
} else if (y >= mainYPos + 3) {
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

//COLOUR FLASH
if (sat > 0) {
	sat += -5;
}
image_blend = make_color_hsv(hue, sat, 255);

//Check to see if player has inputted
if (Obj_PlyrInput.inputted) {
	//LOCKED
	if (currentStage == "Locked") {
		//Check player's input
		if (Obj_PlyrInput.input == "Bad") {
			//Lower trust if bad
			if (lockedTrust > -1) {
				lockedTrust += -1;
			}
			
		} else if (Obj_PlyrInput.input == "Neutral") {
			//Leave trust as it is if neutral
			lockedTrust += 0;
			
		} else if (Obj_PlyrInput.input == "Good") {
			//increase trust if good
			if (lockedTrust < 3) {
				lockedTrust += 1;
			}		
		}
		
		//Check if player hasn't won or lost
		if (lockedTrust >= 0 && lockedTrust <= 2) {
			//Respond
			if (!responded) {
				//Remove current text box if exists
				if (responseBox != noone) {
					instance_destroy(responseBox);
					responseBox = noone;
				}
				
				if (responseBox == noone) {
					///Create box
					responseBox = instance_create_layer(x, y, "Text", Obj_TextBox);
					
					//Chooses text that it isn't currently on
					do {
						newResp = irandom_range(0, 2);
					} until (newResp != oldResp)
					//Display new text
					responseBox.text = persArray[lockedTrust, newResp];
					oldResp = newResp;
				}
				
				responded = true;
				Obj_PlyrInput.inputted = false;
			}
			//If won locked
		} else if (lockedTrust >= 3) {
			if (!transitioned) {
				//Remove current text box if exists
				if (responseBox != noone) {
					instance_destroy(responseBox);
					responseBox = noone;
				}
				
				if (responseBox == noone) {
					///Create box
					responseBox = instance_create_layer(x, y, "Text", Obj_TextBox);
					
					//Display new text
					responseBox.text = txtTrans;
					oldResp = newResp;
				}
				
				sprite_index = Spr_HeartBroken_3;
				transitioned = true;
				alarm[0] = 450; //7.5 seconds
			}
		} else if (lockedTrust <= -1) {
			//Remove current text box if exists
			if (responseBox != noone) {
				instance_destroy(responseBox);
				responseBox = noone;
			}
			
			currentStage = "Game Over";
		}
		
		//Assign appropriated sprite
		if (lockedTrust <= -1) {
			sprite_index = Spr_HeartLocked_1;
		} else if (lockedTrust == 0) {
			sprite_index = Spr_HeartLocked_2;
		} else if (lockedTrust == 1) {
			sprite_index = Spr_HeartLocked_3;
		} else if (lockedTrust == 2) {
			sprite_index = Spr_HeartLocked_4;
		}
			
	//BROKEN
	} else if (currentStage == "Broken") {
		//Check player's input
		if (Obj_PlyrInput.input == "Bad") {
			//Lower trust if bad
			if (brokenTrust > -1) {
				brokenTrust += -1;
			}
		} else if (Obj_PlyrInput.input == "Neutral") {
			//Leave trust as it is if neutral
			brokenTrust += 0;
		} else if (Obj_PlyrInput.input == "Good") {
			//increase trust if good
			if (brokenTrust < 3) {
				brokenTrust += 1;
			}
		}
		
		//Check if player hasn't won or lost
		if (brokenTrust >= 0 && brokenTrust <= 2) {
			//Respond
			if (!responded) {
				//Remove current text box if exists
				if (responseBox != noone) {
					instance_destroy(responseBox);
					responseBox = noone;
				}
				
				if (responseBox == noone) {
					///Create box
					responseBox = instance_create_layer(x, y, "Text", Obj_TextBox);
					
					//Chooses text that it isn't currently on
					do {
						newResp = irandom_range(0, 2);
					} until (newResp != oldResp)
					//Display new text
					responseBox.text = probArray[brokenTrust, newResp];
					oldResp = newResp;
				}
				
				responded = true;
				Obj_PlyrInput.inputted = false;
			}
		} else if (brokenTrust <= -1) {
			//Remove current text box if exists
			if (responseBox != noone) {
				instance_destroy(responseBox);
				responseBox = noone;
			}
			
			currentStage = "Game Over";
		} else if (brokenTrust >= 3) {
			//Remove current text box if exists
			if (responseBox != noone) {
				instance_destroy(responseBox);
				responseBox = noone;
			}
			
			currentStage = "Heart Repaired";
		}
		
		//Assign appropriated sprite
		if (brokenTrust <= -1) {
			sprite_index = Spr_HeartBroken_1;
		} else if (brokenTrust == 0) {
			sprite_index = Spr_HeartBroken_2;
		} else if (brokenTrust == 1) {
			sprite_index = Spr_HeartBroken_3;
		} else if (brokenTrust == 2) {
			sprite_index = Spr_HeartBroken_4;
		} else if (brokenTrust >= 3) {
			sprite_index = Spr_HeartBroken_5;
		}
	}
}

//End states
if (currentStage == "Game Over") {
	//Create game over text
	if (endState == noone) {
		instance_create_layer(room_width / 2, room_height / 2, "Text", Obj_GameOver);
	}
	
	//Create restart box
	if (responseBox == noone) {
		//Create box
		responseBox = instance_create_layer(x, endBoxY, "Text", Obj_InptBox);
		responseBox.text = "Press 'R' to restart, or 'esc' to exit!"
	}
	
} else if (currentStage == "Heart Repaired") {
	//Create game over text
	if (endState == noone) {
		instance_create_layer(room_width / 2, room_height / 2, "Text", Obj_HeartRepaired);
	}
	
	//Create restart box
	if (responseBox == noone) {
		//Create box
		responseBox = instance_create_layer(x, endBoxY, "Text", Obj_InptBox);
		responseBox.text = "Press 'R' to restart, or 'esc' to exit!"
	}
}

//Restart/end game
if (keyboard_check_pressed(ord("R"))) {
	room = Rm_Start;
} else if (keyboard_check_pressed(vk_escape)) {
	game_end();
}