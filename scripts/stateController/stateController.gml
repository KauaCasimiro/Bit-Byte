// script responsible for controlling states

#region STATE_MACHINE
	function stateController(){
		switch (state) {
	        case "idle":
	            state_idle();
				//show_debug_message("Bit: Parado")
	            break;
	        case "walking":
	            state_walking();
	            break;
	        case "jumping":
	            state_jumping();
	            break;
	        case "falling":
	            state_falling();
	            break;
	    }
	}
#endregion STATE_MACHINE

#region STATES

	#region IDLE
		function state_idle () {
			controls();
			gravityRobots();
		
			if (key_right || key_left) {
				state = "walking";
			}
			
			if (place_meeting(x, y + 1, objWall) && key_jump) {
				state = "jumping";
			}
			
			if (place_meeting(x, y + 1, objPlatform) && key_jump) {
				state = "jumping";
			}
		
			if (!place_meeting(x, y + 1, objWall) && !place_meeting(x, y + 1, objPlatform)) { 
				state = "falling";
			}	
		}
	#endregion IDLE

	#region WALKING
		function state_walking() {
			controls();
			gravityRobots();
		
			var move = key_right - key_left;
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
				state = "idle";
			}
			
			if (key_jump && place_meeting(x, y + 1, objWall)) {
				state = "jumping";
			}
			
			if (key_jump && place_meeting(x, y + 1, objPlatform)) {
				state = "jumping";
			}
			if (!place_meeting(x, y + 1, objWall) && !place_meeting(x, y + 1, objPlatform)) { 
		        if (coyote_time > 0) {
		            coyote_time--;
		        } else {
		            state = "falling";
		        }
			}
		}
	#endregion WALKING

	#region JUMPING
		function state_jumping() { 
		    controls();
		    gravityRobots();
    
		    var ground = place_meeting(x, y + 1, objWall);
			var platform = place_meeting(x, y + 1, objPlatform);
			var move = key_right - key_left;
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
				coyote_time--;
			}
	
			if (key_jump && coyote_time > 0) {
				coyote_time = 0;
				vspd = 0;
				vspd -= jump_height;
				state = "falling";
			}
		}

	#endregion JUMPING

	#region FALLING
function state_falling() {
    controls();  // Controla o movimento
    gravityRobots();  // Aplica a gravidade

    // Verificação de movimento horizontal
    var move = key_right - key_left;
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
            state = "idle";  // Transição para idle quando tocar o chão
            break;
        }
    }
}

#endregion FALLING


#endregion STATES
