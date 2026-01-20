//
if !can_pause exit;

#region Sistema de Pause
/* Condição para o pressionamento da tecla "Esc" */
if (keyboard_check_pressed(vk_escape)) {
    /* Se o jogo estiver pausado, será retomado; se estiver em execução, será pausado */
    global.pause = !global.pause;
    
	if instance_exists(obj_int_player) {
	    // Verifica se o jogo está pausado e define o sprite do botão de pausa de acordo
	    if (global.pause) {
			//
	        obj_int_player.image_speed = 0
			
			///
			window_mouse_set(window_get_width() / 2, window_get_height() / 2.7)
			window_set_cursor(cr_default)
	    }
		else {
	        //
	        obj_int_player.image_speed = 1
			
			//
			window_set_cursor(cr_none)
	    }
	}
}

/* Sistema de pausa automática */
if !window_has_focus() {
    if !global.pause {
        global.pause = true
		
		///
		window_mouse_set(window_get_width() / 2, window_get_height() / 2.7)
		window_set_cursor(cr_default)
		
		if instance_exists(obj_int_player) {
			//
			obj_int_player.image_speed = 0
		}
    }
}
#endregion


