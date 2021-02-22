yBob = 0;
maxSpeed = 0.1;
bobbingUp = false;

//Randomize seed
randomize();

//Choose Sprite
chooseSprite = irandom(3);
switch (chooseSprite) {
	case 0:
	default:
	sprite_index = Spr_Love;
	break;
	case 1:
	sprite_index = Spr_Games;
	break;
	case 2:
	sprite_index = Spr_Money;
	break;
	case 3:
	sprite_index = Spr_Clothing;
	break;
}


//Set location
startX = irandom_range(0, room_width);
startY = irandom_range(0, room_height);
x = startX;
y = startY;