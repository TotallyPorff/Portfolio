	#pragma once
#include <HAPI_lib.h>
#include <vector>
#include <string>
#include "collDetector.h"
#include "entity.h"
#include "eDirection.h"

class visualisation;
class object;

class simulation
{
private:
	int scrWidth{ 0 };
	int scrHeight{ 0 };
	int scrBufferSize{ 0 };

	//Score
	int score{ 0 };
	int scoreFrames{ 0 }; //used to count number of frames since last time score was increased
	std::vector<int> digitIndx;  //stores the index number in the objectVector of each digit created

	//Inputs for control
	int leftXAnalogue{ 0 };
	int leftYAnalogue{ 0 };

	//Movement
	int gravity{ 0 };
	int maxFallSpeed{ 0 };

	//Object stuff
	std::vector<object*> objectVector;
	std::vector<collDetector*> solidVector;
	std::vector<entity*> entityVector;

	//Visualisation stuff
	visualisation* visObject{ NULL };

public:
	//General Stuff
	simulation(int screenWidth, int screenHeight, int screenBufferSize, int simGravity, int simMaxFallSpeed);
	~simulation();
	void update(bool alpha); //frame speed update
	void GSupdate(bool keepScore); //game speed update

	//Object stuff
	void createObject(std::string objectID, int xPos, int yPos, bool solid, int width, int height);
	void controlPlayer(std::string objectID, bool controller, int speed, int maxSpeed, int jumpPower);
	void enemyAI(std::string enemyID, int speed, int maxSpeed, int jumpPower, eDirection direction);
	void moveObject(std::string objectID, int xInput, int yInput, int speed, int maxSpeed, int jumpPower);
	int ObjXMomentum(std::string objectID);
	int ObjYMomentum(std::string objectID);
	
	//Score stuff
	void createScoreCounter();
	void updateScore();
	int numOfDigits(int number);

	//Entity stuff
	void isEntity(std::string objectID, std::string groupID, int health, int damage, int invincFrames);
	void updateInvincFrames(); //Used to update any object that has been recently damaged and is currently invincible
	bool entityIsDead(std::string objectID);

	//Scrolling stuff
	void backScroll(std::string object1ID, std::string object2ID, int speed, eDirection direction);
	void platformScroll(std::string objectID, int respawnXPos, int respawnYPos, int speed, eDirection direction);

	//visualisation stuff
	void visAddSprite(std::string objectID, std::string filePath, int width, int height, float posX, float posY,
		int frames, int frameWidth, int frameHeight);
	void visChangeSprite(std::string objectID, std::string filePath, int width, int height,
		int frames, int frameWidth, int frameHeight);
	std::string visReturnSprFilePath(std::string spriteID);

	//controls stuff
	void checkAnalogue(int& leftXAnalogue, int& leftYAnalogue);
	void toggleRumble(bool on);
};

