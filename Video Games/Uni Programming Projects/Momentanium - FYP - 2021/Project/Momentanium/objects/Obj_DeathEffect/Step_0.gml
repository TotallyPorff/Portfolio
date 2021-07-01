/// @description Slow down the speed
if (effectSpeed > 0) {
	effectSpeed -= slowdown / room_speed;
} else {
	effectSpeed = 0;
	instance_destroy();
}

distance += effectSpeed;