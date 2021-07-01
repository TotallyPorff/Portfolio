//make sure Dev tools are on
if (devToolsActive) {
	
	//Show tiles for collision and respawn
	if (keyboard_check_pressed(vk_f1)) {
		showTiles = !showTiles;
		layer_set_visible(collTiles, showTiles);
		layer_set_visible(deathTiles, showTiles);
	}
	//Show hitboxes
	if (keyboard_check_pressed(vk_f2)) {
		showHitboxes = !showHitboxes;
		object_set_visible(Obj_AttackHitbox, showHitboxes);
	}
}