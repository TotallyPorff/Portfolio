#pragma once
#include <vector>
#include <list>
#include <string>
#include "SnakePart.h"
#include "Bubble.h"
#include "Food.h"

class Snake;

class Game
{
private:
	//2D Vector and Movement
	int tileWidth;
	int tileHeight;
	std::vector<std::vector<std::string>> positionVector; //The 2D Vector Grid
	//Food
	std::vector<Food> allTheFood;
	//Water
	int waterWidth;
	int waterHeight;
	int surfaceLevel;
	sf::RectangleShape water;
	bool gameDebugOn{ false }; //To turn on/off debugging for Game CPP
	//GameOver
	sf::Font font;
	sf::Text gameOver;

public:
	//Constructor and Destructor
	Game(int width, int height, int surfaceStartLevel = 0);
	~Game();
	//2D Vector and Movement
	std::vector<std::vector<std::string>>& getVector();
	void build(int screenWidth, int screenHeight);
	void display(sf::RenderWindow &window, Snake &snakeClass); //Displays everything thats on the screen
	int getTileWidth(bool tilesWide, int screenWidth = 0);
	int getTileHeight(bool tilesHigh, int screenHeight = 0);
	void displayVector(); //For Debugging purposes
	void strEditPos(std::string string, int x, int y); //Edits certain string at position in Grid
	std::string getStrPos(int x, int y);
	//Food
	void addFood(int screenWidth, int screenHeight);
	void removeFood(int x, int y);
	//Water
	void reloadSurface(int screenHeight);
	void lowerWater(int screenHeight);
};
