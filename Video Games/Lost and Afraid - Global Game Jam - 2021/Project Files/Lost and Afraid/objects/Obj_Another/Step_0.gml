//Approach
xVelocity = 0;
if (x > Obj_Consci.x + 24) {
	xVelocity = -1;
}

x += xVelocity * walkSpeed;
y += yVelocity * walkSpeed;