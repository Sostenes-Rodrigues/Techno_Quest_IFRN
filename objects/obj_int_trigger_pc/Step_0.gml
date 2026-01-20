//
if sprite_index == spr_int_pc_trigger {
	///
	if instance_exists(obj_int_player) {
		obj_int_player.player_can_move = false
	}
	
	
	///
	if instance_exists(obj_pause) {
		obj_pause.can_pause = false	
	}
	
	if image_index >= sprite_get_number(sprite_index) -1 and image_speed != 0 {
		image_speed = 0
		
		///
		// Passando qual a room o jogo deve direcionar
		global.next_room = rm_int_lobby
		
		/// Aciono o obj de transição
		var _c_tra = instance_create_layer(0, 0, "Instances", obj_control_transition_rooms)
		with(_c_tra) {
			/// Passando os assets das sequencias de entrada e saida
			asset_seq_in  = seq_transcao_in
			asset_seq_out = seq_transcao_out
			/// Passando a posição de onde a câmera de começar na proxima sala
			global.next_room_posx = 264
			global.next_room_posy = 656
				
			// Indico se a proxima room vai ter o player ou não
			global.next_room_with_player = true
			// 
			next_with_mouse = false
			// Indico se o player está na sala atual
			player_in_room = true
				
			// Acionando o método que cria a sequencia de saida
			exit_room()
		}
	}
}