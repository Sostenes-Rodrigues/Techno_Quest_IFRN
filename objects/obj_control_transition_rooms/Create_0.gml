/// Passando a posição de onde a câmera de começar na proxima sala
global.next_room_posx = 982
global.next_room_posy = 528
				
// Indico se a proxima room vai ter o player ou não
global.next_room_with_player = true

/// O ID dos assets das sequencias de entrada e saida (dadas pelo obj trigger)
asset_seq_in  = seq_transcao_in
asset_seq_out = seq_transcao_out

/// O ID das seq layer das sequencias de entrada e saida
id_seq_in  = noone
id_seq_out = noone

// Para indicar se já entrei na proxima room
enter_room = false

depth = -15000
// Método que cria a sequencia de saida
exit_room = function() {
	// Indicando que está passando uma sequencia que não é para ser interrunpida por outras coisas
	global.seq_run_out = true
	
	/// Se na room atual não tiver a layer das sequencias, crio ela na frente de todas
	if !layer_exists("Sequences") {
		layer_create(-15000, "Sequences")
	}
	
	// Se a sequencia de saida já foi criada
	if layer_sequence_exists("Sequences", id_seq_out) {
		/// Toco essa sequencia novamente
		/// Se 
		if player_in_room {
			layer_sequence_x(id_seq_out, obj_int_player.x)
			layer_sequence_y(id_seq_out, obj_int_player.y)
		}
		/// Se 
		else {
			layer_sequence_x(id_seq_out, room_width / 2)
			layer_sequence_y(id_seq_out, room_height / 2)
		}
		
		layer_sequence_play(id_seq_out)
	}
	/// Se a sequencia de saida ainda não foi criada, crio ela
	else {
		/// Se 
		if player_in_room {
			
			id_seq_out = layer_sequence_create("Sequences", obj_int_player.x, obj_int_player.y, asset_seq_out)
		}
		/// Se 
		else {
			id_seq_out = layer_sequence_create("Sequences", room_width / 2, room_height / 2, asset_seq_out)
		}
	}
}
