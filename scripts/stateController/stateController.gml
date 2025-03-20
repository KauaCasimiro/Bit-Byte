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
			case "uping":
				state_ladder();
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
			
			if (key_jump && !jump_locked && place_meeting(x, y + 1, objWall)) {
			    state = "jumping";
			    vspd = -jump_height; // Impulso para cima
			    jump_locked = true;
			}

			
			if (key_jump && !jump_locked && place_meeting(x, y + 1, objPlatform)) {
			    state = "jumping";
			    vspd = -jump_height; // Impulso para cima
			    jump_locked = true;
			}

			
			if (!key_up) {
				jump_locked = false;
			}
		
			if (!place_meeting(x, y + 1, objWall) && !place_meeting(x, y + 1, objPlatform)) { 
				state = "falling";
			}
			
			if (place_meeting(x, y + 1, objLadder) && key_up) {
				state = "uping";
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
	
			if (coyote_time > 0) {
			    vspd = -jump_height; // Aplica impulso no pulo coyote
			    coyote_time = 0;
				//show_debug_message("Jumping - vspd: " + string(vspd) + " | y: " + string(y));
			}
			y += vspd;
			
			if (!ground && !platform) {
			state = "falling";  // Se não há colisão com o chão ou plataforma, muda para o estado de "falling"
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

#region Ladder
function state_ladder() {
    controls();
    gravityRobots();
    
    // Controle de movimento horizontal (movimentação na escada)
    var move = key_right - key_left;
    hspd = move * 0.5;  // A velocidade horizontal é mais lenta na escada
    
    // Controle de movimento vertical (subir/descer escada)
    var uping = key_down - key_up;
    vspd = uping;
    
    // Exibindo variáveis de debug
    show_debug_message("hspd: " + string(hspd));  // Movimento horizontal
    show_debug_message("vspd: " + string(vspd));  // Movimento vertical
    show_debug_message("x: " + string(x));        // Posição X
    show_debug_message("y: " + string(y));        // Posição Y

    // Aplicando o movimento horizontal (movimento na escada)
    if (!place_meeting(x + sign(hspd), y, objLadder) && !place_meeting(x + sign(hspd), y, objWall)) {
        x += sign(hspd);
    }

    // Verifique se o personagem ainda está tocando a escada ou plataforma
    var on_ladder = place_meeting(x, y + 1, objLadder);
    var on_platform = place_meeting(x, y + 1, objPlatform);
    
    if (on_ladder && on_platform) {
        // Se está tocando a escada mas NÃO está tocando a plataforma, pode subir ou descer
        if (key_up) {
            vspd = -1;  // Subir
        } else if (key_down) {
            vspd = 1;   // Descer
        }
    } else if (on_ladder && on_platform) {
        // Se está tocando tanto a escada quanto a plataforma, só pode subir
        vspd = -1;  // Forçar a subir
    } else {
        // Caso contrário, volta para o estado idle
        state = "idle";
    }

    // Aplicando o movimento vertical (subir ou descer escada)
    if (!place_meeting(x, y + sign(vspd), objLadder) && !place_meeting(x, y + sign(vspd), objWall)) {
        y += sign(vspd);
    }

    // Mostra o estado de movimento
    show_debug_message("Estado: " + (vspd == 0 ? "idle" : "uping"));
}

#endregion Ladder

#endregion STATES
