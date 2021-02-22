//Storing variables
text = "Test";
txtBoxWidth = sprite_get_width(Spr_HeartBox);
txtBoxHeight = sprite_get_height(Spr_HeartBox);
strHeight = string_height(text);

boxPosX = (room_width - txtBoxWidth) / 2;
boxPosY = (room_height - txtBoxHeight) / 2;
txtPosX = boxPosX + (txtBoxWidth / 2);
txtPosY = boxPosY + (txtBoxHeight / 2);

charCount = 0;