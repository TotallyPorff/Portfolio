#include <iostream>
#include "Snake.h"
#include "Game.h"
#include "SnakePart.h"

using namespace std;

Snake::Snake(int x, int y, Game &snakeGame, int screenHeight, EDirection direction)
{
	//Fills snakepart list full of snake parts
	for (int i = 0; i < 10; i++) {
		SnakeParts.push_back(SnakePart(15, 15 + i, snakeGame));
		snakeGame.getVector()[15][15 + i] = "S"; //Sets string value in the same position as the snake part to S (for snake)
	}

	//Sets the front and back position values to the values they should be
	SnakeFrontPos[0] = x;
	SnakeFrontPos[1] = y;
	SnakeBackPos[0] = SnakeParts.back().getX();
	SnakeBackPos[1] = SnakeParts.back().getY();

	Direction = direction;
	dead = false;
	inAir = false;

	//Sets the maximum amount of breath and sets the current amount of breath to that
	maxBreath = 20;
	breathLeft = maxBreath;

	//Create Bubble Objects equal to the amount of breath
	for (int i = 0; i < maxBreath; i++) {
		visualBreath.push_back(Bubble(i, 0, snakeGame));
	}
	if (snakeDebugOn) cout << "Snake - Bubbles Constructed" << endl;

	//Fonts
	font.loadFromFile("Fonts/SnakeGameFont.ttf");
	if (snakeDebugOn) std::cout << "Snake - Font Loaded" << std::endl;

	//Score
	score = SnakeParts.size() * 100; //The score value
	scoreString = std::string("Score: ") + to_string(score); //The text to display
	displayScore = sf::Text(scoreString, font, 20);
	displayScore.setPosition(sf::Vector2f(0, screenHeight - 20)); //Sets the score to display in the bottom left

	if (snakeDebugOn) cout << "Snake - Snake Constructed" << endl;
}

Snake::~Snake()
{

}

void Snake::changeDir(EDirection direction) {
	/*Uses switch case to change direction to whatever is put in the parameter. This also makes sure that 1)The snake isn't go back on itself
	and 2)The snake can't go anywhere but down when in the air (to prevent collision when controlling on the surface)*/
	switch (direction) {
	case EDirection::eUp:
		if (inAir != true && Direction != EDirection::eDown) Direction = direction;
		break;
	case EDirection::eDown:
		if (Direction != EDirection::eUp) Direction = direction;
		break;
	case EDirection::eLeft:
		if (inAir != true && Direction != EDirection::eRight) Direction = direction;
		break;
	case EDirection::eRight:
		if (inAir != true && Direction != EDirection::eLeft) Direction = direction;
		break;
	}
	if (snakeDebugOn) cout << "Snake - Direction Changed" << endl;
}

void Snake::moveSnake(Game &snakeGame) {
	//Check if not dead
	if (!dead) {

		//check if in the air
		if (inAir == true) {
			if (Direction == EDirection::eUp) {
				//Forces player left or right depending on where they are on the screen
				if (SnakeFrontPos[0] <= snakeGame.getVector().size() / 2) {
					Direction = EDirection::eRight;
				}
				else {
					Direction = EDirection::eLeft;
				}
				if (snakeDebugOn) cout << "Snake - Forced Sideways" << endl;
			}
			else if (snakeGame.getStrPos(SnakeFrontPos[0], SnakeFrontPos[1] + 1) != ".") {
				//force down (Problem with this is you can suicide your snake by spamming up just before being forced down)
				Direction = EDirection::eDown;
				if (snakeDebugOn) cout << "Snake - Forced Down" << endl;
			}
		}

		//Check Upwards stuff
		if (Direction == EDirection::eUp) {

			//Check if on edge of 2D vector
			if (SnakeFrontPos[1] - 1 >= 0) {

				//Check if not colliding with Snek
				if (snakeGame.getStrPos(SnakeFrontPos[0], SnakeFrontPos[1] - 1) != "S") {

					//If food is ahead
					if (snakeGame.getStrPos(SnakeFrontPos[0], SnakeFrontPos[1] - 1) == "F") {
						(*this).addPart(snakeGame);
						snakeGame.removeFood(SnakeFrontPos[0], SnakeFrontPos[1] - 1);
					}

					//If entering surface
					if (snakeGame.getStrPos(SnakeFrontPos[0], SnakeFrontPos[1] - 1) == "A") {
						inAir = true;
					}
					else {
						inAir = false;
					}

					//Add to front
					SnakeParts.push_front(SnakePart(SnakeFrontPos[0], SnakeFrontPos[1] - 1, snakeGame));
					snakeGame.strEditPos("S", SnakeFrontPos[0], SnakeFrontPos[1] - 1);
					//Remove from back
					SnakeParts.pop_back();
					snakeGame.strEditPos(".", SnakeBackPos[0], SnakeBackPos[1]);
					SnakeFrontPos[1] += -1;

					//Output for debugging
					if (snakeDebugOn) cout << "Snake - Moved Upwards" << endl;
				}
				else if (snakeGame.getStrPos(SnakeFrontPos[0], SnakeFrontPos[1] - 1) == "S") {
					(*this).deleteSelf(snakeGame);
				}

			}
			else {
				(*this).deleteSelf(snakeGame);
			}
		}

		//Check Downwards stuff
		else if (Direction == EDirection::eDown) {

			//Check if on edge of 2D vector
			if (SnakeFrontPos[1] + 1 <= snakeGame.getVector()[0].size() - 1) {

				//Check if not colliding with Snek
				if (snakeGame.getStrPos(SnakeFrontPos[0], SnakeFrontPos[1] + 1) != "S") {

					//If food is ahead
					if (snakeGame.getStrPos(SnakeFrontPos[0], SnakeFrontPos[1] + 1) == "F") {
						(*this).addPart(snakeGame);
						snakeGame.removeFood(SnakeFrontPos[0], SnakeFrontPos[1] + 1);
					}

					//If entering surface
					if (snakeGame.getStrPos(SnakeFrontPos[0], SnakeFrontPos[1] + 1) == "A") {
						inAir = true;
					}
					else {
						inAir = false;
					}

					//Add to front
					SnakeParts.push_front(SnakePart(SnakeFrontPos[0], SnakeFrontPos[1] + 1, snakeGame));
					snakeGame.strEditPos("S", SnakeFrontPos[0], SnakeFrontPos[1] + 1);
					//Remove from back
					SnakeParts.pop_back();
					snakeGame.strEditPos(".", SnakeBackPos[0], SnakeBackPos[1]);
					SnakeFrontPos[1] += 1;

					//Output for debugging
					if (snakeDebugOn) cout << "Snake - Moved Downwards" << endl;
				}
				else if (snakeGame.getStrPos(SnakeFrontPos[0], SnakeFrontPos[1] + 1) == "S") {
					(*this).deleteSelf(snakeGame);
				}

			}
			else {
				(*this).deleteSelf(snakeGame);
			}
		}

		//Check Left stuff
		else if (Direction == EDirection::eLeft) {

			//Check if on edge of 2D vector
			if (SnakeFrontPos[0] - 1 >= 0) {

				//Check if not colliding with Snek
				if (snakeGame.getStrPos(SnakeFrontPos[0] - 1, SnakeFrontPos[1]) != "S") {

					//If food is ahead
					if (snakeGame.getStrPos(SnakeFrontPos[0] - 1, SnakeFrontPos[1]) == "F") {
						(*this).addPart(snakeGame);
						snakeGame.removeFood(SnakeFrontPos[0] - 1, SnakeFrontPos[1]);
					}

					//If entering surface
					if (snakeGame.getStrPos(SnakeFrontPos[0] - 1, SnakeFrontPos[1]) == "A") {
						inAir = true;
					}
					else {
						inAir = false;
					}

					//Add to front
					SnakeParts.push_front(SnakePart(SnakeFrontPos[0] - 1, SnakeFrontPos[1], snakeGame));
					snakeGame.strEditPos("S", SnakeFrontPos[0] - 1, SnakeFrontPos[1]);
					//Remove from back
					SnakeParts.pop_back();
					snakeGame.strEditPos(".", SnakeBackPos[0], SnakeBackPos[1]);
					SnakeFrontPos[0] += -1;

					//Output for debugging
					if (snakeDebugOn) cout << "Snake - Moved Left" << endl;
				}
				else if (snakeGame.getStrPos(SnakeFrontPos[0] - 1, SnakeFrontPos[1]) == "S") {
					(*this).deleteSelf(snakeGame);
				}

			}
			else {
				(*this).deleteSelf(snakeGame);
			}
		}

		//Check Right Stuff
		else if (Direction == EDirection::eRight) {

			//Check if on edge of 2D vector
			if (SnakeFrontPos[0] + 1 <= snakeGame.getVector().size() - 1) {

				//Check if not colliding with Snek
				if (snakeGame.getStrPos(SnakeFrontPos[0] + 1, SnakeFrontPos[1]) != "S") {

					//If food is ahead
					if (snakeGame.getStrPos(SnakeFrontPos[0] + 1, SnakeFrontPos[1]) == "F") {
						(*this).addPart(snakeGame);
						snakeGame.removeFood(SnakeFrontPos[0] + 1, SnakeFrontPos[1]);
					}

					//If entering surface
					if (snakeGame.getStrPos(SnakeFrontPos[0] + 1, SnakeFrontPos[1]) == "A") {
						inAir = true;
					}
					else {
						inAir = false;
					}

					//Add to front
					SnakeParts.push_front(SnakePart(SnakeFrontPos[0] + 1, SnakeFrontPos[1], snakeGame));
					snakeGame.strEditPos("S", SnakeFrontPos[0] + 1, SnakeFrontPos[1]);
					//Remove from back
					SnakeParts.pop_back();
					snakeGame.strEditPos(".", SnakeBackPos[0], SnakeBackPos[1]);
					SnakeFrontPos[0] += 1;

					//Output for debugging
					if (snakeDebugOn) cout << "Snake - Moved Right" << endl;
				}
				else if (snakeGame.getStrPos(SnakeFrontPos[0] + 1, SnakeFrontPos[1]) == "S") {
					(*this).deleteSelf(snakeGame);
				}

			}
			else {
				(*this).deleteSelf(snakeGame);
			}
		}

		//Update back pos
		if (!dead) {
			SnakeBackPos[0] = SnakeParts.back().getX();
			SnakeBackPos[1] = SnakeParts.back().getY();

			//Output for debugging
			if (snakeDebugOn) cout << "Snake - Updated Back Position" << endl;
		}

	}
}

std::list<SnakePart>& Snake::getList() {
	return SnakeParts; //Returns list of snake parts
}

std::list<Bubble>& Snake::getBreathList() {
	return visualBreath; //Returns list of bubble objects
}

void Snake::addPart(Game snakeGame) {
	/*Adds part to the end of the snake based on the direction. Can look weird sometimes, because the back's direction isn't always the same as the
	front's direction, but it shouldn't affect gameplay at all*/
	if (Direction == EDirection::eUp) {
		SnakeParts.push_back(SnakePart(SnakeBackPos[0], SnakeBackPos[1] + 1, snakeGame));
	}
	else if (Direction == EDirection::eDown) {
		SnakeParts.push_back(SnakePart(SnakeBackPos[0], SnakeBackPos[1] - 1, snakeGame));
	}
	else if (Direction == EDirection::eLeft) {
		SnakeParts.push_back(SnakePart(SnakeBackPos[0] + 1, SnakeBackPos[1], snakeGame));
	}
	else if (Direction == EDirection::eRight) {
		SnakeParts.push_back(SnakePart(SnakeBackPos[0] - 1, SnakeBackPos[1], snakeGame));
	}
	if (snakeDebugOn) cout << "Snake - Added Part" << endl;
}

void Snake::deleteSelf(Game &snakeGame) {
	//Runs through all the snake parts and clears them on the 2D vector
	for (auto &p : SnakeParts) {
		snakeGame.strEditPos(".", p.getX(), p.getY());
	}

	//Clears all the snake part objects and bubble objects in their respective lists and sets the state to dead
	SnakeParts.clear();
	visualBreath.clear();
	dead = true;

	if (snakeDebugOn) cout << "Snake - Deleted Snake" << endl;
}

EDirection Snake::getDir() {
	return Direction;
}

bool Snake::getState() {
	return dead;
}

void Snake::checkBreath(Game &snakeGame) {
	//Only runs if the snake isn't dead
	if (!dead) {
		//If the snake isn't on the surface then the breath is lowered
		if (breathLeft > 0 && inAir == false) {
			breathLeft += -1;
			visualBreath.pop_back();
			if (snakeDebugOn) cout << "Snake - Lowered Remaining Breath" << endl;
		}
		//if the snake is on the surface the breath is reset to its maximum
		else if (breathLeft < maxBreath && inAir == true) {
			for (int i = 0; i < (maxBreath - breathLeft); i++) {
				visualBreath.push_back(Bubble((visualBreath.size() - 1), 0, snakeGame)); //Fills the bubble list with new objects
			}
			breathLeft = maxBreath;
			if (snakeDebugOn) cout << "Snake - Increased Remaining Breath" << endl;
		}
		//If the snake has 0 breath parts are taken off the back
		else if (breathLeft == 0) {
			//remove from back
			SnakeParts.pop_back();
			snakeGame.strEditPos(".", SnakeBackPos[0], SnakeBackPos[1]);
			if (snakeDebugOn) cout << "Snake - Removed Back Part" << endl;
			//check if dead
			if (SnakeParts.size() == 0) {
				(*this).deleteSelf(snakeGame);
			}
			//Update back pos
			SnakeBackPos[0] = SnakeParts.back().getX();
			SnakeBackPos[1] = SnakeParts.back().getY();
			if (snakeDebugOn) cout << "Snake - Updated Back Position" << endl;
		}
	}
}

void Snake::updateScore() {
	//Only runs if the snake isn't dead
	if (!dead) {
		//Update snake score
		score = SnakeParts.size() * 100;

		//Output for debugging
		if (snakeDebugOn) cout << "Snake - Updated Score" << endl;

		//Changing text
		scoreString = std::string("Score: ") + to_string(score);
		displayScore.setString(scoreString);
	}
}

sf::Text Snake::getScoreText() {
	return displayScore;
}