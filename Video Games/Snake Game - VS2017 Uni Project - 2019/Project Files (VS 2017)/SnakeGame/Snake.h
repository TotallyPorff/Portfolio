#pragma once
#include <list>
#include "SnakePart.h"
#include "Bubble.h"
//#include "Game.h"

class Game;

class Snake
{
private:
	//Necessary Snake parts
	std::list<SnakePart> SnakeParts; //Stores all the snake parts
	int SnakeFrontPos[2]; //Stores x and y of the front snake part
	int SnakeBackPos[2]; //stores x and y of the back snake part
	EDirection Direction;
	//Booleans checking certain things happening
	bool dead;
	bool inAir;
	//Controlling Breath
	int maxBreath;
	int breathLeft;
	std::list<Bubble> visualBreath; //List of the bubbles that represent the amount of breath left
	//Score
	sf::Font font;
	int score;
	std::string scoreString;
	sf::Text displayScore;

	bool snakeDebugOn{ false }; //To turn on/off debugging for Snake CPP

public:
	//Constructor and Destructor
	Snake(int x, int y, Game &snakeGame, int screenHeight, EDirection direction = EDirection::eUp);
	~Snake();
	EDirection getDir();
	void changeDir(EDirection direction);
	void moveSnake(Game &snakeGame);
	std::list<SnakePart>& getList(); //Returns entire list of the snake vector
	std::list<Bubble>& getBreathList(); //Returns entire list of the bubble objects
	void addPart(Game snakeGame);
	void deleteSelf(Game &snakeGame);
	bool getState();
	void checkBreath(Game &snakeGame);
	void updateScore();
	sf::Text getScoreText();
};

