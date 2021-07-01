/// @description Create buttons for number of players

//Button 2
Button2 = instance_create_depth(room_width * 0.25, room_height / 2, 0, Obj_Button);
Button2.playerNumber = 2;
Button2.sprite_index = Spr_Button2;

//Button 3
Button3 = instance_create_depth(room_width * 0.5, room_height / 2, 0, Obj_Button);
Button3.playerNumber = 3;
Button3.sprite_index = Spr_Button3;

//Button 4
Button4 = instance_create_depth(room_width * 0.75, room_height / 2, 0, Obj_Button);
Button4.playerNumber = 4;
Button4.sprite_index = Spr_Button4;