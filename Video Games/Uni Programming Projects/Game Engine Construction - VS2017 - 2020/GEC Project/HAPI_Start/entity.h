#pragma once
#include <string>

struct entity
{
	std::string objectID;
	std::string groupTag;
	int maxHealth{ 0 };
	int currentHealth{ 0 };
	int damage{ 0 }; //The damage it deals upon contact
	int maxInvincFrames{ 0 }; //Invincibility for a short time after being damaged
	int currentInvincFrames{ 0 };
	bool isInvincible{ 0 };
};