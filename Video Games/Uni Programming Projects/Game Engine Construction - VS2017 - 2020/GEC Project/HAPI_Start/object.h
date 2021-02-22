#pragma once
#include <HAPI_lib.h>
#include <string>

class object
{
private:
	std::string ID;
	int posX;
	int posY;
	int width;
	int height;
	bool jumping{ false };
	int xMomentum{ 0 };
	int yMomentum{ 0 };

public:
	object(std::string objectID, int xPosition, int yPosition, int objWidth, int objHeight);
	~object();
	std::string returnID();

	void setPosition(int xPosition, int yPosition);
	int getPosX();
	int getPosY();
	int getWidth();
	int getHeight();
	bool& getJump();
	int& getXMomentum();
	int& getYMomentum();
};

