// Se o player existe
if instance_exists(id_player) {
	// Se o player tocou em mim
	if place_meeting(x, y, id_player) and !global.pause {
		if need_interaction {
			if !keyboard_check_pressed(ord("E")) {
				// Pulo o resto do código
				exit
			}
		}
		
		///
		if instance_exists(obj_int_trigger_pc) {
			obj_int_trigger_pc.sprite_index = spr_int_pc_trigger
			obj_int_trigger_pc.image_index = 0
			
			///
			instance_destroy(id)
			exit
		}
		
		// Se o obj controle da transição ainda não foi criado
		if !instance_exists(obj_control_transition_rooms) {
			// Passando qual a room o jogo deve direcionar
			global.next_room = next_room
		
			/// Aciono o obj de transição
			var _c_tra = instance_create_layer(0, 0, "Instances", obj_control_transition_rooms)
			with(_c_tra) {
				/// Passando os assets das sequencias de entrada e saida
				asset_seq_in  = asset_get_index("seq_" + other.seq_name + "_in")
				asset_seq_out = asset_get_index("seq_" + other.seq_name + "_out")
				/// Passando a posição de onde a câmera de começar na proxima sala
				global.next_room_posx = other.pass_x
				global.next_room_posy = other.pass_y
				
				// Indico se a proxima room vai ter o player ou não
				global.next_room_with_player = other.next_with_player
				// 
				next_with_mouse = other.next_with_mouse
				// Indico se o player está na sala atual
				player_in_room = other.player_in_room
				
				// Acionando o método que cria a sequencia de saida
				exit_room()
			}
		}
	}
}
