/// @description Adjust camera to fit all players in

/* -- CAMERA POSITION -- */
//Reset average pos
averageXPos = 0;
averageYPos = 0;
existingChars = 0;

//Calculate average positions of all players
for (var i = 0; i < ds_list_size(playerChars); i++) {
	
	//Check if instance exists
	playerCharID = ds_list_find_value(playerChars, i);
	if (instance_exists(playerCharID)) {
		//If player isnt dead
		if (!playerCharID.isDead) {
			existingChars += 1;
		
			//Add up positions
			averageXPos += playerCharID.x;
			averageYPos += playerCharID.y;
		}
	}
}
//Add centre of room to average pos
existingChars += 1;
averageXPos += cameraXCentre;
averageYPos += cameraYCentre;
//Finish average calculation
averageXPos = averageXPos / existingChars;
averageYPos = averageYPos / existingChars;

//Set camera target
cameraXTarget = averageXPos;
cameraYTarget = averageYPos;

/* -- CAMERA SIZE -- */
//Reset max distance differences
maxDistDiffX = 0;
maxDistDiffY = 0;

//Find the maximum distance differences between characters
for (var i = 0; i < ds_list_size(playerChars); i++) {
	for (var j = 0; j < ds_list_size(playerChars); j++) {
		
		//Check i and j aren't the same
		if (i != j) {
			
			//Grab instances
			char1 = ds_list_find_value(playerChars, i);
			char2 = ds_list_find_value(playerChars, j);
			
			//Make sure both are alive
			if (!char1.isDead && !char2.isDead) {
			
				//Check both instances exist
				if (instance_exists(char1) && instance_exists(char2)) {
			
					//Grab the distance between both instances, making sure it is the absolute value
					distDiffX = abs(char1.x - char2.x);
					distDiffY = abs(char1.y - char2.y);
				
					//Check if they are the new max difference
					if (distDiffX > maxDistDiffX) maxDistDiffX = distDiffX;
					if (distDiffY > maxDistDiffY) maxDistDiffY = distDiffY;
			
				}
			}
		}		
	}
}

//calculate border size assuming that maxDistDiff + borderSize = 100% size
borderXSize = maxDistDiffX / (100 - borderPerc) * borderPerc;
borderYSize = maxDistDiffY / (100 - borderPerc) * borderPerc;

//Set camera size to new size
cameraWidth = maxDistDiffX + borderXSize;
cameraHeight = maxDistDiffY + borderYSize;

//Camera Size too big
if (cameraWidth >= cameraWidthMax || cameraHeight >= cameraHeightMax) {
	cameraWidth = cameraWidthMax;
	cameraHeight = cameraHeightMax;
	
} else if (cameraWidth <= cameraWidthMin) { //Camera Size too small
	cameraWidth = cameraWidthMin;
	cameraHeight = cameraHeightMin;
	
} else { //Adjust to aspect ratio 16:9
	
	//Check ratio isn't perfect and has too small of a height
	if (cameraWidth / 16 > cameraHeight / 9) {
		cameraHeight = 9 * (cameraWidth / 16); //Set cameraHeight to correct multiple of 9
	} else if (cameraWidth / 16 < cameraHeight / 9) { //Too small of a width
		cameraWidth = 16 * (cameraHeight / 9); //Set cameraWidth to correct multiple of 16
	}
	
}

//Adjust camera position if it is showing outside of the stage
cameraBorderRight = cameraXTarget + (cameraWidth / 2);
cameraBorderLeft = cameraXTarget - (cameraWidth / 2);
cameraBorderBottom = cameraYTarget + (cameraHeight / 2);
cameraBorderTop = cameraYTarget - (cameraHeight / 2);

//For X & width
if (cameraBorderRight > maxBorderRight) { //Too far right
	cameraXTarget -= cameraBorderRight - maxBorderRight; //Move camera to left
	
} else if (cameraBorderLeft < maxBorderLeft) { //Too far left
	cameraXTarget += maxBorderLeft - cameraBorderLeft; //Move camera to right
	
}
//For Y & height
if (cameraBorderBottom > maxBorderBottom) { //Too far down
	cameraYTarget -= cameraBorderBottom - maxBorderBottom; //Move camera up
	
} else if (cameraBorderTop < maxBorderTop) { //Too far up
	cameraYTarget += maxBorderTop - cameraBorderTop;
	
}

/* -- APPLY POS AND SIZE -- */
x = Approach(x, cameraXTarget, cameraSpeed);
y = Approach(y, cameraYTarget, cameraSpeed);
camera_set_view_size(cameraID, cameraWidth, cameraHeight);