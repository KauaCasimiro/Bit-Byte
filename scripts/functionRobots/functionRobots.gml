#region CONTROLS
	function controls () {
		key_right = keyboard_check(ord("D"));
		key_left = keyboard_check(ord("A"));
		key_jump = keyboard_check(ord("W"));
		key_down = keyboard_check(ord("S"));
		if (keyboard_check_pressed(vk_escape)) {
    game_end();
}

	}
	
	function controls_Byte() {
		key_right = keyboard_check(ord("D"));
		key_left = keyboard_check(ord("A"));
		key_jump = keyboard_check(ord("W"));
		key_down = keyboard_check(ord("S"));
	}
#endregion CONTROLS

#region GRAVITY
	function gravityRobots () {
	

    // Acumula a gravidade na velocidade vertical (vspd)
    vspd += grv;
	
	
}
#endregion GRAVITY