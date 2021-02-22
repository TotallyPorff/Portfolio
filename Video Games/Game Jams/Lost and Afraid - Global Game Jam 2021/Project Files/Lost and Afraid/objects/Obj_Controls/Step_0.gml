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

//Fade in
if (image_alpha != 0.5) {
	image_alpha = Approach(image_alpha, 0.5, 0.001);
}