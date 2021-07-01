/// @description Manage Animations

/* -- MOVEMENT ANIMATIONS -- */
//If not attacking
if (currentAttackState == attackState.idle) {
	
	//If being hit
	if (hitCooldown) {
		//Check if not in air
		if (touchingFloor) {
			//Set to hit variable
			sprite_index = asset_get_index(charName + "Hit");
		} else {
			//Set to hit variable
			sprite_index = asset_get_index(charName + "HitInAir");
		}
		
	} else {
		//Set Direction
		if (hInput != 0) {
			image_xscale = hInput;
		}

		//if touching the floor
		if (touchingFloor) {
			//if moving
			if (hSpeed != 0) {
				//Check for input
				if (hInput != 0) {
					//Running sprite
					sprite_index = asset_get_index(charName + "Running");
				} else {
					//Stopping Sprite
					sprite_index = asset_get_index(charName + "Stopping");
				}
			} else {
				//Idle sprite
				sprite_index = asset_get_index(charName + "Idle");
			}
		} else {	
			//if wallhanging
			if (touchingWall) {
				//Wallhang sprite
				sprite_index = asset_get_index(charName + "Wallhang");
			}
			//Jumping or Falling
			else {
				if (vSpeed <= 0) {
					//Jumping sprite
					sprite_index = asset_get_index(charName + "Jumping");
				} else {
					//Falling sprite
					sprite_index = asset_get_index(charName + "Falling");
				}
			}
		}
	}
}

/* -- EFFECTS -- */
//Check if invincible
if (isInvincible) image_blend = make_color_rgb(144, 240, 169); //Flash Bright Green for dodge
else if (hitCooldown) image_blend = make_color_rgb(255, 100, 100); //Flash Red for being hit
else image_blend = c_white;

//Fade with Cooldown
if (!canDodge && !isInvincible) {
	if (fadeOut) {
		image_alpha = Approach(image_alpha, 0, 0.25);
		//Check for switch
		if (image_alpha == 0) fadeOut = false;
	} else {
		image_alpha = Approach(image_alpha, 1, 0.25);
		//Check for switch
		if (image_alpha == 1) fadeOut = true;
	}
} else {
	image_alpha = 1;
}

draw_self();