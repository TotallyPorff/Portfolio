#include "visualisation.h"
#include "sprite.h"
#include "clipDetector.h"

#include <HAPI_lib.h>
#include <vector>
#include <string>

using namespace HAPISPACE;

visualisation::visualisation(int screenWidth, int screenHeight) {
	scrWidth = screenWidth;
	scrHeight = screenHeight;

	//Generate Screen clip box
	clipDetector screen;
	screen.xPos = 0;
	screen.yPos = 0;
	screen.width = screenWidth;
	screen.height = screenHeight;
	screenRect = screen;
}

visualisation::~visualisation() {
	//Clean memory
	for (int i = 0; i < spriteVector.size(); i++) {
		delete spriteVector[i];
	}
	for (int i = 0; i < clipVector.size(); i++) {
		delete clipVector[i];
	}
}

std::string visualisation::returnSprFilePath(std::string spriteID) {
	for (int i = 0; i < spriteVector.size(); i++) {
		if (spriteVector[i]->returnID() == spriteID) {
			return spriteVector[i]->returnFilePath();
		}
	}
	return "";
}

bool visualisation::addSprite(std::string ID, std::string filepath, int width, int height, float posX, float posY,
	int frames, int frameWidth, int frameHeight)
{
	//Generate Sprite Object
	sprite* sprPntr = new sprite(ID, filepath, width, height, posX, posY);
	spriteVector.push_back(sprPntr);
	if (!spriteVector.back()->loadSprite()) {
		return false;
	}
	//Makes note of what sprite index it is in the vector if it is animated
	if (frames != 0 && frames != 1)
	{
		_ASSERT(spriteVector.size() > 0);
		animateSpriteIndex.push_back((int)(spriteVector.size() - 1));
		spriteVector.back()->isAnimated(frames, frameWidth, frameHeight);

		//Generate Clip Detector using frame size
		clipDetector* clipPntr = new clipDetector();
		clipPntr->spriteID = ID;
		clipPntr->xPos = int(posX);
		clipPntr->yPos = int(posY);
		clipPntr->width = frameWidth;
		clipPntr->height = frameHeight;
		clipVector.push_back(clipPntr);
	}
	else {
		//Generate Clip Detector using entire sprite
		clipDetector* clipPntr = new clipDetector();
		clipPntr->spriteID = ID;
		clipPntr->xPos = int(posX);
		clipPntr->yPos = int(posY);
		clipPntr->width = width;
		clipPntr->height = height;
		clipVector.push_back(clipPntr);
	}

	return true;
}

bool visualisation::changeSprite(std::string ID, std::string filePath, int width, int height,
	int frames, int frameWidth, int frameHeight)
{
	//Searches through the vector to get the sprite with the matching ID
	for (int i = 0; i < spriteVector.size(); i++) {
		if (spriteVector[i]->returnID() == ID) {
			spriteVector[i]->changeFile(filePath, width, height);
			//Loads sprite
			if (!spriteVector[i]->loadSprite()) {
				return false;
			}
			
			//Checks if already animated when animation is true
			if (frames != 0 && frames != 1) {
				spriteVector[i]->isAnimated(frames, frameWidth, frameHeight);

				bool alreadyAnimated{ false };
				for (int j = 0; j < animateSpriteIndex.size(); j++) {
					if (animateSpriteIndex[j] == i) {
						alreadyAnimated = true;
					}
				}
				if (!alreadyAnimated) {
					animateSpriteIndex.push_back(i);
				}

				clipVector[i]->width = frameWidth;
				clipVector[i]->height = frameHeight;
			}
			else {
				for (int j = 0; j < animateSpriteIndex.size(); j++) {
					if (animateSpriteIndex[j] == i) {
						animateSpriteIndex.erase(animateSpriteIndex.begin() + j);
					}
				}

				clipVector[i]->width = width;
				clipVector[i]->height = height;
			}
		}
	}
	return true;
}

void visualisation::renderSprites(bool alpha) {
	if (spriteVector.size() == clipVector.size()) { //Makes sure both vectors are the same size
		for (int i = 0; i < spriteVector.size(); i++) { //Loops through sprite vector
			int xClipOffset{ 0 };
			int xClipRestrict{ 0 };

			int yClipOffset{ 0 };
			int yClipRestrict{ 0 };

			/* Detect Clipping */
			isOutside = false;

			//Left of Screen Rectangle
			if (clipVector[i]->xPos + clipVector[i]->width < screenRect.xPos) { //If right side is outside of screen rectangle left
				isOutside = true; //Dont Render
			}
			else if (clipVector[i]->xPos < screenRect.xPos) { //Else if left side is outside of screen rectangle left
				xClipOffset = clipVector[i]->xPos * -1;
			}

			//Right of Screen Rectangle
			if (clipVector[i]->xPos > screenRect.width) { //If left side is outside of screen rectangle right
				isOutside = true; //Dont Render
			}
			else if (clipVector[i]->xPos + clipVector[i]->width > screenRect.width) { //If right side is outside of screen rectangle right
				xClipRestrict = (clipVector[i]->xPos + clipVector[i]->width) - scrWidth;
			}

			//Top of Screen Rectangle
			if (clipVector[i]->yPos + clipVector[i]->height < screenRect.yPos) { //If bottom side is outside of screen rectangle top
				isOutside = true; //Dont Render
			}
			else if (clipVector[i]->yPos < screenRect.yPos) { //Else if top side is outside of screen rectangle top
				yClipOffset = clipVector[i]->yPos * -1;
			}
			//Bottom of Screen Rectangle
			if (clipVector[i]->yPos > screenRect.height) { //If top side is outside of screen rectangle bottom
				isOutside = true; //Dont Render
			}
			else if (clipVector[i]->yPos + clipVector[i]->height > screenRect.height) { //Else if bottom side is outside of screen rectangle bottom
				yClipRestrict = (clipVector[i]->yPos + clipVector[i]->height) - scrHeight;
			}

			if (!isOutside) {
				/* Render Sprite */
				if (alpha) {
					spriteVector[i]->renderTexTransparent(scrWidth, xClipOffset, xClipRestrict, yClipOffset, yClipRestrict);
				}
				else {
					spriteVector[i]->renderTexLine(scrWidth, xClipOffset, xClipRestrict, yClipOffset, yClipRestrict);
				}
			}
		}
	}
}

void visualisation::moveSprite(std::string spriteID, int xPosition, int yPosition, eDirection facing) {
	for (int i = 0; i < spriteVector.size(); i++) {
		if (spriteVector[i]->returnID() == spriteID) {
			spriteVector[i]->moveSprite(xPosition, yPosition, facing);

			for (int j = 0; j < clipVector.size(); j++) {
				if (clipVector[j]->spriteID == spriteID) {
					clipVector[j]->xPos = (int)spriteVector[i]->getX();
					clipVector[j]->yPos = (int)spriteVector[i]->getY();
				}
			}
		}
	}
}

void visualisation::nextFrame() {
	for (int i = 0; i < animateSpriteIndex.size(); i++) {
		spriteVector[animateSpriteIndex[i]]->nextFrame();
	}
}

//Clear screen to colour
void visualisation::clearScreen(int screenBufferSize) {
	//Set colour to variable
	HAPI_TColour col(HAPI_TColour::BLACK);

	//Get first point in memory
	BYTE* screen = HAPI.GetScreenPointer();

	for (int i = 0; i < screenBufferSize; i += 4) { //Loop every 4 through memory, which is basically every pixel on the screen
		BYTE* pnter = screen + i; //Point to first byte of current pixel
		memcpy(pnter, &col, 4); //Set pixel to colour
	}
}