#pragma once
#include "SnakePart.h"

class Game;

class SnakeHead : public SnakePart
{
public:
	SnakeHead(int xPos, int yPos, Game gameName, EDirection Direcition = EDirection::eUp);
	~SnakeHead();
};

