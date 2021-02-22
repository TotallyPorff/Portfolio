/*
	HAPI Start
	----------
	This solution contains an already set up HAPI project and this main file
	
	The directory structure and main files are:

	HAPI_Start - contains the Visual Studio solution file (.sln)
		HAPI_Start - contains the Visual Studio HAPI_APP project file (.vcxproj) and source code
			HAPI - the directory with all the HAPI library files
			Data - a place to put your data files with a few sample ones provided

	Additionally in the top directory there is a batch file for creating a redistributable Demo folder

	For help using HAPI:
	https://scm-intranet.tees.ac.uk/users/u0018197/hapi.html
*/

// Include the HAPI header to get access to all of HAPIs interfaces
#include <HAPI_lib.h>
#include <stdio.h>
#include <time.h>
#include "visualisation.h"
#include "simulation.h"

// HAPI itself is wrapped in the HAPISPACE namespace
using namespace HAPISPACE;

// Every HAPI program has a HAPI_Main as an entry point
// When this function exits the program will close down
void HAPI_Main()
{
	//Setting rand seed
	srand((unsigned int)time(NULL));

	//Setting screen variables
	int screenWidth{ 600 };
	int screenHeight{ 800 };
	int screenBufferSize{ screenWidth * screenHeight * 4 };

	//Setting game speed variables
	int prevFrameTime{ 0 };

	//Movement speed variables
	int plyrSpeed{ 2 };
	int plyrMaxSpeed{ 20 };
	int plyrJumpPower{ 33 };
	int enmySpeed{ 1 };
	int enmyMaxSpeed{ 10 };
	int enmyJumpPower{ 10 };

	//Scrolling variables
	int scrollSpeed{ 3 };

	//Other variables
	bool gameOver{ false };
	bool deathRumble{ false };
	int score{ 0 };
	int scoreFrames{ 0 }; //Frames till score goes up by one

	//Storing file paths for ease of use
	std::string plyrIdle{ "Data\\PlayerChar\\KnightCharIdleSheetx2.png" };
	std::string plyrRun{ "Data\\PlayerChar\\KnightCharRunSheetx2.png" };
	std::string platform1{ "Data\\Platforms\\thinPlatform1.png" };
	std::string platform2{ "Data\\Platforms\\thinPlatform2.png" };
	std::string platform3{ "Data\\Platforms\\thinPlatform3.png" };
	std::string spikeball{ "Data\\Enemies\\Spikeball.png" };

	//Creating the HAPI window
	if (!HAPI.Initialise(screenWidth, screenHeight, "HAPIness 2: Electric Boogaloo"))
		return;
	HAPI.SetShowFPS(true);

	simulation sim(screenWidth, screenHeight, screenBufferSize, 3, 30);
	//Background
	sim.createObject("Background1", 0, 0, false, 600, 804);
	sim.visAddSprite("Background1", "Data\\Backgrounds\\BackgroundSky.png", 7200, 804, 0, 0, 12, 600, 804);
	sim.createObject("Background2", 0, -802, false, 600, 804);
	sim.visAddSprite("Background2", "Data\\Backgrounds\\BackgroundSky.png", 7200, 804, 0, -802, 12, 600, 804);

	//Player
	sim.createObject("Player", screenWidth / 2, 38, true, 44, 62);
	sim.visAddSprite("Player", plyrIdle, 352, 62, (float)screenWidth / 2, 38, 8, 44, 62);
	sim.isEntity("Player", "Players", 1, 0, 20);

	//Enemies
	sim.createObject("Spikeball1", 0, 0, true, 30, 30);
	sim.visAddSprite("Spikeball1", spikeball, 180, 30, 0, 0, 6, 30, 30);
	sim.isEntity("Spikeball1", "Enemies", 1, 1, 0);

	sim.createObject("Spikeball2", screenWidth - 30, 0, true, 30, 30);
	sim.visAddSprite("Spikeball2", spikeball, 180, 30, (float)screenWidth - 30, 0, 6, 30, 30);
	sim.isEntity("Spikeball2", "Enemies", 1, 1, 0);

	//Platform
	/*The first platform is used as a starting platform
	Each platform has a 100 pixel gap between them and alternate spawning on either the left or right.
	If on left it is rand mod half the screen width, if right then it is left + half of the screen width. 
	*/
	sim.createObject("Platform1", (screenWidth - 200) / 2, 100, true, 200, 32);
	sim.visAddSprite("Platform1", platform1, 200, 32, (float)(screenWidth - 200) / 2, 100, 0, 0, 0);
	//Left
	sim.createObject("Platform2", rand() % (screenWidth / 2), 0, true, 64, 32);
	sim.visAddSprite("Platform2", platform3, 64, 32, (float)(rand() % (screenWidth / 2)), 0, 0, 0, 0);
	//Right
	sim.createObject("Platform3", rand() % (screenWidth / 2) + (screenWidth / 2), -100, true, 100, 32);
	sim.visAddSprite("Platform3", platform2, 100, 32, (float)(rand() % (screenWidth / 2) + (screenWidth / 2)), -100, 0, 0, 0);
	//Left
	sim.createObject("Platform4", rand() % (screenWidth / 2), -200, true, 100, 32);
	sim.visAddSprite("Platform4", platform2, 100, 32, (float)(rand() % (screenWidth / 2)), -200, 0, 0, 0);
	//Right
	sim.createObject("Platform5", rand() % (screenWidth / 2) + (screenWidth / 2), -300, true, 100, 32);
	sim.visAddSprite("Platform5", platform2, 100, 32, (float)(rand() % (screenWidth / 2) + (screenWidth / 2)), -300, 0, 0, 0);
	//Left
	sim.createObject("Platform6", rand() % (screenWidth / 2), -400, true, 100, 32);
	sim.visAddSprite("Platform6", platform2, 100, 32, (float)(rand() % (screenWidth / 2)), -400, 0, 0, 0);
	//Right
	sim.createObject("Platform7", rand() % (screenWidth / 2) + (screenWidth / 2), -500, true, 100, 32);
	sim.visAddSprite("Platform7", platform2, 100, 32, (float)(rand() % (screenWidth / 2) + (screenWidth / 2)), -500, 0, 0, 0);
	//Left
	sim.createObject("Platform8", rand() % (screenWidth / 2), -600, true, 100, 32);
	sim.visAddSprite("Platform8", platform2, 100, 32, (float)(rand() % (screenWidth / 2)), -600, 0, 0, 0);

	//Score
	sim.createScoreCounter();

	while (HAPI.Update()) {

		if (!sim.entityIsDead("Player")) {
			//Frame speed update
			sim.update(true);

			//Game speed update
			if (HAPI.GetTime() - prevFrameTime >= 50) { //20 game frames a second
				prevFrameTime = HAPI.GetTime();

				//Scrolling
				sim.backScroll("Background1", "Background2", scrollSpeed, eDirection::down);
				//Platform scrolling
				sim.platformScroll("Platform1", (screenWidth - 200) / 2, -32, scrollSpeed, eDirection::down); //Centre
				sim.platformScroll("Platform2", rand() % (screenWidth / 2), -32, scrollSpeed, eDirection::down); //left
				sim.platformScroll("Platform3", rand() % (screenWidth / 2) + (screenWidth / 2), -32, scrollSpeed, eDirection::down); //Right
				sim.platformScroll("Platform4", rand() % (screenWidth / 2), -32, scrollSpeed, eDirection::down); //left
				sim.platformScroll("Platform5", rand() % (screenWidth / 2) + (screenWidth / 2), -32, scrollSpeed, eDirection::down); //Right
				sim.platformScroll("Platform6", rand() % (screenWidth / 2), -32, scrollSpeed, eDirection::down); //left
				sim.platformScroll("Platform7", rand() % (screenWidth / 2) + (screenWidth / 2), -32, scrollSpeed, eDirection::down); //Right
				sim.platformScroll("Platform8", rand() % (screenWidth / 2), -32, scrollSpeed, eDirection::down); //left

				//Movement and visual update
				sim.controlPlayer("Player", false, plyrSpeed, plyrMaxSpeed, plyrJumpPower);
				sim.enemyAI("Spikeball1", enmySpeed, enmyMaxSpeed, enmyJumpPower, eDirection::right);
				sim.enemyAI("Spikeball2", enmySpeed, enmyMaxSpeed, enmyJumpPower, eDirection::left);
				sim.GSupdate(true);

				//Changing sprite filepath depending on movement
				if (sim.ObjXMomentum("Player") == 0) {
					if (sim.visReturnSprFilePath("Player") != plyrIdle) {
						sim.visChangeSprite("Player", plyrIdle, 352, 62, 8, 44, 62);
					}
				}
				else {
					if (sim.visReturnSprFilePath("Player") != plyrRun) {
						sim.visChangeSprite("Player", plyrRun, 352, 62, 8, 44, 62);
					}
				}
			}
		}
		else if (!gameOver) {
			sim.controlPlayer("Player", false, plyrSpeed, plyrMaxSpeed, plyrJumpPower); //Teleports player off screen
			//Create game over sprite
			sim.visAddSprite("GameOver", "Data\\Text\\gameOver.png", 148, 24, (float)(screenWidth - 148) / 2, (float)(screenHeight - 24) / 2, 0, 0, 0);
			//Updates one last time
			sim.update(true);
			//Toggles rumble
			sim.toggleRumble(true);
			deathRumble = true;

			gameOver = true;
		}
		else if (deathRumble) {
			//Waits one second
			if (HAPI.GetTime() - prevFrameTime >= 1000) { // 1 second
				prevFrameTime = HAPI.GetTime();

				//Turns off rumble
				sim.toggleRumble(false);
				deathRumble = false;
			}
		}
	}
}
