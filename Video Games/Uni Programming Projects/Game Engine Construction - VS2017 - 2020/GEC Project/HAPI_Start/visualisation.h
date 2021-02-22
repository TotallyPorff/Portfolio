#pragma once

#include "clipDetector.h"
#include "eDirection.h"

#include <HAPI_lib.h>
#include <vector>
#include <string>

using namespace HAPISPACE;

class sprite;

//Class to hold sprites and render them
class visualisation
{
private:
	//Sprites
	std::vector<sprite*> spriteVector;
	std::vector<int> animateSpriteIndex;
	int scrWidth;
	int scrHeight;
	//Clip Detectors
	std::vector<clipDetector*> clipVector;
	clipDetector screenRect;
	bool isOutside{ false };

public:
	visualisation(int screenWidth, int screenHeight);
	~visualisation();
	//Sprites
	std::string returnSprFilePath(std::string spriteID);
	bool addSprite(std::string ID, std::string filePath, int width, int height, float posX, float posY,
		int frames, int frameWidth, int frameHeight);
	bool changeSprite(std::string ID, std::string filePath, int width, int height,
		int frames, int frameWidth, int frameHeight);
	void renderSprites(bool alpha);
	void moveSprite(std::string spriteID, int xPosition, int yPosition, eDirection facing);
	//Sprite Animation
	void nextFrame();

	void clearScreen(int screenBufferSize);
};

