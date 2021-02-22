//Sort out text alphas
if (line1Alpha != 1) {
	line1Alpha = Approach(line1Alpha, 1, fadeSpeed);
}
if (line2Alpha != 1 && line1Alpha == 1) {
	line2Alpha = Approach(line2Alpha, 1, fadeSpeed);
}
if (line3Alpha != 1 && line2Alpha == 1) {
	line3Alpha = Approach(line3Alpha, 1, fadeSpeed);
}
if (line4Alpha != 1 && line3Alpha == 1) {
	line4Alpha = Approach(line4Alpha, 1, fadeSpeed);
}

//Sort out timer text
if (instance_exists(Obj_GameManager) && !timeGrabbed) {
	timeGrabbed = true;
	line5 += string(global.time) + " seconds.";
}
if (line5Alpha != 1 && line4Alpha == 1) {
	line5Alpha = Approach(line5Alpha, 1, fadeSpeed);
}

//R to restart
if (line6Alpha != 1 && line4Alpha == 1) {
	line6Alpha = Approach(line6Alpha, 1, fadeSpeed);
}