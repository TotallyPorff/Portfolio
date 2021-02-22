/// @description Decrease available items
if (room == Rm_Darkness) {
	if (numberOfItems > 3) {
		numberOfItems += -1;
		alarm[3] = 30 * room_speed;
	}
}
