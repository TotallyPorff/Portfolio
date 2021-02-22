/// @description Setup Variables
walkSpeed = 1;
xVelocity = 0;
yVelocity = 0;
newX = 0;
newY = 0;
circleIncrease = false;
depth = -10;

//Light
lightRadius = 200;
fadeAlpha = 0;

//Walking SFX
footsteps = audio_play_sound(SFX_Footsteps, 0, true);
audio_stop_sound(footsteps);

//Game States
enum state {
	playing,
	panicStart,
	panicking,
	calm
}
gameState = state.playing;

//Creating spikes for shadow
maxSpikes = 18;
for (i = 0; i < maxSpikes; i++) {
	instance_create_depth(x, y, -99, Obj_Spikes);
}