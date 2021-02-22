#include "Game.h"
#include <iostream>
#include <string>
#include <vector>
#include <SFML/Graphics.hpp>
#include "Snake.h"

using namespace std;

Game::Game(int width, int height, int surfaceStartLevel)
{
	//set dimensions of each tile
	tileWidth = width;
	tileHeight = height;

	//Sets water level
	surfaceLevel = surfaceStartLevel;

	//GameOver
	font.loadFromFile("Fonts/SnakeGameFont.ttf");
	gameOver = sf::Text("Game Over", font, 20);
	if (gameDebugOn) cout << "Game - Font Loaded" << endl;

	if (gameDebugOn) cout << "Game - Game Constructed" << endl;
}

Game::~Game()
{
	
}

std::vector<std::vector<std::string>>& Game::getVector() {
	return positionVector; //returns grid
}

std::string Game::getStrPos(int x, int y) {
	return positionVector[x][y]; //Returns string value in that position on the grid
}

void Game::strEditPos(std::string string, int x, int y) {
	positionVector[x][y] = string; //Edits the string value in that position of the 2D vector
}

void Game::build(int screenWidth, int screenHeight) {
	//Setting the width of 2D Vector
	positionVector.resize((screenWidth / tileWidth));

	//Setting Height of 2D Vector
	for (int i = 0; i < positionVector.size(); i++) {
		positionVector[i].resize((screenHeight / tileHeight));
	}
	if (gameDebugOn) cout << "Game - 2D Vector Built" << endl;

	//Fill Vector with dots
	for (int i = 0; i < positionVector[0].size(); i++) {
		for (int j = 0; j < positionVector.size(); j++) {
			positionVector[j][i] = "."; //Empty
		}
		cout << endl;
	}
	if (gameDebugOn) cout << "Game - 2D Vector filled" << endl;

	//Set Air above water level
	for (int i = 0; i < positionVector.size(); i++) {
		positionVector[i][surfaceLevel] = "A"; //Air
	}
	cout << endl;

	//Creates object to control water level
	waterWidth = screenWidth;
	waterHeight = screenHeight - ((surfaceLevel + 1) * tileHeight);
	water = sf::RectangleShape(sf::Vector2f(waterWidth, waterHeight));
	water.setFillColor(sf::Color::Blue);
	water.setPosition(sf::Vector2f(0, (surfaceLevel + 1) * tileHeight));

	if (gameDebugOn) cout << "Game - Water Added" << endl;

	//Setting Position of GameOver text
	sf::FloatRect tempTextRec = gameOver.getLocalBounds(); //Sets temporary rectangle to dimensions of text
	gameOver.setOrigin(tempTextRec.left + tempTextRec.width / 2.0f, tempTextRec.top + tempTextRec.height / 2.0f); /*Sets origin of text to the centre of the text 
																												  based on dimension set on temporary rectangle*/
	gameOver.setPosition(sf::Vector2f(screenWidth / 2, screenHeight / 2)); //Sets position to centre of the screen
	if (gameDebugOn) cout << "Game - Water Added" << endl;

	if (gameDebugOn) cout << "Game - Game Built" << endl;
}

//Displays all these objects to the window for the window to render
void Game::display(sf::RenderWindow &window, Snake &snakeClass) {
	window.draw(water);

	for (auto &p : snakeClass.getList()) {
		window.draw(p.getShape());//renders each part of snake
	}

	for (int i = 0; i < allTheFood.size(); i++) {
		window.draw(allTheFood[i].getFoodShape()); //renders the food
	}

	for (auto &p : snakeClass.getBreathList()) {
		window.draw(p.getBubbleShape()); //renders "bubbles" for air
	}

	window.draw(snakeClass.getScoreText()); //renders the score

	if (snakeClass.getState()) {
		window.draw(gameOver); /* If the snake is in a dead state, displays the game over state. This works because although the loop this is in checks
							   if the snake is dead, this is after the functions that change the state of the snake to dead, meaning this will run once
							   before the loop closes*/
	}

	if (gameDebugOn) cout << "Game - Objects Displayed" << endl;
}

//These two can either return the number of tiles in the grid, or the dimensions of the individual tiles
int Game::getTileWidth(bool tilesWide, int screenWidth) {
	if (tilesWide == false) {
		return tileWidth; //Returns the dimension of the tile
	}
	return screenWidth / tileWidth - 1; //returns the number of tiles there are in the width of the screen
}

int Game::getTileHeight(bool tilesHigh, int screenHeight) {
	if (tilesHigh == false) {
		return tileHeight; //Returns the dimension of the tile
	}
	return screenHeight / tileHeight - 1; //returns the number of tiles there are in the height of the screen
}

void Game::displayVector() {
	//for debugging. Displays all the string values of every position within the 2D vector
	for (int i = 0; i < positionVector[0].size(); i++) {
		for (int j = 0; j < positionVector.size(); j++) {
			cout << positionVector[j][i];
		}
		cout << endl;
	}
}

void Game::addFood(int screenWidth, int screenHeight) {
	//Sets the x and y of the new food to somewhere random
	int x{ rand() % (*this).getTileWidth(true, screenWidth) };
	int y{ rand() % (*this).getTileHeight(true, screenHeight) };

	//Makes sure the y is below the surface
	while (y <= surfaceLevel) {
		y = rand() % (*this).getTileHeight(true, screenHeight);
	}

	//Not enough food?
	if (allTheFood.size() < 5) {
		//Is there a snake there?
		if (positionVector[x][y] != "S") {
			allTheFood.push_back(Food(x, y, (*this)));
			(*this).strEditPos("F", x, y);
			//Output for debugging
			if (gameDebugOn) cout << "Game - Food Added" << endl;
		}
	}
}

void Game::removeFood(int x, int y) {
	//loops through vector
	for (int i = 0; i < allTheFood.size(); i++) {
		if (allTheFood[i].getX() == x && allTheFood[i].getY() == y) {
			allTheFood.erase(allTheFood.begin() + i);
			if (gameDebugOn) cout << "Output - Food Deleted" << endl;
		}
	}
}

void Game::reloadSurface(int screenHeight) {
	//reload water level
	for (int j = 0; j <= surfaceLevel; j++) {
		for (int i = 0; i < positionVector.size(); i++) {
			if (positionVector[i][j] != "S") {
				if (positionVector[i][j] == "F") (*this).removeFood(i, j);
				positionVector[i][j] = "A"; //Air
			}
		}
	}

	//Move water image
	waterHeight = screenHeight - ((surfaceLevel + 1) * tileHeight);
	water.setSize(sf::Vector2f(waterWidth, waterHeight));
	water.setPosition(sf::Vector2f(0, (surfaceLevel + 1) * tileHeight));

	if (gameDebugOn) cout << "Game - Water Reloaded" << endl;
}

void Game::lowerWater(int screenHeight) {
	//Lowers the surface level then calls the reloadSurface function to update the water on the screen
	if (surfaceLevel != positionVector[0].size()) {
		surfaceLevel += 1;
		(*this).reloadSurface(screenHeight);
	}
	if (gameDebugOn) cout << "Game - Water Level Lowered" << endl;
}