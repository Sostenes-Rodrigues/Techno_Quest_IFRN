if count >= 3{
	instance_destroy(obj_mapc_fim)
	
	/// CONDIÇÃO DE VITORIA
	//
	if !instance_exists(obj_control_transition_rooms) {
		// Se ainda não tinha completado no save atual
		if !get_data("c_mapc") {
			/// Salvando no save atual que esse minigame foi concluido
			save_data("c_mapc", 1)
			
			//
			in_game_sum_per()
		}
			
		// Passando qual a room o jogo deve direcionar
		global.next_room = rm_int_lobby
		
		/// Aciono o obj de transição
		var _c_tra = instance_create_layer(0, 0, "Instances", obj_control_transition_rooms)
		with(_c_tra) {
			/// Passando os assets das sequencias de entrada e saida
			asset_seq_in  = seq_transcao_in
			asset_seq_out = seq_transcao_out
			/// Passando a posição de onde a câmera de começar na proxima sala
			global.next_room_posx = 192
			global.next_room_posy = 608
				
			// Indico se a proxima room vai ter o player ou não
			global.next_room_with_player = true
			// Indico se o player está na sala atual
			player_in_room = false
				
			// Acionando o método que cria a sequencia de saida
			exit_room()
		}
	}
}