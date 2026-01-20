///
	
//
window_set_cursor(cr_none)


if !instance_exists(obj_control_transition_rooms) {
	/// Aciono o obj de transição
	var _c_tra = instance_create_layer(0, 0, "Instances", obj_control_transition_rooms)
	with(_c_tra) {
		/// Passando os assets das sequencias de entrada e saida
		asset_seq_in  = seq_transcao_in
		asset_seq_out = seq_transcao_out
	
	
		///
		if global.menu_to_cred {
			// Passando qual a room o jogo deve direcionar
			global.next_room = rm_link_site_ifrn
		}
		else {
			// Passando qual a room o jogo deve direcionar
			global.next_room = rm_db_registro
			
			/// Informando que o jogador terminou o jogo, caso ele ainda não tivesse terminado
			if !global.com_game {
				global.com_game = true
				
				save_data("com_game", true, "conf")
			}
		}
		
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
}
