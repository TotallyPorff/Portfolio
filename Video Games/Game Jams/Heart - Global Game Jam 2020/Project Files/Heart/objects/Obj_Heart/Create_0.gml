//sets randomizer
randomize();

//Set position and sprite
x = room_width / 2;
y = 112;
image_xscale = 2;
image_yscale = 2;

//Bobbing
mainYPos = y;
bobMoment = 0;
bobDirection = "Up";

//Colour flash
hue = 50 //0 = red, 50 = yellow, 120 = green
sat = 0;

//Personality and problem
personality = irandom_range(0, 1);
problem = irandom_range(0, 1);

//These measure how close the player is to completing that stage. 1 = neutral,
//0 is close to fail, and 2 is close to winning
currentStage = "Locked"
lockedTrust = 1;
brokenTrust = 1;
transitioned = false;
//Heart responded
responded = false;
responseBox = noone;
oldResp = -1;
newResp = -1;

//End state
endState = noone;
endBoxY = room_height - 100;

//PERSONALITIES
if (personality == 0) { //Reluctant to admit to problem
	//Negative
	persArray[0, 0] = "Things are going well!";
	persArray[0, 1] = "I stayed in my room all day yesterday! It was nice.";
	persArray[0, 2] = "Yeah I'm having a really good time! Everything is... great!";
	//Neutral
	persArray[1, 0] = "Yeah... everything is ok I guess...";
	persArray[1, 1] = "I'm a bit behind on stuff, but other than that there's no issues.";
	persArray[1, 2] = "Im OK, I'm... living an OK life right now.";
	//Positive
	persArray[2, 0] = "I mean, there is a problem, but it's only a small one... I can handle it...";
	persArray[2, 1] = "I slept really late... but that's OK, I'll be fine";
	persArray[2, 2] = "It's something I'm used to, so I'll be fine...";
} else if (personality == 1) { //Reluctant to share the problem
	//Negative
	persArray[0, 0] = "I'd rather not talk about it. I can handle it...";
	persArray[0, 1] = "It's personal, so I'll deal with it myself.";
	persArray[0, 2] = "It's fine, I'm on top of it...";
	//Neutral
	persArray[1, 0] = "Life isn't the best but I'm fine.";
	persArray[1, 1] = "Stuff is kinda OK right now... nothing I can't deal with.";
	persArray[1, 2] = "Yea yea... everything is a little bumpy right now.";
	//Positive
	persArray[2, 0] = "I dunno... I don't really wanna ask for help on it.";
	persArray[2, 1] = "I should be able to handle it all by myself...";
	persArray[2, 2] = "Things are a bit overwhelming... I can get through it on my own though.";
}

//PROBLEMS
if (problem == 0) { //Lack of self-esteem
	//Transition text
	txtTrans = "I just... I'm never confident in what I do... I worry too much about everything...";
	//Negative
	probArray[0, 0] = "I mean, I failed my exams! Everything I'm gonna do is always gonna go wrong!";
	probArray[0, 1] = "I just can't do it... I'm easily overwhelmed, especially round others...";
	probArray[0, 2] = "I always feel like someone is following me... probably someone affected by my mistakes...";
	//Neutral
	probArray[1, 0] = "I never have the motivation to get anything done...";
	probArray[1, 1] = "Talking to people is... scary...";
	probArray[1, 2] = "I have to do a presentation soon, but I doubt it will go well...";
	//Positive
	probArray[2, 0] = "I mean, I have coursework that needs doing, but I'm scared it'll never be done in time...";
	probArray[2, 1] = "I'm gonna end up doing something dumb and wasting my finances!";
	probArray[2, 2] = "There's someone I really like, but I doubt they'd want to even talk to me...";
} else if (problem == 1) { //Bullying
	//Transition text
	txtTrans = "I... I get bullied almost every day... People love to laugh at my expense...";
	//Negative
	probArray[0, 0] = "But what if they're right? There's so many that say it, so maybe I am as awful as they say...";
	probArray[0, 1] = "They make me hate the way I look... just because I'm not as healthy as them...";
	probArray[0, 2] = "Is my life really just... a big joke?";
	//Neutral
	probArray[1, 0] = "They never leave me alone... I just want to be left alone...";
	probArray[1, 1] = "Why can't I just be someone normal, so I can just fit in... At least then they'd stop.";
	probArray[1, 2] = "Maybe I should just not go tomorrow... Then I won't have to deal with them.";
	//Positive
	probArray[2, 0] = "I get so upset because of them... I end up eating a lot to combat the stress.";
	probArray[2, 1] = "I get told to just ignore them, but they just keep getting in my face!";
	probArray[2, 2] = "I often struggle to get out of bed knowing that'll I'll have to face them again.";
}


//RUNS RESPONSE ONCE
//Create box
responseBox = instance_create_layer(x, y, "Text", Obj_TextBox);

//Chooses text that it isn't currently on
do {
	newResp = irandom_range(0, 2);
} until (newResp != oldResp)
//Display new text
responseBox.text = persArray[lockedTrust, newResp];
oldResp = newResp;