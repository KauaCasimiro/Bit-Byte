// script responsible for controlling states

#region STATE_MACHINE
	function byteController(){
		switch (state) {
	        case "idleMirrored":
	            state_idleMirrored();
				//show_debug_message("Bit: Parado")
	            break;
	        case "walkingMirrored":
	            state_walkingMirrored();
	            break;
	        case "jumpingMirrored":
	            state_jumpingMirrored();
	            break;
	        case "fallingMirrored":
	            state_fallingMirrored();
	            break;
	    }
	}
#endregion STATE_MACHINE

#region STATES

	#region IDLE
		function state_idleMirrored () {
			controls_Byte();
			gravityRobots();
		
			if (key_right || key_left) {
				state = "walkingMirrored";
			}
			
			if (place_meeting(x, y + 1, objWall) && key_jump) {
				state = "jumpingMirrored";
			}
			
			if (place_meeting(x, y + 1, objPlatform) && key_jump) {
				state = "jumpingMirrored";
			}
		
			if (!place_meeting(x, y + 1, objWall) && !place_meeting(x, y + 1, objPlatform)) { 
				state = "fallingMirrored";
			}	
		}
	#endregion IDLE

	#region WALKING
		function state_walkingMirrored() {
			controls_Byte();
			gravityRobots();
		
			var move = key_left - key_right;
			hspd = move * spd;
		
			if (hspd != 0) {
				image_xscale = -sign(hspd);
			}
		
			repeat(abs(hspd)){
				if (!place_meeting(x + sign(hspd), y, objWall) && !place_meeting(x + sign(hspd), y, objPlatform)) {
					x += sign(hspd);
				} else {
					hspd = 0;        
				}
			}

		
			if (!key_right && !key_left) {
				state = "idleMirrored"
			}
			
			if (key_jump && place_meeting(x, y + 1, objWall)) {
				state = "jumpingMirrored";
			}
			
			if (key_jump && place_meeting(x, y + 1, objPlatform)) {
				state = "jumpingMirrored";
			}
			if (!place_meeting(x, y + 1, objWall) && !place_meeting(x, y + 1, objPlatform)) { 
		    if (coyote_time > 0) {
		        coyote_time--;
		    } else {
				if (!place_meeting(x, y + 1, objWall) && !place_meeting(x, y + 1, objPlatform)) { 
		    if (coyote_time > 0) {
		        coyote_time--;
		    } else {
		        state = "fallingMirrored";
		    }
				}

				state = "fallingMirrored";
			}
			}
	
		}
	#endregion WALKING

	#region JUMPING
		function state_jumpingMirrored() { 
		    controls_Byte();
		    gravityRobots();
    
		    var ground = place_meeting(x, y + 1, objWall);
			var platform = place_meeting(x, y + 1, objPlatform);
			var move = key_left - key_right;
			hspd = move * spd;
		
			if (hspd != 0) {
				image_xscale = -sign(hspd);
				
			}
		
			repeat(abs(hspd)){
				if (!place_meeting(x + sign(hspd), y, objWall) && !place_meeting(x + sign(hspd), y, objPlatform)) {
					x += sign(hspd);
				} else {
					hspd = 0;        
				}
			}
	
			if (ground || platform) {
				coyote_time = coyote_time_max;
				
			} else {
				coyote_time --;
			}
	
			if (key_jump && coyote_time > 0) {
				coyote_time = 0;
				vspd = 0;
				vspd -= jump_height;
				state = "fallingMirrored";
				show_debug_message(coyote_time);
			
			}
			
			
		}

	#endregion JUMPING

	#region FALLING
function state_fallingMirrored() {
    controls_Byte();  // Controla o movimento do Byte
    gravityRobots();  // Aplica a gravidade

    // Verificação de movimento horizontal
    var move = key_left - key_right;
    hspd = move * spd;

    if (hspd != 0) {
        image_xscale = -sign(hspd);  // Gira o personagem conforme a direção
    }

    // Movimentação horizontal pixel a pixel para evitar atravessar paredes
    repeat(abs(hspd)) {
        if (!place_meeting(x + sign(hspd), y, objWall) && !place_meeting(x + sign(hspd), y, objPlatform)) {
            x += sign(hspd);
        } else {
            hspd = 0;
        }
    }

    // Aplicar gravidade e limitar velocidade de queda
    vspd += grv;
    if (vspd > max_fall_speed) {
        vspd = max_fall_speed;
    }

    // Movimentação vertical pixel a pixel para evitar atravessar o chão
    repeat(abs(vspd)) {
        if (!place_meeting(x, y + sign(vspd), objWall) && !place_meeting(x, y + sign(vspd), objPlatform)) {
            y += sign(vspd);
        } else {
            vspd = 0;  
            state = "idleMirrored";  // Transição para idleMirrored quando tocar o chão
            break;
        }
    }
}

#endregion FALLING


#endregion STATES