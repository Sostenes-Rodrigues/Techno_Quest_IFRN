/// Se entrei na room e a seq de entrada acabou, me destruo
if enter_room {
	if layer_sequence_exists("Sequences", id_seq_in) {
		if (layer_sequence_is_finished(id_seq_in)) {
			instance_destroy(id)
			
			// Fazendo o player se mover
			if (instance_exists(obj_int_player) and room != rm_int_ifrn_outside) obj_int_player.player_can_move = true;
		}
	}
}
