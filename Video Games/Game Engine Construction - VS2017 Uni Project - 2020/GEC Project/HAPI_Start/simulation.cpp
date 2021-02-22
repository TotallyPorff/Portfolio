#include "simulation.h"
#include "visualisation.h"
#include "object.h"
#include "collDetector.h"

#include <HAPI_lib.h>
#include <vector>
#include <string>

using namespace HAPISPACE;

simulation::simulation(int screenWidth, int screenHeight, int screenBufferSize, int simGravity, int simMaxFallSpeed) {
	visualisation* visPntr = new visualisation(screenWidth, screenHeight);
	visObject = visPntr;
	scrWidth = screenWidth;
	scrHeight = screenHeight;
	scrBufferSize = screenBufferSize;
	gravity = simGravity;
	maxFallSpeed = simMaxFallSpeed;
}

simulation::~simulation() {
	for (int i = 0; i < objectVector.size(); i++) {
		delete objectVector[i];
	}
	for (int i = 0; i < solidVector.size(); i++) {
		delete solidVector[i];
	}
	for (int i = 0; i < entityVector.size(); i++) {
		delete entityVector[i];
	}
	delete visObject;
}

void simulation::update(bool alpha) {
	visObject->clearScreen(scrBufferSize);
	visObject->renderSprites(alpha);
}

void simulation::GSupdate(bool keepScore) {
	visObject->nextFrame();
	this->updateInvincFrames();

	if (keepScore) {
		scoreFrames += 1;
		if (scoreFrames >= 20) { //per second
			scoreFrames = 0;
			score += 1;
		}

		this->updateScore();
	}
}

void simulation::createScoreCounter() {
	for (int i = 0; i < 5; i++) {
		//Creates object
		object* objPntr = new object("digit" + std::to_string(i), -100, -100, 16, 24);
		objectVector.push_back(objPntr);
		//adds index to digitIndx
		digitIndx.push_back((int)objectVector.size() - 1);
		//Creates Sprite
		this->visAddSprite("digit" + std::to_string(i), "Data\\Text\\Number0.png", 16, 24, -100, -100, 0, 0, 0);
	}
}

void simulation::updateScore() {
	int counterStartPosX;
	int numOfDigits;
	int digitSeperator;
	int digitNum;
	std::string filepath;

	//Make sure digitIndx isnt 0
	if (digitIndx.size() != 0) {
		//Checks the number of digits and adjusts the score counter
		numOfDigits = this->numOfDigits(score);

		if (numOfDigits != 6) { //5 digits is the limit

			counterStartPosX = (scrWidth - (numOfDigits * 16)) / 2;

			for (int i = 0; i < numOfDigits; i++) {
				//moves digits into correct position
				objectVector[digitIndx[i]]->setPosition(counterStartPosX + (i * 16), 10);
				visObject->moveSprite(objectVector[digitIndx[i]]->returnID(), counterStartPosX + (i * 16), 10, eDirection::prevDir);

				//updates all of the digits to be the correct number
				digitSeperator = (int)std::pow(10.0, (numOfDigits - 1) - i);
				if (digitSeperator < 0) digitSeperator = 0;
				digitNum = (score / digitSeperator) % 10;
				filepath = "Data\\Text\\Number" + std::to_string(digitNum) + ".png";
				visObject->changeSprite(objectVector[digitIndx[i]]->returnID(), filepath, 16, 24, 0, 0, 0);
			}
		}
		else {
			counterStartPosX = (scrWidth - ((int)digitIndx.size() * 16)) / 2;

			for (int i = 0; i < digitIndx.size(); i++) {
				//moves digits into correct position
				objectVector[digitIndx[i]]->setPosition(counterStartPosX + (i * 16), 10);
				visObject->moveSprite(objectVector[digitIndx[i]]->returnID(), counterStartPosX + (i * 16), 10, eDirection::prevDir);

				//updates all of the digits to be the correct number
				filepath = "Data\\Text\\Number9.png";
				visObject->changeSprite(objectVector[digitIndx[i]]->returnID(), filepath, 16, 24, 0, 0, 0);
			}
		}
	}
}

int simulation::numOfDigits(int number) {
	if (number >= 10) {
		if (number >= 100) {
			if (number >= 1000) {
				if (number >= 10000) {
					if (number >= 100000) {
						return 6;
					}
					else {
						return 5;
					}
				}
				else {
					return 4;
				}
			}
			else {
				return 3;
			}
		}
		else {
			return 2;
		}
	}
	else {
		return 1;
	}
}

void simulation::createObject(std::string objectID, int xPos, int yPos, bool solid, int width, int height) {
	object* objPntr = new object(objectID, xPos, yPos, width, height);
	objectVector.push_back(objPntr);
	if (solid) {
		collDetector* solidPntr = new collDetector();
		solidPntr->objectID = objectID;
		solidPntr->width = width;
		solidPntr->height = height;
		solidPntr->xPos = xPos;
		solidPntr->yPos = yPos;
		solidVector.push_back(solidPntr);
	}
}

void simulation::visAddSprite(std::string objectID, std::string filePath, int width, int height, float posX, float posY,
	int frames, int frameWidth, int frameHeight) {
	if (!visObject->addSprite(objectID, filePath, width, height, posX, posY, frames, frameWidth, frameHeight)) {
		HAPI.Close();
	}
}

void simulation::visChangeSprite(std::string objectID, std::string filePath, int width, int height,
	int frames, int frameWidth, int frameHeight) {
	if (!visObject->changeSprite(objectID, filePath, width, height, frames, frameWidth, frameHeight)) {
		HAPI.Close();
	}
}

std::string simulation::visReturnSprFilePath(std::string spriteID) {
	return visObject->returnSprFilePath(spriteID);
}

void simulation::controlPlayer(std::string objectID, bool controller, int speed, int maxSpeed, int jumpPower) {
	int xInput{ 0 };
	int yInput{ 0 };

	/*   INPUT CHECKING   */
	//Moves with controller
	if (controller) {
		//Checks if controller is there
		this->checkAnalogue(leftXAnalogue, leftYAnalogue);
		//Checks input
		const HAPI_TControllerData contData = HAPI.GetControllerData(0);
		if (contData.isAttached) {
			//Move sprites Analogue
			//X
			if (leftXAnalogue > 0) { //Right
				xInput = 1;
			}
			else if (leftXAnalogue < 0) { //Left
				xInput = -1;
			}
			else {
				xInput = 0;
			}
			//Y
			if (leftYAnalogue < 0) { //Down
				yInput = 1;
			}
			else if (leftYAnalogue > 0) { //Up
				yInput = -1;
			}
			else {
				yInput = 0;
			}
		}
	}
	else { //Moves with keyboard
		//X
		if (HAPI.GetKeyboardData().scanCode[HK_RIGHT]) { //Right
			xInput = 1;
		}
		else if (HAPI.GetKeyboardData().scanCode[HK_LEFT]) { //Left
			xInput = -1;
		}
		else {
			xInput = 0;
		}
		//Y
		if (HAPI.GetKeyboardData().scanCode[HK_DOWN]) { //Down
			yInput = 1;
		}
		else if (HAPI.GetKeyboardData().scanCode[HK_UP]) { //Up
			yInput = -1;
		}
		else {
			yInput = 0;
		}
	}

	for (int plyrIndx = 0; plyrIndx < objectVector.size(); plyrIndx++) {
		if (objectVector[plyrIndx]->returnID() == objectID) {
			if (objectVector[plyrIndx]->getPosY() > scrHeight + 50) {

				int plyrEnt{ 0 };
				while (entityVector[plyrEnt]->objectID != objectID && plyrEnt < entityVector.size()) {
					plyrEnt += 1;
				}
				if (entityVector[plyrEnt]->objectID == objectID) {
					entityVector[plyrEnt]->currentHealth = 0;
				}
			}
		}
	}

	this->moveObject(objectID, xInput, yInput, speed, maxSpeed, jumpPower);
}

void simulation::enemyAI(std::string enemyID, int speed, int maxSpeed, int jumpPower, eDirection direction) {
	int xInput{ 0 };
	int yInput{ 0 };

	for (int enmyIndx = 0; enmyIndx < objectVector.size(); enmyIndx++) {
		if (objectVector[enmyIndx]->returnID() == enemyID) {
			//Setting inputs
			if (direction == eDirection::left) {
				xInput = -1;
				//teleports to top if at the bottom
				if (objectVector[enmyIndx]->getPosY() > scrHeight) {
					objectVector[enmyIndx]->setPosition(scrWidth - objectVector[enmyIndx]->getWidth(), -objectVector[enmyIndx]->getHeight());
				}
			}
			else {
				xInput = 1;
				//teleports to top if at the bottom
				if (objectVector[enmyIndx]->getPosY() > scrHeight) {
					objectVector[enmyIndx]->setPosition(0, -objectVector[enmyIndx]->getHeight());
				}
			}
			yInput = -1;
		}
	}

	this->moveObject(enemyID, xInput, yInput, speed, maxSpeed, jumpPower);
}

void simulation::moveObject(std::string objectID, int xInput, int yInput, int speed, int maxSpeed, int jumpPower) {
	int prevXPos{ 0 };
	int prevYPos{ 0 };
	bool isColliding{ false };

	/*   MOVEMENT   */
	for (int i = 0; i < objectVector.size(); i++) {
		if (objectVector[i]->returnID() == objectID) {
			//Checks if object is dead entity
			if (!this->entityIsDead(objectID)) {
				//Grabs current Position
				prevXPos = objectVector[i]->getPosX();
				prevYPos = objectVector[i]->getPosY();

				//GRAVITY & JUMPING
				//applies gravity before checking for collisions, as collisions will reset the momentum
				objectVector[i]->getYMomentum() += gravity;
				if (objectVector[i]->getYMomentum() > maxFallSpeed) {
					objectVector[i]->getYMomentum() = maxFallSpeed;
				}
				//Jumping
				if (yInput < 0) {
					if (objectVector[i]->getJump() == false) { //Checks to see if it isnt already jumping
						objectVector[i]->getYMomentum() = -jumpPower;
						objectVector[i]->getJump() = true;
					}
				}

				//COLLISION FOR Y
				//Searches for object in solid vector
				for (int ID = 0; ID < solidVector.size(); ID++) {
					if (solidVector[ID]->objectID == objectID) {
						//Compares to other objects
						for (int Other = 0; Other < solidVector.size(); Other++) {
							if (solidVector[Other]->objectID != objectID) {
								isColliding = false;

								//X
								//if Left of ID < Right of Other
								if (solidVector[ID]->xPos < solidVector[Other]->xPos + solidVector[Other]->width) {
									//if Right of ID > Left of Other
									if (solidVector[ID]->xPos + solidVector[ID]->width > solidVector[Other]->xPos) {

										//if bottom of ID + momentum < bottom of other
										if (solidVector[ID]->yPos + solidVector[ID]->height + objectVector[i]->getYMomentum() <
											solidVector[Other]->yPos + solidVector[Other]->height) {
											//if bottom of ID + momentum > top of other - gravity
											if (solidVector[ID]->yPos + solidVector[ID]->height + objectVector[i]->getYMomentum() >
												solidVector[Other]->yPos - 1) {
												//Make the momentum equal 0;
												objectVector[i]->getYMomentum() = 0;
												objectVector[i]->getJump() = false;
												isColliding = true;
											}
										}

										//If top of ID + momentum < bottom of other
										if (solidVector[ID]->yPos + objectVector[i]->getYMomentum() <
											solidVector[Other]->yPos + solidVector[Other]->height) {
											//if top of ID + momentum > top of other
											if (solidVector[ID]->yPos + objectVector[i]->getYMomentum() >
												solidVector[Other]->yPos) {
												//Make the momentum equal 5
												objectVector[i]->getYMomentum() = 5;
												isColliding = true;
											}
										}
									}
								}

								//Update entities
								if (isColliding) {
									//Checks if object is an entity
									for (int entID = 0; entID < entityVector.size(); entID++) {
										if (entityVector[entID]->objectID == objectID) {
											//Checks if colliding object is an entity
											for (int entOther = 0; entOther < entityVector.size(); entOther++) {
												if (entityVector[entOther]->objectID == solidVector[Other]->objectID) {
													if (entityVector[entID]->groupTag != entityVector[entOther]->groupTag) {
														if (!entityVector[entID]->isInvincible) {
															entityVector[entID]->currentHealth += -entityVector[entOther]->damage;
															entityVector[entID]->isInvincible = true;
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}

				/*   HORIZONTAL MOVEMENT   */
				if (xInput != 0) {
					objectVector[i]->getXMomentum() += speed * xInput;
					if (objectVector[i]->getXMomentum() > maxSpeed) { //Max speed right
						objectVector[i]->getXMomentum() = maxSpeed;
					}
					else if (objectVector[i]->getXMomentum() < -maxSpeed) { //Max speed left
						objectVector[i]->getXMomentum() = -maxSpeed;
					}
				}
				else {
					if (objectVector[i]->getXMomentum() > 0) { //Decrease speed right
						objectVector[i]->getXMomentum() += -1;
					}
					else if (objectVector[i]->getXMomentum() < 0) { //Decrease speed left
						objectVector[i]->getXMomentum() += 1;
					}
				}
				//COLLISION FOR X
				//Searches for object in solid vector
				for (int ID = 0; ID < solidVector.size(); ID++) {
					if (solidVector[ID]->objectID == objectID) {
						//Compares to other objects
						for (int Other = 0; Other < solidVector.size(); Other++) {
							if (solidVector[Other]->objectID != objectID) {
								isColliding = false;

								//Y
								//if Top of ID < Bottom of Other
								if (solidVector[ID]->yPos < solidVector[Other]->yPos + solidVector[Other]->height) {
									//if Bottom of ID > Top of Other
									if (solidVector[ID]->yPos + solidVector[ID]->height > solidVector[Other]->yPos) {

										//If moving left
										if (objectVector[i]->getXMomentum() < 0) {
											//If left of ID + momentum < right of other
											if (solidVector[ID]->xPos + objectVector[i]->getXMomentum() > solidVector[Other]->xPos) {
												//If left of ID + momentum > left of other
												if (solidVector[ID]->xPos + objectVector[i]->getXMomentum() < solidVector[Other]->xPos
													+ solidVector[Other]->width) {
													//Make momentum equal distance between the two objects
													objectVector[i]->getXMomentum() = 0;
													isColliding = true;
												}
											}
										}

										//If moving right
										else if (objectVector[i]->getXMomentum() > 0) {
											//If right of ID + momentum < right of other
											if (solidVector[ID]->xPos + solidVector[ID]->width + objectVector[i]->getXMomentum() >
												solidVector[Other]->xPos) {
												//If right of ID + momentum > left of other
												if (solidVector[ID]->xPos + solidVector[ID]->width + objectVector[i]->getXMomentum() <
													solidVector[Other]->xPos + solidVector[Other]->width) {
													//Make momentum equal distance between the two objects
													objectVector[i]->getXMomentum() = 0;
													isColliding = true;
												}
											}
										}
									}
								}

								//Update entities
								if (isColliding) {
									//Checks if object is an entity
									for (int entID = 0; entID < entityVector.size(); entID++) {
										if (entityVector[entID]->objectID == objectID) {
											//Checks if colliding object is an entity
											for (int entOther = 0; entOther < entityVector.size(); entOther++) {
												if (entityVector[entOther]->objectID == solidVector[Other]->objectID) {
													if (entityVector[entID]->groupTag != entityVector[entOther]->groupTag) {
														entityVector[entID]->currentHealth += -entityVector[entOther]->damage;
														entityVector[entID]->isInvincible = true;
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}

				/*   UPDATING OBJECTS   */
				//Updates Object
				objectVector[i]->setPosition(prevXPos + objectVector[i]->getXMomentum(), prevYPos + objectVector[i]->getYMomentum());

				//Updates Collider
				for (int j = 0; j < solidVector.size(); j++) {
					if (solidVector[j]->objectID == objectID) {
						solidVector[j]->xPos = objectVector[i]->getPosX();
						solidVector[j]->yPos = objectVector[i]->getPosY();
					}
				}

				//Updates Sprite
				if (objectVector[i]->getXMomentum() > 0) {
					visObject->moveSprite(objectID, objectVector[i]->getPosX(), objectVector[i]->getPosY(), eDirection::right);
				}
				else if (objectVector[i]->getXMomentum() < 0) {
					visObject->moveSprite(objectID, objectVector[i]->getPosX(), objectVector[i]->getPosY(), eDirection::left);
				}
				else {
					visObject->moveSprite(objectID, objectVector[i]->getPosX(), objectVector[i]->getPosY(), eDirection::prevDir);
				}
			}
			else {
				if (objectVector[i]->getPosX() != -100 && objectVector[i]->getPosY() != -100) {
					//Updates object
					objectVector[i]->setPosition(-100, -100);

					//Updates Collider
					for (int j = 0; j < solidVector.size(); j++) {
						if (solidVector[j]->objectID == objectID) {
							solidVector[j]->xPos = -100;
							solidVector[j]->yPos = -100;
						}
					}

					//Updates sprite
					visObject->moveSprite(objectID, -100, -100, eDirection::prevDir);
				}
			}
		}
	}
}

int simulation::ObjXMomentum(std::string objectID) {
	for (int i = 0; i < objectVector.size(); i++) {
		if (objectVector[i]->returnID() == objectID) {
			return objectVector[i]->getXMomentum();
		}
	}
	return 0;
}

int simulation::ObjYMomentum(std::string objectID) {
	for (int i = 0; i < objectVector.size(); i++) {
		if (objectVector[i]->returnID() == objectID) {
			return objectVector[i]->getYMomentum();
		}
	}
	return 0;
}

void simulation::isEntity(std::string objectID, std::string groupID, int health, int damage, int invincFrames) {
	entity* entPntr = new entity();
	entPntr->objectID = objectID;
	entPntr->groupTag = groupID;
	entPntr->maxHealth = health;
	entPntr->currentHealth = health;
	entPntr->damage = damage;
	entPntr->maxInvincFrames = invincFrames;
	entPntr->currentInvincFrames = 0;
	entPntr->isInvincible = false;
	entityVector.push_back(entPntr);
}

void simulation::updateInvincFrames() {
	for (int i = 0; i < entityVector.size(); i++) {
		if (entityVector[i]->isInvincible) {
			//Checks to see if it isn't already at 0
			if (entityVector[i]->currentInvincFrames <= 0) {
				entityVector[i]->currentInvincFrames = entityVector[i]->maxInvincFrames;
			}
			//Lowers timer by 1
			entityVector[i]->currentInvincFrames += -1;
			//If at 0, entity is no longer invincible
			if (entityVector[i]->currentInvincFrames <= 0) {
				entityVector[i]->isInvincible = false;
			}
		}
	}
}

bool simulation::entityIsDead(std::string objectID) {
	for (int entyIndx = 0; entyIndx < entityVector.size(); entyIndx++) {
		if (entityVector[entyIndx]->objectID == objectID) {
			if (entityVector[entyIndx]->currentHealth <= 0) {
				return true;
			}
		}
	}
	return false;
}

void simulation::backScroll(std::string object1ID, std::string object2ID, int speed, eDirection direction) {
	int currentPosX;
	int currentPosY;

	//Searches for the two backgrounds
	for (int i = 0; i < objectVector.size(); i++) {
		if (objectVector[i]->returnID() == object1ID || objectVector[i]->returnID() == object2ID) {
			//saves their current position
			currentPosX = objectVector[i]->getPosX();
			currentPosY = objectVector[i]->getPosY();

			//Moves background based on position
			switch (direction) {
			case eDirection::down:
				objectVector[i]->setPosition(currentPosX, currentPosY + speed);
				if (objectVector[i]->getPosY() >= scrHeight) {
					objectVector[i]->setPosition(currentPosX, -scrHeight);
				}
				break;
			case eDirection::up:
				objectVector[i]->setPosition(currentPosX, currentPosY - speed);
				if (objectVector[i]->getPosY() <= -scrHeight) {
					objectVector[i]->setPosition(currentPosX, scrHeight);
				}
				break;
			case eDirection::right:
				objectVector[i]->setPosition(currentPosX + speed, currentPosY);
				if (objectVector[i]->getPosX() >= scrWidth) {
					objectVector[i]->setPosition(-scrWidth, currentPosY);
				}
				break;
			case eDirection::left:
				objectVector[i]->setPosition(currentPosX - speed, currentPosY);
				if (objectVector[i]->getPosX() <= -scrWidth) {
					objectVector[i]->setPosition(scrWidth, currentPosY);
				}
				break;
			default:
				break;
			}

			//Moves sprite
			visObject->moveSprite(objectVector[i]->returnID(), objectVector[i]->getPosX(), objectVector[i]->getPosY(), eDirection::prevDir);
		}
	}
}

void simulation::platformScroll(std::string objectID, int respawnXPos, int respawnYPos, int speed, eDirection direction) {
	int currentPosX;
	int currentPosY;

	//Searches for object
	for (int i = 0; i < objectVector.size(); i++) {
		if (objectVector[i]->returnID() == objectID) {
			//Saves current position
			currentPosX = objectVector[i]->getPosX();
			currentPosY = objectVector[i]->getPosY();

			//Moves object
			switch (direction) {
			case eDirection::down:
				objectVector[i]->setPosition(currentPosX, currentPosY + speed);
				if (objectVector[i]->getPosY() > scrHeight) {
					objectVector[i]->setPosition(respawnXPos, respawnYPos);
				}
				break;
			case eDirection::up:
				objectVector[i]->setPosition(currentPosX, currentPosY - speed);
				if (objectVector[i]->getPosY() < 0 - objectVector[i]->getHeight()) {
					objectVector[i]->setPosition(respawnXPos, respawnYPos);
				}
				break;
			case eDirection::right:
				objectVector[i]->setPosition(currentPosX + speed, currentPosY);
				if (objectVector[i]->getPosX() > scrWidth) {
					objectVector[i]->setPosition(respawnXPos, respawnYPos);
				}
				break;
			case eDirection::left:
				objectVector[i]->setPosition(currentPosX - speed, currentPosY);
				if (objectVector[i]->getPosX() < 0 - objectVector[i]->getWidth()) {
					objectVector[i]->setPosition(respawnXPos, respawnYPos);
				}
				break;
			default:
				break;
			}

			//Updates Collider
			for (int j = 0; j < solidVector.size(); j++) {
				if (solidVector[j]->objectID == objectID) {
					solidVector[j]->xPos = objectVector[i]->getPosX();
					solidVector[j]->yPos = objectVector[i]->getPosY();
				}
			}

			//Moves sprite
			visObject->moveSprite(objectID, objectVector[i]->getPosX(), objectVector[i]->getPosY(), eDirection::prevDir);
		}
	}
}

void simulation::checkAnalogue(int& leftXAnalogue, int& leftYAnalogue) {
	const HAPI_TControllerData contData = HAPI.GetControllerData(0);

	if (contData.isAttached) {
		leftXAnalogue = contData.analogueButtons[HK_ANALOGUE_LEFT_THUMB_X];
		leftYAnalogue = contData.analogueButtons[HK_ANALOGUE_LEFT_THUMB_Y];

		if (leftXAnalogue < HK_GAMEPAD_LEFT_THUMB_DEADZONE && leftXAnalogue > -HK_GAMEPAD_LEFT_THUMB_DEADZONE) {
			leftXAnalogue = 0;
		}
		if (leftYAnalogue < HK_GAMEPAD_LEFT_THUMB_DEADZONE && leftYAnalogue > -HK_GAMEPAD_LEFT_THUMB_DEADZONE) {
			leftYAnalogue = 0;
		}
	}
}

void simulation::toggleRumble(bool on) {
	const HAPI_TControllerData contData = HAPI.GetControllerData(0);

	if (on) {
		HAPI.SetControllerRumble(0, 30000, 30000);
	}
	else {
		HAPI.SetControllerRumble(0, 0, 0);
	}
}