///@description Set Variables & functions

// Inherit the parent event
event_inherited();

//Animation Variables
charName = "Empty";
fadeOut = false;

//Attack Keyboard Input
normAttckKey = 0;
specAttckKey = 0;

//Attack Controller Input
normAttckContr = 0;
specAttckContr = 0;

//Input functions
function resetControls() {
	inputValue = vk_control + ord(">") + ord("E") + ord("Y") + vk_backspace + ord("C");
	
	inpLeftKey = inputValue;
	inpRightKey = inputValue;
	inpUpKey = inputValue;
	inpDownKey = inputValue;
	inpJumpKey = inputValue;
	inpDodgeKey = inputValue;
	normAttckKey = inputValue;
	specAttckKey = inputValue;
}
function defaultControllerBinds() {
	//Set deadzone
	gamepad_set_axis_deadzone(controllerIndex, contrDeadzone);
	
	inpJumpContr = gp_face1;
	inpDodgeContr = gp_face2;
	normAttckContr = gp_face3;
	specAttckContr = gp_face4;
}
function defaultKeyBinds() {
	inpLeftKey = ord("A");
	inpRightKey = ord("D");
	inpUpKey = ord("W");
	inpDownKey = ord("S");
	inpJumpKey = vk_space;
	inpDodgeKey = vk_shift;
	normAttckKey = ord("J");
	specAttckKey = ord("K");
}

//Hitbox Variables
hitbox = noone;
beenHitBy = ds_list_create();
hitboxesCreated = ds_list_create();

//Grab Attack Structures
baseAttacks = new DefaultieAttacks();
neutralAttack = baseAttacks.neutralAttack;
sideAttack = baseAttacks.sideAttack;
downAttack = baseAttacks.downAttack;
//AerialAttacks
neutralAir = baseAttacks.neutralAir;
sideAir = baseAttacks.sideAir;
downAir = baseAttacks.downAir;

//Health & Knockback
maxHealth = 100;
currentPermHealth = maxHealth; //Current health + permanent Damage
currentHealth = maxHealth; //Current health + permanent + combo damage
regenRate = 3;

function takeDamage(permDamage, comboDamage) {
	if (!isInvincible) {
		//Deal Perm Damage to the character
		currentPermHealth = Approach(currentPermHealth, 0, permDamage);	
		//Deal combo damage
		currentHealth = Approach(currentHealth, 0, comboDamage + permDamage);
	}
}
function takeKnockback(xKnockback, yKnockback) { //Parameters are the max knockback dealt
	if (!isInvincible) {
		//Set knockback based on knockback power and current % of health
		hSpeed = xKnockback * ((maxHealth * 2 - currentHealth) / maxHealth);
		vSpeed = yKnockback * ((maxHealth * 2 - currentHealth) / maxHealth);
	}
}

/* -- ATTACK FUNCTIONS -- */
function attackSprite(attackStruct) {
	
	//Set sprite index to correct attack
	if (sprite_index != asset_get_index(charName + attackStruct.attackName)) {
		image_index = 0;
		sprite_index = asset_get_index(charName + attackStruct.attackName);
	}
	
	//Create Hitboxes for object
	//Check if all hitboxes have been made
	if (ds_list_size(hitboxesCreated) < attackStruct.numOfAttacks) {
		
		//Check if none of the hitboxes have been made
		if (ds_list_empty(hitboxesCreated)) {
			
			//Loop through all attack hitboxes and make them
			for (currentHB = 1; currentHB <= attackStruct.numOfAttacks; currentHB++) {
				
				//Create hitbox
				hitbox = instance_create_depth(x, y, 250, Obj_AttackHitbox);
				hitbox.sprite_index = asset_get_index(charName + attackStruct.attackName + "_Hitbox" + string(currentHB));
				
				//Set its variables
				hitbox.image_xscale = image_xscale;
				hitbox.hitboxCreator = id;
				hitbox.attackStats = attackStruct;
				
				//Set whether it does knockback
				if (attackStruct.KBOnLast == true) {
					
					//If last hitbox
					if (currentHB == attackStruct.numOfAttacks) {
						hitbox.dealKnockback = true;
					}
					
				} else {
					hitbox.dealKnockback = true;
				}
				
				//Add to DS list
				ds_list_add(hitboxesCreated, hitbox);
			}
		}
	}
	
	//If hit
	if (hitCooldown == true) {
		image_index = 0;
		
		//Destroy all hitboxes made
		for (currentHB = 0; currentHB < ds_list_size(hitboxesCreated); currentHB++) {
			instance_destroy(ds_list_find_value(hitboxesCreated, currentHB));
		}
		ds_list_clear(hitboxesCreated);
		
		return true;
	}
	
	//Check if at end of attack
	if (image_index >= image_number - 1) {
		image_index = 0;
		
		//Destroy all hitboxes made
		for (currentHB = 0; currentHB < ds_list_size(hitboxesCreated); currentHB++) {
			instance_destroy(ds_list_find_value(hitboxesCreated, currentHB));
		}
		ds_list_clear(hitboxesCreated);
		
		return true;
	}
	
	return false;
}
function stopAllAttacks() {
	//Loop through all hitboxes created
	if (!ds_list_empty(hitboxesCreated)) {
		for (var i = 0; i < ds_list_size(hitboxesCreated); i++) {
			//Delete hitbox
			hitbox = ds_list_find_value(hitboxesCreated, i);
			instance_destroy(hitbox);
		}
	}
}

//Neutral Attack
function NAttack() {
	//Set attack State
	if (currentAttackState != attackState.nAttack) {
		currentAttackState = attackState.nAttack;
	}
	
	//Create sprites/Complete Attack
	if (attackSprite(neutralAttack)) {
		return true;
	}
	
	return false;
}
//Side Attack
function SAttack() {
	//Set attack State
	if (currentAttackState != attackState.sAttack) {
		currentAttackState = attackState.sAttack;
		
		//Apply Movement
		hSpeed = 320 * image_xscale;
	}
	
	//Create sprites/Complete Attack
	if (attackSprite(sideAttack)) {
		return true;
	}
	
	return false;
}
//Down Attack
function DAttack() {
	//Set attack State
	if (currentAttackState != attackState.dAttack) {
		currentAttackState = attackState.dAttack;
	}
	
	//Apply movement
	if (image_index == 4) {
		vSpeed = -500;
	}
	
	//Create sprites/Complete Attack
	if (attackSprite(downAttack)) {
		return true;
	}
	
	return false;
}
//Neutral Air
function NAir() {
	//Set attack State
	if (currentAttackState != attackState.nAir) {
		currentAttackState = attackState.nAir;
	}
	
	//Create sprites/Complete Attack
	if (attackSprite(neutralAir)) {
		return true;
	}
	
	//Apply Movement
	if (vSpeed > charMoveStruct.maxVSpeed / 2) vSpeed = charMoveStruct.maxVSpeed / 2;
	
	return false;
}
//Side Air
function SAir() {
	//Set attack State
	if (currentAttackState != attackState.sAir) {
		currentAttackState = attackState.sAir;
	}
	
	//Create sprites/Complete Attack
	if (attackSprite(sideAir)) {
		return true;
	}
	
	//Apply Movement
	if (vSpeed > charMoveStruct.maxVSpeed / 4 && image_index < 1) {
		vSpeed = charMoveStruct.maxVSpeed / 4;
	} else if (image_index == 1) {
		vSpeed = -400;
		hSpeed = 300 * image_xscale;
	}
	
	return false;
}
//Down Air
function DAir() {
	//Set attack State
	if (currentAttackState != attackState.dAir) {
		currentAttackState = attackState.dAir;
	
	}
	
	//Create sprites/Complete Attack
	if (attackSprite(downAir)) {
		return true;
	}
	
	//Control animation
	if (image_index == 4) {
		if (!touchingFloor) {
			image_speed = 0;
			image_index = 4;
		} else {
			image_speed = 1;
		}
	}
	
	return false;
}