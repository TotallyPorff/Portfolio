/// @description Adds initial wait to avoid bugs

//Store number of players
numberOfChars = instance_number(Obj_AttackSystem);

//Calculate space in between each damage bar
barGapSize = screenWidth - (barWidth * numberOfChars);
barGapSize = barGapSize / (numberOfChars + 1);

//Activates all other code
initialWaitOver = true;