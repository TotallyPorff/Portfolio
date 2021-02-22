//Display text in menu
bottomText = "Made by Thomas K for the 2021 Global Game Jam, using Gamemaker 2, Aseprite, & FLStudio. Theme: Lost & Found"
SaveHighscore = "Highscore: 0 seconds";
SavePrevious = "Previous Score: 0 seconds";

//Create music bot
instance_create_depth(0, 0, 0, Obj_MusicManager);

//Set Window
window_set_caption("Lost and Afraid");

//Set time
globalvar time;

//Managing number of items
numberOfItems = 10;
if (room == Rm_Darkness) {
	//start time
	global.time = 0;
	alarm[0] = 1 * room_speed;
	
	//spawn items
	alarm[3] = 30 * room_speed;
}

//create smoke
generateSmoke = true;
if (room == Rm_Main) {
	alarm[2] = 0.05 * room_speed;
	
	//grab any available scores
	if (file_exists("Save.ini")) {
		//open file
		ini_open("Save.ini");
		//read file
		SaveHighscore = "Highscore: " + string(ini_read_real("Scores", "Highscore", 0)) + " seconds";
		SavePrevious = "Previous Score: " + string(ini_read_real("Scores", "Previous", 0)) + " seconds";
		//close file
		ini_close();
	}
}