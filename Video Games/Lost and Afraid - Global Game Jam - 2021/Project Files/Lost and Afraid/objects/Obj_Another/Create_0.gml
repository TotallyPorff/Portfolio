/// @description Setup Variables
walkSpeed = 0.5;
xVelocity = 0;
yVelocity = 0;

//Light
lightRadius = 64;

//Walking SFX
footsteps = audio_play_sound(SFX_Footsteps, 0, true);
audio_stop_sound(footsteps);