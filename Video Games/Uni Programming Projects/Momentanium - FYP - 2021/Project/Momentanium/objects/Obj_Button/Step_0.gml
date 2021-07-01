/// @description Check if clicked

//If hovered over
if (collision_point(mouse_x, mouse_y, id, false, false)) {
	//Check if clicked
	if (mouse_check_button_pressed(mb_left)) {
		global.playerCount = playerNumber;
		room_goto(Rm_Testing);
	}
}