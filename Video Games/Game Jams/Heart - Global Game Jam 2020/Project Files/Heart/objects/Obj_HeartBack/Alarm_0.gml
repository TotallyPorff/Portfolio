//Reset alarm and start moving
alarmRunning = false;
moving = true;

y = room_height + 100;
x = irandom_range(0, room_width);
xDirection = random_range(-0.25, 0.25);