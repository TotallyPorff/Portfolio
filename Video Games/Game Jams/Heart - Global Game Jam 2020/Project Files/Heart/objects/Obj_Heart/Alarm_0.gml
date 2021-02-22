//Change to the next stage
currentStage = "Broken"

//RUNS RESPONSE ONCE
//Remove current text box if exists
if (responseBox != noone) {
	instance_destroy(responseBox);
	responseBox = noone;
}

//Create box
responseBox = instance_create_layer(x, y, "Text", Obj_TextBox);

//Chooses text that it isn't currently on
do {
	newResp = irandom_range(0, 2);
} until (newResp != oldResp)
//Display new text
responseBox.text = probArray[brokenTrust, newResp];
oldResp = newResp;

responded = true;
Obj_PlyrInput.inputted = false;