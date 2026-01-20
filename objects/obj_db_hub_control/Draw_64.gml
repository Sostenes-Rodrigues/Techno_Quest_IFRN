//
if (!global.seq_run) {
	//
	if timer_query == timer_query_max {
		draw_set_halign(1)
		draw_set_valign(1)
		draw_text_ext(room_width / 2, room_height * .05, "R: Recarregar", 3, room_width * .1)
		draw_set_halign(-1)
		draw_set_valign(-1)
	}

	#region Notice Esc to back
	draw_set_color(c_white)
	draw_roundrect_ext(-30, -30, 165, 80, 30, 30, false)
		
	draw_set_font(fnt_menu_30)
	draw_set_color(c_black)
	draw_set_halign(-1)
	draw_set_valign(fa_center)
	draw_text_transformed(22, 40, "\"Esc\" para\nvoltar", .5, .5, 0)
	draw_set_font(-1)
	draw_set_color(-1)
		
	///
	if keyboard_check_pressed(vk_escape) {
		if !instance_exists(obj_control_transition_rooms) {
			// Passando qual a room o jogo deve direcionar
			global.next_room = rm_link_site_ifrn
	
			//
			window_set_cursor(cr_none)
	
			///
			if (instance_exists(obj_int_control)) instance_destroy(obj_int_control);
	
			/// Aciono o obj de transição
			var _c_tra = instance_create_layer(0, 0, "Instances", obj_control_transition_rooms)
			with(_c_tra) {
				/// Passando os assets das sequencias de entrada e saida
				asset_seq_in  = seq_transcao_in
				asset_seq_out = seq_transcao_out
				/// Passando a posição de onde a câmera de começar na proxima sala
				global.next_room_posx = 0
				global.next_room_posy = 0
				
				// Indico se a proxima room vai ter o player ou não
				global.next_room_with_player = false
			
				// 
				next_with_mouse = true
				// Indico se o player está na sala atual
				player_in_room = false
				
				// Acionando o método que cria a sequencia de saida
				exit_room()

				global.pause = false
			}
	
			// Me deleto
			instance_destroy(id)
			
			// Feedback sonoro
			play_sound_geral(snd_esc)
		}
	}
	#endregion
}
