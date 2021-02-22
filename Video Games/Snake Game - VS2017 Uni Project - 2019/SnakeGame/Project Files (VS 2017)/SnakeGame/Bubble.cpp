#include "Bubble.h"
#include <iostream>
#include "Game.h"

using namespace std;

Bubble::Bubble(int x, int y, Game snakeGame)
{
	//Stores position of this object
	position[0] = x;
	position[1] = y;
	//Get shape
	sf::RectangleShape partShape(sf::Vector2f(snakeGame.getTileWidth(false), snakeGame.getTileHeight(false)));
	shape = partShape;
	shape.setPosition(sf::Vector2f(position[0] * snakeGame.getTileWidth(false), position[1] * snakeGame.getTileHeight(false)));

	//Output for debugging
	if (bubbleDebugOn) cout << "Bubble - Bubble Constructed" << endl;
}


Bubble::~Bubble()
{
}

int Bubble::getX() {
	return position[0];
}

int Bubble::getY() {
	return position[1];
}

sf::RectangleShape& Bubble::getBubbleShape() {
	return shape; //returns shape so it can be displayed
}
