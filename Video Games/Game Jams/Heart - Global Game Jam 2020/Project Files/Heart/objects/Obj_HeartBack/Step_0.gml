//Set alarm if not set yet
if (!alarmRunning && !moving) {
	alarm[0] = irandom_range(0, 1200); //0-20 seconds
	alarmRunning = true;
}
//Move
if (moving) {
	y += -0.5;
	x += xDirection;
	if (y == -100) {
		y = -200;
		x = -200;
		moving = false;
	}
}