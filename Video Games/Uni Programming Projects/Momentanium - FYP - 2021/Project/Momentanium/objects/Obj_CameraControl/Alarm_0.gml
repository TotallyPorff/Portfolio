/// @description Store Player Characters

//Loop through all instances of Obj_AttackSystem (parent)
for (var i = 0; i < instance_number(Obj_AttackSystem); i++) {
	//Add instance ids to the ds list
	ds_list_add(playerChars, instance_find(Obj_AttackSystem, i));
}
