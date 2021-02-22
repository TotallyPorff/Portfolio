/*
  Games Development with C++ GAV1031-N
  Snake ICA start project 
  
  Set up to use the SFML 2.5.1 64-bit API
    SFML documentation: https://www.sfml-dev.org/learn.php
*/

//Includes
#include <iostream>
#include <vector>
#include <list>
#include <stdlib.h>

// SFML header file for graphics, there are also ones for Audio, Window, System and Network
#include <SFML/Graphics.hpp>

//headers
#include "Game.h"
#include "Snake.h"

using namespace std;

int main()
{
	//creates clock to keep the game running at a certain game speed
	sf::Clock clock;

	srand(time(NULL));

    // Creates an instance of the SFML RenderWindow type which represents the display
    // and initialises its size and title text
	int screenWidth = 800;
	int screenHeight = 600;
    sf::RenderWindow window(sf::VideoMode(screenWidth, screenHeight), "C++ Snake ICA : V8052473");
	
	bool mainDebugOn{ false }; //To turn on/off debugging for main CPP

	Game snakeGame(10, 10); //Use game constructor with tile width and height
	snakeGame.build(screenWidth, screenHeight); //Lay out the actual grid with the build function

	Snake Player1(15, 15, snakeGame, screenHeight); //Named Player 1 just in case I added more players to the game

	//Setting clock for adding food
	int foodClock{ 0 };
	//Setting time before each lowering of water level
	int waterClockLimit{90000 / snakeGame.getTileHeight(true, screenHeight)}; //90 seconds divided by Height of 2D vector to time before water level lowers by 1
	int waterClock{ 0 };
	//Setting clock for losing breath
	int breathClock{ 0 };

	if (mainDebugOn) cout << "Main - Clocks Set" << endl; //For debugging
	if (mainDebugOn) std::cout << "Main - Starting Loop" << std::endl; //For debugging

    // Main loop that continues until we call window.close()
    while (window.isOpen())
    {
		if (mainDebugOn) cout << "--- Main - New Loop ---" << endl;	//For debugging

        // Handles any pending SFML events
        // These cover keyboard, mouse,joystick etc.
        sf::Event event;
        while (window.pollEvent(event))
        {
          switch(event.type)
          {
            case sf::Event::Closed:
              window.close();
            break;
            default:
              break;
          }
        }

		//Update Score
		Player1.updateScore(); //This is put here so the score doesn't go to 0 when the player dies.
		if (mainDebugOn) cout << "Main - Snake Score Updated" << endl; //For debugging
		
		//Player 1 Snake
		if (!Player1.getState()) {
			//Changing Direction
			if (sf::Keyboard::isKeyPressed(sf::Keyboard::W)) {
				Player1.changeDir(EDirection::eUp);
			}
			else if (sf::Keyboard::isKeyPressed(sf::Keyboard::S)) {
				Player1.changeDir(EDirection::eDown);
			}
			else if (sf::Keyboard::isKeyPressed(sf::Keyboard::A)) {
				Player1.changeDir(EDirection::eLeft);
			}
			else if (sf::Keyboard::isKeyPressed(sf::Keyboard::D)) {
				Player1.changeDir(EDirection::eRight);
			}
			if (mainDebugOn) cout << "Main - Checked Direction Change" << endl; //For debugging

			//Moving Snake
			Player1.moveSnake(snakeGame);
			if (mainDebugOn) cout << "Main - Snake Moved" << endl; //For debugging

			window.clear();
			if (mainDebugOn) cout << "Main - Window Cleared" << endl; //For debugging

			snakeGame.display(window, Player1); //Displays all of snake 1, water and the food
			if (mainDebugOn) cout << "Main - Game Displayed" << endl; //For debugging

			// Get the window to display its contents
			window.display();
			if (mainDebugOn) cout << "Main - Window Displayed" << endl; //For debugging

			//Set game to run at a certain game speed.
			while (clock.getElapsedTime().asMilliseconds() < 100);
			foodClock += 100;
			waterClock += 100;
			breathClock += 100;
			if (mainDebugOn) cout << "Main - Added to Clocks" << endl; //For debugging

			clock.restart(); //Clock reset
			if (mainDebugOn) cout << "Main - Clock Restarted" << endl; //For debugging

			//Food Clock
			if (foodClock == 2000) {
				foodClock = 0;
				if (mainDebugOn) cout << "Main - Food Clock Reset" << endl; //For debugging
				//Add food
				snakeGame.addFood(screenWidth, screenHeight);
				if (mainDebugOn) cout << "Main - Add Food Called" << endl; //For debugging
			}
			//Water Clock
			if (waterClock >= waterClockLimit) {
				waterClock = 0;
				if (mainDebugOn) cout << "Main - Water Clock Reset" << endl; //For debugging
				//Lower water level
				snakeGame.lowerWater(screenHeight);
				if (mainDebugOn) cout << "Main - Lower Water Called" << endl; //For debugging
			}
			//Breath Clock
			if (breathClock == 1000) {
				breathClock = 0;
				if (mainDebugOn) cout << "Main - Breath Clock Reset" << endl; //For debugging
				//Lower water level
				Player1.checkBreath(snakeGame);
				if (mainDebugOn) cout << "Main - Check Breath Called" << endl; //For debugging
			}
		}

		if (mainDebugOn) cout << "--- Main - Loop End ---" << endl; //For debugging
    }

	if (mainDebugOn) cout << "Main - Game Finished" << endl; //For debugging

	if (mainDebugOn) snakeGame.displayVector(); //For debugging

    return 0;
}
