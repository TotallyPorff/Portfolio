#include <iostream>
#include "Food.h"
#include "Game.h"

using namespace std;

Food::Food(int x, int y, Game gameName)
{
	//Stores position of this object
	position[0] = x;
	position[1] = y;
	//Get shape
	sf::RectangleShape partShape(sf::Vector2f(gameName.getTileWidth(false), gameName.getTileHeight(false)));
	partShape.setFillColor(sf::Color::Cyan);
	shape = partShape;
	shape.setPosition(sf::Vector2f(position[0] * gameName.getTileWidth(false), position[1] * gameName.getTileHeight(false)));

	if (foodDebugOn) cout << "Food - Food Constructed" << endl;
}


Food::~Food()
{
}

int Food::getX() {
	return position[0];
}

int Food::getY() {
	return position[1];
}

sf::RectangleShape& Food::getFoodShape() {
	return shape; //returns shape so it can be displayed
}
