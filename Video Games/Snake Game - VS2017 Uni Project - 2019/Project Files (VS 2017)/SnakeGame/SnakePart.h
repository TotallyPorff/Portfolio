#pragma once
#include "EDirection.h"
//#include "Game.h"
#include <SFML/Graphics.hpp>

class Game;

class SnakePart
{
private:
	int partPosition[2]; //Stores the X and Y of this part
	sf::RectangleShape shape;
	bool snakePartDebugOn{ false }; //To turn on/off debugging for SnakePart CPP

public:
	SnakePart(int xPos, int yPos, Game gameName);
	~SnakePart();
	int getX();
	int getY();
	sf::RectangleShape& getShape();
};

