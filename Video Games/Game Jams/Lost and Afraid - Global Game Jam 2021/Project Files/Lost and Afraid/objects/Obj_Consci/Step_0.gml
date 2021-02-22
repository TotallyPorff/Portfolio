/// @description Walking Code
yVelocity = 0;
xVelocity = 0;

if (gameState == state.playing) {
	//Walking
	if (keyboard_check(ord("W"))) {
		yVelocity = Approach(yVelocity, -1, 1);
	}
	if (keyboard_check(ord("S"))) {
		yVelocity = Approach(yVelocity, 1, 1);
	}
	if (keyboard_check(ord("A"))) {
		xVelocity = Approach(xVelocity, -1, 1);
	}
	if (keyboard_check(ord("D"))) {
		xVelocity = Approach(xVelocity, 1, 1);
	}

	newX = x + xVelocity * walkSpeed;
	newY = y + yVelocity * walkSpeed;

	if (newX + (sprite_width/2) < room_width && newX + (sprite_width/2) > 0) {
		x = newX;
	}
	if (newY < room_height && newY > 0) {
		y = newY;
	}
	
	//Colliding with item
	if (collision_circle(x, y, 8, Obj_IOH, true, true) != noone) {
		itemCollide = collision_circle(x, y, 8, Obj_IOH, true, true);
		instance_destroy(itemCollide);
		circleIncrease = true;
		audio_play_sound(SFX_Grab, 0, false);
		
		//reset circle direction
		alarm[0] = 1 * room_speed;
	}
}
//Start Panicking
if (gameState == state.panicStart) {
	if (image_index >= image_number - 2) {
		gameState = state.panicking;
		sprite_index = Spr_Consci_Panic;
		image_index = 0;
	}
}
//Panic
if (gameState == state.panicking) {
	if (!instance_exists(Obj_Another)) {
		instance_create_depth(x + 240, y, -10, Obj_Another);
	}
	
	//Check if other is in range
	if (Obj_Another.x <= x + 24) {
		sprite_index = Spr_Consci_Calm;
		image_index = 0;
		gameState = state.calm;
	}
}
//Calm
if (gameState == state.calm) {
	if (image_index >= image_number - 2) {
		image_speed = 0;
		
		if (!instance_exists(Obj_FadeWhite)) {
			instance_create_depth(0, 0, -1000, Obj_FadeWhite);
		}
		
		if (Obj_FadeWhite.image_alpha == 1) {
			room = Rm_Found;
		}
	}
}