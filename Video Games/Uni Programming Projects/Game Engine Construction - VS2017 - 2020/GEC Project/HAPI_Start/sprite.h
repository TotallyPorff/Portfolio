#pragma once
#include <HAPI_lib.h>
#include "eDirection.h"

using namespace HAPISPACE;

class sprite
{
private:
	std::string spriteID;

	BYTE* texData{ nullptr };
	int texWidth;
	int texHeight;
	float texPosX;
	float texPosY;
	std::string path;

	eDirection direction{ eDirection::right };

	bool animated{ false };
	int spriteFrames{ 0 }; //If = 0 or 1, sprite isnt animated
	int frameWidth{ 0 };
	int frameHeight{ 0 };
	int currentFrame{ 0 }; //starts from 0

public:
	sprite(std::string ID, std::string filePath, int width, int height, float posX, float posY);
	~sprite();
	std::string returnID();
	std::string returnFilePath();
	void changeFile(std::string filePath, int width, int height);

	//Animation
	void isAnimated(int frames, int widthFrame, int heightFrame);
	void nextFrame();
	//Rendering
	bool loadSprite();
	void renderTexLine(int screenWidth, int xClipOffset, int xClipRestrict, int yClipOffset, int yClipRestrict);
	void renderTexTransparent(int screenWidth, int xClipOffset, int xClipRestrict, int yClipOffset, int yClipRestrict);
	//Movement
	void moveSprite(int xPos, int yPos, eDirection facing);
	float getX();
	float getY();
};

