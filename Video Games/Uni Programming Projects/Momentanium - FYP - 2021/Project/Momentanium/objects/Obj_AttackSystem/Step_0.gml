///@description Health, Knockback & Attacks

// Inherit the parent event
event_inherited();

//Attack Inputs
if (!isDead) { //Disable inputs if dead
	if (isController) { //Controller
		normAttckInp = gamepad_button_check_pressed(controllerIndex, normAttckContr);
		specAttackInp = gamepad_button_check_pressed(controllerIndex, specAttckContr);
	} else { //keyboard
		normAttckInp = keyboard_check_pressed(normAttckKey);
		specAttackInp = keyboard_check_pressed(specAttckKey);
	}
}

/* -- REGEN NON-PERM DAMAGED HEALTH -- */
currentHealth = Approach(currentHealth, currentPermHealth, regenRate / room_speed);

/* -- GETTING HIT -- */
//Check if not invincible
if (!isInvincible && !hitCooldown) {
	
	//Check for getting hit
	hitBy = collision_circle(x, y, charMoveStruct.hurtboxRadius, Obj_AttackHitbox, true, true);
	if (ds_list_find_index(hitboxesCreated, hitBy) == -1 && hitBy != noone) { //Not a hitbox made by this character and not empty
		
		//Check if it hasn't been hit by this before
		if (ds_list_find_index(beenHitBy, hitBy) == -1) {
			
			/* -- DAMAGE -- */
			//Enemy speed & damage boost
			enemySpeed = sqrt(sqr(hitBy.hitboxCreator.hSpeed) + sqr(hitBy.hitboxCreator.vSpeed));
			damageBoostDec = enemySpeed / 1000;
			if (damageBoostDec > 1) damageBoostDec = 1;
			
			//Perm damage
			dealDamagePerm = hitBy.attackStats.permDamage;
			dealDamagePerm += dealDamagePerm * (damageBoostDec / 2);
			
			//Combo damage
			dealDamageCombo = hitBy.attackStats.comboDamage;
			dealDamageCombo += dealDamageCombo * (damageBoostDec / 2);
			takeDamage(dealDamagePerm, dealDamageCombo);
			
			/* -- KNOCKBACK -- */
			if (hitBy.dealKnockback) {
				//Calculate Knockback
				dealKnockX = hitBy.hitboxCreator.hSpeed + (hitBy.attackStats.xKnockback * hitBy.image_xscale);
				dealKnockY = hitBy.hitboxCreator.vSpeed + hitBy.attackStats.yKnockback;
				takeKnockback(dealKnockX, dealKnockY);
			} else {
				//Calculate Knockback
				dealKnockX = hitBy.hitboxCreator.hSpeed + (25 * hitBy.image_xscale);
				dealKnockY = hitBy.hitboxCreator.vSpeed + 25;
				takeKnockback(dealKnockX, dealKnockY);
			}
			
			//add to DS list
			ds_list_add(beenHitBy, hitBy);
			
			//Start hit cooldown timer
			hitCooldown = true;
			alarm[3] = hitCooldownTime * room_speed;
			
			//Set image scale
			image_xscale = hitBy.image_xscale * -1;
		}
	}
}

//Death
if (currentHealth <= 0) isDead = true;
if (isDead) {	
	//Stop all attacks and reset
	stopAllAttacks();
	currentAttackState = attackState.idle;
	
	//Reset Health
	currentHealth = maxHealth;
	currentPermHealth = maxHealth;
}

/* -- ATTACKS -- */
if (currentAttackState == attackState.idle) {
	
	/* -- NORMAL ATTACKS -- */
	if (normAttckInp && touchingFloor) {
		//check for inputs
		if (hInput != 0) { //Side
			SAttack();		
		} else if (vInput == 1) { //Down
			DAttack();
		} else { //Neutral
			NAttack();		
		}
	}
	/* -- AERIAL ATTACKS -- */
	else if (normAttckInp && !touchingFloor && !touchingWall) {
		//check for inputs
		if (hInput != 0) { //Side
			SAir();
		} else if (vInput == 1) { //Down
			DAir();
		} else { //Neutral
			NAir();		
		}
	}
}

/* -- CONTINUE ATTACKS -- */
switch (currentAttackState) {
	case attackState.nAttack:
		if (NAttack()) {
			currentAttackState = attackState.idle;
		}
		break;
	case attackState.sAttack:
		if (SAttack()) {
			currentAttackState = attackState.idle;
		}
		break;
	case attackState.dAttack:
		if (DAttack()) {
			currentAttackState = attackState.idle;
		}
		break;
	case attackState.nAir:
		if (NAir()) {
			currentAttackState = attackState.idle;
		}
		break;
	case attackState.sAir:
		if (SAir()) {
			currentAttackState = attackState.idle;
		}
		break;
	case attackState.dAir:
		if (DAir()) {
			currentAttackState = attackState.idle;
		}
		break;
	default:
		break;
}