#pragma once
#include <SFML/Graphics.hpp>

class Game;

class Bubble
{
private:
	int position[2]; //Stores position of this bubble object
	sf::RectangleShape shape;
	bool bubbleDebugOn{ false }; //To turn on/off debugging for Food CPP

public:
	Bubble(int x, int y, Game snakeGame);
	~Bubble();
	int getX();
	int getY();
	sf::RectangleShape& getBubbleShape();
};

