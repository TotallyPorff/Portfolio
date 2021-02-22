//gameplay room
if (room == Rm_Darkness) {
	sprite_index = Spr_Spikes;
	
	//Place round the circle
	degreesPerInst = 360 / Obj_Consci.maxSpikes;
	placeOnCircle = (instance_number(Obj_Spikes) - 1) * degreesPerInst;
	image_index = random(image_number - 1)
	image_xscale = 2;
	image_yscale = 2;

	//To make it run at least once
	x = Obj_Consci.x + lengthdir_x(Obj_Consci.lightRadius, placeOnCircle);
	y = Obj_Consci.y + lengthdir_y(Obj_Consci.lightRadius, placeOnCircle);
	direction = point_direction(x, y, Obj_Consci.x, Obj_Consci.y);
	image_angle = direction;
}