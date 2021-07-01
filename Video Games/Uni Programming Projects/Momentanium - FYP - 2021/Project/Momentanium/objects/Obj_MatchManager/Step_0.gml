/// @description Managing the match

//End and restart buttons
if (keyboard_check_pressed(vk_escape)) {
	game_end();
}
if (keyboard_check_pressed(ord("R"))) {
	game_restart();
}

//Make sure match is still going
if (!isMatchOver) {
	//Checking how many players have stocks left
	alivePlayers = 0;
	for (var i = 0; i < noOfPlayers; i++) {	
		
		//Increase alive players if current player has 1 or more stocks
		currentChar = ds_list_find_value(playerIDList, i);
		if (currentChar.currentStocks > 0) {
			alivePlayers += 1;
		}
	}

	//If only on player is left alive
	if (alivePlayers <= 1) {
		//Find out whos the last one
		for (var i = 0; i < noOfPlayers; i++) {
		
			//Grab player ID
			currentChar = ds_list_find_value(playerIDList, i);
			//Check if alive
			if (currentChar.currentStocks > 0) {
				winner = currentChar;
				winnerNumber = i + 1;
				isMatchOver = true;
			}
		}
	}
}