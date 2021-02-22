#pragma once
#include <string>

struct collDetector
{
	std::string objectID;
	int xPos{ 0 };
	int yPos{ 0 };
	int width{ 0 };
	int height{ 0 };
};