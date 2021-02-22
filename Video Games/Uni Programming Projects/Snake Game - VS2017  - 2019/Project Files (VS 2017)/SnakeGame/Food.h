#pragma once
#include <list>
#include <SFML/Graphics.hpp>

class Game;

class Food
{
private:
	int position[2]; //Stores position of this food object
	sf::RectangleShape shape;
	bool foodDebugOn{ false }; //To turn on/off debugging for Food CPP

public:
	Food(int x, int y, Game gameName);
	~Food();
	int getX();
	int getY();
	sf::RectangleShape& getFoodShape();
};

