/// @description Save score
if (room == Rm_Found) {
	highscore = 0;
	//If save file already exists
	if (file_exists("Save.ini")) {
		//open the file
		ini_open("Save.ini");
		//Set highscore
		highscore = ini_read_real("Scores", "Highscore", 0);
		if (global.time > highscore) {
			ini_write_real("Scores", "Highscore", global.time);
		}
		//Set previous score
		ini_write_real("Scores", "Previous", global.time);
	} else { //create file
		ini_open("Save.ini");
		//Set scores
		ini_write_real("Scores", "Highscore", global.time);
		ini_write_real("Scores", "Previous", global.time);
	}
	//close file
	ini_close();
}