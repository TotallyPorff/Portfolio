/// @description Add one second to the timer
if (room == Rm_Darkness && instance_exists(Obj_Consci)) {
	if (Obj_Consci.gameState == state.playing) {
		global.time += 1;
		alarm[0] = 1 * room_speed;
	}
}