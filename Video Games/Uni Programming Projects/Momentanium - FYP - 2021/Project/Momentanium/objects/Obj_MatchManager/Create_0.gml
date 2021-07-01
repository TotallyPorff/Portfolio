/// @description Create all match objects

//Create ds_list of player IDs
playerIDList = ds_list_create();

//Variables
winner = noone;
winnerNumber = 1;
isMatchOver = false;

//Grab spawn points
spawnsList = new roomSpawns();
if (room == Rm_Testing) {
	roomPlayerSpawns = spawnsList.testingSpawns;
}

//Spawn management objects
instance_create_depth(0, 0, 0, Obj_DevTools);
instance_create_depth(0, 0, 0, Obj_CameraControl);
barManager = instance_create_depth(0, 0, 0, Obj_BarManager);
barManager.managerID = id;

//Spawn players
noOfPlayers = global.playerCount;
for (var i = 0; i < noOfPlayers; i++) {
	//Get spawn point
	spawnPosX = variable_struct_get(roomPlayerSpawns, "xPlayer" + string(i + 1));
	spawnPosY = variable_struct_get(roomPlayerSpawns, "yPlayer" + string(i + 1));
	
	//spawn character
	currentChar = instance_create_depth(spawnPosX, spawnPosY, 300, Obj_Defaultie);
	currentChar.resetControls();
	ds_list_add(playerIDList, currentChar);
}

//Spawn input manager
inputManager = instance_create_depth(0, 0, 0, Obj_InputManager);
inputManager.managerID = id;
barManager.inputManagerID = inputManager;