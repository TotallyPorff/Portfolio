//bobbing up and down
if (bobbingUp) {
	yBob = Approach(yBob, -maxSpeed, 0.005);
	if (yBob <= -maxSpeed) {
		bobbingUp = false;
	}
} else {
	yBob = Approach(yBob, maxSpeed, 0.005);
	if (yBob >= maxSpeed) {
		bobbingUp = true;
	}
}

y += yBob;