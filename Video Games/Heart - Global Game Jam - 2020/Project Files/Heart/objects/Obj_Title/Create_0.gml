//Set position
x = room_width / 2;
y = (room_height / 2) - 160;

//Bobbing
mainYPos = y;
bobMoment = 0;
bobDirection = "Up";

//Create start button
buttonY = (room_height / 2) - 25;
startButton = instance_create_layer(x, y, "Text", Obj_InptBox);
startButton.x = x;
startButton.y = buttonY;
startButton.text = "Start Repair";
startButton.charCount = 0;