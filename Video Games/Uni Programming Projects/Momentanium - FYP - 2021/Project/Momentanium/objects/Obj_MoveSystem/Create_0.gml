/// @description Base Variables and Function
/* note: all movement variables are in pixels per second
as they are multiplyed by the room speed */

//Movement Structure
moveStructs = new createMoveStructs();
charMoveStruct = moveStructs.mediumMoveStruct; //It is medium by default

//Variables not in Struct
hSpeed = 0; //Horizontal Speed
vSpeed = 0; //Vertical Speed
fastfalling = false;
canJump = true;
jumpsUsed = 0;
touchingFloor = false;
touchingWall = false;

//Dodge Variables
canDodge = true;
isInvincible = false;
dodgeCooldown = 1;
invincReset = 0.1; //Duration player is invincible
dodgeSpeed = 300;

//Collision Variables
tilemap = layer_tilemap_get_id("CollisionTiles"); //The ID of the collision tiles
deathTilemap = layer_tilemap_get_id("DeathTiles"); //The ID of the death tiles

//Keyboard Input variables
inpLeftKey = 0;
inpRightKey = 0;
inpUpKey = 0;
inpDownKey = 0;
inpJumpKey = 0;
inpDodgeKey = 0;

//Controller Input Variables
inpJumpContr = 0;
inpDodgeContr = 0;
contrDeadzone = 0.4;
isController = false;
controllerIndex = -1;

//Reset variables
spawnX = x;
spawnY = y;

//Attack States
enum attackState {
	idle,
	nAttack, //neutral
	sAttack, //side
	dAttack, //down
	nAir,
	sAir,
	dAir
}
currentAttackState = attackState.idle;

//Hit cooldown Variables
hitCooldown = false;
hitCooldownTime = 0.25;

//Death variables
visible = true;
isDead = false;
alarmSet = false;
deathTimer = 3; //Seconds

//Stocks
maxStocks = 3;
currentStocks = maxStocks;