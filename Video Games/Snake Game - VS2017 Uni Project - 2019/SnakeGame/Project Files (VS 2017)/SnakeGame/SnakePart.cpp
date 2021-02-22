#include <iostream>
#include "SnakePart.h"
#include "Game.h"

using namespace std;

SnakePart::SnakePart(int xPos, int yPos, Game gameName)
{
	//set position
	partPosition[0] = xPos;
	partPosition[1] = yPos;
	//build shape for the part
	sf::RectangleShape partShape(sf::Vector2f(gameName.getTileWidth(false), gameName.getTileHeight(false)));
	partShape.setFillColor(sf::Color::Green);
	shape = partShape;
	shape.setPosition(sf::Vector2f(partPosition[0] * gameName.getTileWidth(false), partPosition[1] * gameName.getTileHeight(false))); /*Sets position of snake
																																	  part to where it should
																																	  be on the screen*/

	if (snakePartDebugOn) cout << "SnakePart - Snake Part Constructed" << endl;
}

SnakePart::~SnakePart()
{
}

//these two functions display the position of the part
int SnakePart::getX() {
	return partPosition[0];
}

int SnakePart::getY() {
	return partPosition[1];
}

sf::RectangleShape& SnakePart::getShape() {
	return shape; //returns shape so it can be displayed
}