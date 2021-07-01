/// @description Set player inputs
if (managerID != noone && !inputsAreSet) {
	
	/* -- KEYBOARD -- */
	//Check a player isnt already using keyboard
	if (!keyboardInputSet) {
		
		//check if any key is pressed
		if (keyboard_check_pressed(vk_anykey)) {
			
			//Set appropriate player to use keyboard
			player = ds_list_find_value(managerID.playerIDList, inputsSet);
			player.defaultKeyBinds();
			
			//Adjust variables
			keyboardInputSet = true;
			inputsSet += 1;
		}
	}
	
	/* -- CONTROLLER -- */
	//Loop through connected devices/Slots
	for (var i = 0; i < gamepad_get_device_count(); i++) {
		
		//Make sure they are connected
		if (gamepad_is_connected(i)) {
			
			//Check if the start key is pressed
			if (gamepad_button_check_pressed(i, gp_start)) {
				
				//Make sure that controller isn't controlling a different character
				isBeingUsed = false;
				
				//Loop through players
				for (var j = 0; j < managerID.noOfPlayers; j++) {
					player = ds_list_find_value(managerID.playerIDList, j);
					//If player has same index, its being used
					if (player.controllerIndex == i) isBeingUsed = true;
				}
				
				if (!isBeingUsed) {//Controller isn't being used
					//Set player to use controller
					player = ds_list_find_value(managerID.playerIDList, inputsSet);
					player.controllerIndex = i;
					player.isController = true;
					player.defaultControllerBinds();
					
					//Adjust variables
					inputsSet += 1;
				}
			}
		}
	}
	
	//Check if all inputs are set
	if (inputsSet >= managerID.noOfPlayers) {
		inputsAreSet = true;
	}
}