//Fade out
if (image_alpha != 0) {
	image_alpha = Approach(image_alpha, 0, 0.001);
} else {
	instance_destroy();
}

//move upwards
y -= upSpeed;