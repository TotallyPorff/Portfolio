/// @description Draw death particles

//Loop through particles
for (var i = 0; i < noOfParticles; i++) {
	//find angle
	effectAngle = (360 / noOfParticles) * i;
	
	//Get effect position
	effectXPos = x + (distance * dcos(effectAngle));
	effectYPos = y + (distance * dsin(effectAngle));
	
	//draw sprite
	if (i mod 2 == 0) { //Medium orb
		draw_sprite(Spr_DeathOrbMed, 0, effectXPos, effectYPos);
	} else { //Small orb
		draw_sprite(Spr_DeathOrbSmol, 0, effectXPos, effectYPos);
	}
}