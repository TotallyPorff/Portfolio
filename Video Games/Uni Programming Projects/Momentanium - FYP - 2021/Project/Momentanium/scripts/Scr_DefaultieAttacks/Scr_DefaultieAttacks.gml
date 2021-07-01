//Store all default attack variables
function DefaultieAttacks() constructor {
	neutralAttack = {
		attackName: "NAttck",
		permDamage: 3,
		comboDamage: 2,
		xKnockback: 200,
		yKnockback: -200,
		numOfAttacks: 2,
		KBOnLast: true //knockback on last hitbox
	}
	
	sideAttack = {
		attackName: "SAttck",
		permDamage: 7,
		comboDamage: 8,
		xKnockback: 100,
		yKnockback: -200,
		numOfAttacks: 1,
		KBOnLast: false
	}
	
	downAttack = {
		attackName: "DAttck",
		permDamage: 7,
		comboDamage: 7,
		xKnockback: 0,
		yKnockback: -600,
		numOfAttacks: 1,
		KBOnLast: false
	}
	
	neutralAir = {
		attackName: "NAir",
		permDamage: 6,
		comboDamage: 4,
		xKnockback: 200,
		yKnockback: -300,
		numOfAttacks: 1,
		KBOnLast: false
	}
	
	sideAir = {
		attackName: "SAir",
		permDamage: 8,
		comboDamage: 6,
		xKnockback: 300,
		yKnockback: -200,
		numOfAttacks: 1,
		KBOnLast: false
	}
	
	downAir = {
		attackName: "DAir",
		permDamage: 12,
		comboDamage: 4,
		xKnockback: 200,
		yKnockback: -100,
		numOfAttacks: 1,
		KBOnLast: false
	}
}