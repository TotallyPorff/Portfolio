#include "sprite.h"
#include <HAPI_lib.h>

using namespace HAPISPACE;

sprite::sprite(std::string ID, std::string filePath, int width, int height, float posX, float posY) {
	spriteID = ID;
	texWidth = width;
	texHeight = height;
	texPosX = posX;
	texPosY = posY;
	path = filePath;
}

sprite::~sprite() {
	delete[]texData;
}

std::string sprite::returnID() {
	return spriteID;
}

std::string sprite::returnFilePath() {
	return path;
}

void sprite::changeFile(std::string filePath, int width, int height) {
	texWidth = width;
	texHeight = height;
	path = filePath;

	//Resets animation details to avoid breaking it
	animated = false;
	spriteFrames = 0; //If = 0 or 1, sprite isnt animated
	frameWidth = 0;
	frameHeight = 0;
	currentFrame = 0; //starts from 0
}

void sprite::isAnimated(int frames, int widthFrame, int heightFrame) {
	animated = true;
	spriteFrames = frames - 1;
	frameWidth = widthFrame;
	frameHeight = heightFrame;
	currentFrame = 0;
}

void sprite::nextFrame() {
	currentFrame += 1;
	if (currentFrame > spriteFrames) {
		currentFrame = 0;
	}
}

bool sprite::loadSprite() {
	BYTE** pointer_to_texData = &(this->texData);
	//Loading Texture
	if (!HAPI.LoadTexture(path, pointer_to_texData, texWidth, texHeight))
	{
		HAPI.UserMessage("Unable to load texture" + path, "Uh Oh!");
		return false;
	}
	else {
		return true;
	}
}

void sprite::renderTexLine(int screenWidth, int xClipOffset, int xClipRestrict, int yClipOffset, int yClipRestrict) {
	//Variables
	int screenOffset{ 0 };
	int texOffset{ 0 };
	int originPos;
	int bytesInLine{ (texWidth - xClipOffset - xClipRestrict) * 4};
	int xOffset = xClipOffset * 4;
	int yOffset = yClipOffset * 4;

	//Get first point in memory for the screen & texture
	originPos = (((int)texPosY * screenWidth) + (int)texPosX) * 4;
	BYTE* tempScreen = HAPI.GetScreenPointer() + originPos;

	//Load texture onto screen
	for (int y = yClipOffset; y < texHeight - yClipRestrict; y++) {
		//Changing Offsets
		screenOffset = (screenWidth * y) * 4;
		texOffset = (texWidth * y) * 4;

		BYTE* pnter = tempScreen + screenOffset + xOffset; //Point to first byte of screen pixel + offset
		BYTE* texPnter = texData + texOffset + xOffset; //Point to first byte of texture + offset
		memcpy(pnter, texPnter, bytesInLine); //Set pixel to colour
	}
}

void sprite::renderTexTransparent(int screenWidth, int xClipOffset, int xClipRestrict, int yClipOffset, int yClipRestrict) {
	//Variables
	int screenOffset{ 0 };
	int texOffset{ 0 };
	int originPos;

	if (!animated) {
		//Get first point in memory for the screen & texture
		originPos = (((int)texPosY * screenWidth) + (int)texPosX) * 4;
		BYTE* tempScreen = HAPI.GetScreenPointer() + originPos;

		//Load texture onto screen
		for (int y = yClipOffset; y < texHeight - yClipRestrict; y++) {
			for (int x = xClipOffset; x < texWidth - xClipRestrict; x++) {
				//Changing Offsets
				screenOffset = ((y * screenWidth) + x) * 4;
				if (direction == eDirection::right) {
					texOffset = ((y * texWidth) + x) * 4;
				}
				else if (direction == eDirection::left) {
					//xFlip takes the x, and minus it from the right side of the sprite
					int xFlip = texWidth - x;
					texOffset = ((y * texWidth) + xFlip) * 4;
				}

				//Set pointers
				BYTE* pnter = tempScreen + screenOffset; //Point to first byte of screen pixel + offset
				BYTE* texPnter = texData + texOffset; //Point to first byte of texture + offset + clipping offset
				BYTE alpha = texPnter[3];

				if (alpha != 0) {
					if (alpha == 255) {
						memcpy(pnter, texPnter, 4); //Set pixel to colour
					}
					else {
						//Get colours
						BYTE red = texPnter[0];
						BYTE green = texPnter[1];
						BYTE blue = texPnter[2];
						//Apply to screen
						pnter[0] = pnter[0] + ((alpha * (red - pnter[0])) >> 8);
						pnter[1] = pnter[1] + ((alpha * (green - pnter[1])) >> 8);
						pnter[2] = pnter[2] + ((alpha * (blue - pnter[2])) >> 8);
					}
				}
			}
		}
	}
	else {
		//Setting the frame restricts so that it only shows that frame
		int frameXOffset = (currentFrame * frameWidth);
		int frameXRestrict = texWidth - (frameXOffset + frameWidth);

		//Get first point in memory for the screen & texture
		originPos = (((int)texPosY * screenWidth) + ((int)texPosX - frameXOffset)) * 4;
		BYTE* tempScreen = HAPI.GetScreenPointer() + originPos;

		//Load texture onto screen
		for (int y = yClipOffset; y < texHeight - yClipRestrict; y++) {
			for (int x = xClipOffset + frameXOffset; x < texWidth - xClipRestrict - frameXRestrict; x++) {
				//Changing Offsets
				screenOffset = ((y * screenWidth) + x) * 4;
				if (direction == eDirection::right) {
					texOffset = ((y * texWidth) + x) * 4;
				}
				else if (direction == eDirection::left) {
					//xFlip takes the x within the frame, and minus it from the right side of the frame
					int xFlip = (texWidth - frameXRestrict - (x - frameXOffset));
					texOffset = ((y * texWidth) + xFlip) * 4;
				}

				//Set pointers
				BYTE* pnter = tempScreen + screenOffset; //Point to first byte of screen pixel + offset
				BYTE* texPnter = texData + texOffset; //Point to first byte of texture + offset
				BYTE alpha = texPnter[3];

				if (alpha != 0) {
					if (alpha == 255) {
						memcpy(pnter, texPnter, 4); //Set pixel to colour
					}
					else {
						//Get colours
						BYTE red = texPnter[0];
						BYTE green = texPnter[1];
						BYTE blue = texPnter[2];
						//Apply to screen
						pnter[0] = pnter[0] + ((alpha * (red - pnter[0])) >> 8);
						pnter[1] = pnter[1] + ((alpha * (green - pnter[1])) >> 8);
						pnter[2] = pnter[2] + ((alpha * (blue - pnter[2])) >> 8);
					}
				}
			}
		}
	}
}

void sprite::moveSprite(int xPos, int yPos, eDirection facing) {
	texPosX = (float)xPos;
	texPosY = (float)yPos;
	if (facing != eDirection::prevDir) {
		direction = facing;
	}
}

float sprite::getX() {
	return texPosX;
}

float sprite::getY() {
	return texPosY;
}