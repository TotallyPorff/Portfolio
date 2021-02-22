#include "object.h"

object::object(std::string objectID, int xPosition, int yPosition, int objWidth, int objHeight) {
	ID = objectID;
	posX = xPosition;
	posY = yPosition;
	width = objWidth;
	height = objHeight;
}

object::~object() {

}

std::string object::returnID() {
	return ID;
}

void object::setPosition(int xPosition, int yPosition) {
	posX = xPosition;
	posY = yPosition;
}

int object::getPosX() {
	return posX;
}

int object::getPosY() {
	return posY;
}

int object::getWidth() {
	return width;
}

int object::getHeight() {
	return height;
}

bool& object::getJump() {
	return jumping;
}

int& object::getXMomentum() {
	return xMomentum;
}

int& object::getYMomentum() {
	return yMomentum;
}