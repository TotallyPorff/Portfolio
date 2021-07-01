//Get Display stuff
screenWidth = display_get_gui_width();
screenHeight = display_get_gui_height();

//Variables
numberOfChars = 0;
barGapSize = 0;
barWidth = 212;
barEdgeToOrigin = 6;
barXPos = 0;
barYPos = screenHeight - 64;

damageBarWidth = 200;
damageWidth = 0;
damageHeight = 24;

//ID of match manager
managerID = noone;
//ID of Input manager
inputManagerID = noone;

//Timer for activating everything so that it doesn't try to grab IDs that arent there
initialWaitOver = false;
alarm[0] = 0.05 * room_speed //Activates after 1/20th of a second
