/// @description Draw indicators

//Loop through players
for (var i = 0; i < noOfPlayers; i++) {
	//Grab player ID
	currentID = ds_list_find_value(playerIDList, i);
	
	if (!currentID.isDead) {
		
		//Get position
		indicatorX = currentID.x;
		indicatorY = currentID.y - 32;
		
		//Get indicator
		indicatorSprite = asset_get_index("Spr_IndicatorPlayer" + string(i + 1));
		
		//Draw
		draw_sprite(indicatorSprite, 0, indicatorX, indicatorY);
	}
}
