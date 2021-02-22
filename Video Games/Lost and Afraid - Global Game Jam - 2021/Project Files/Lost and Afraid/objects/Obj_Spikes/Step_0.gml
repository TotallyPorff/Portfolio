//Stick with the circle and look at the player
if (room == Rm_Darkness) {
	if (Obj_Consci.lightRadius > 64) {
		x = Obj_Consci.x + lengthdir_x(Obj_Consci.lightRadius, placeOnCircle);
		y = Obj_Consci.y + lengthdir_y(Obj_Consci.lightRadius, placeOnCircle);
	} else {
		x = Obj_Consci.x + lengthdir_x(64, placeOnCircle);
		y = Obj_Consci.y + lengthdir_y(64, placeOnCircle);
	}

	direction = point_direction(x, y, Obj_Consci.x, Obj_Consci.y);
	image_angle = direction;
}