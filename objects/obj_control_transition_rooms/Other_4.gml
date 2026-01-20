if (global.seq_run_out) exit;
// Indico que entrei na room
enter_room = true

/// Se na room atual não tiver a layer das sequencias, crio ela na frente de todas
if !layer_exists("Sequences") {
	layer_create(-15000, "Sequences")
}

// Se a sequencia de entrada já foi criada
if layer_sequence_exists("Sequences", id_seq_in) {
	/// Toco essa sequencia novamente
	/// Se 
	if global.next_room_with_player {
		layer_sequence_x(id_seq_in, obj_int_player.x)
		layer_sequence_y(id_seq_in, obj_int_player.y)
	}
	/// Se 
	else {
		layer_sequence_x(id_seq_in, room_width / 2)
		layer_sequence_y(id_seq_in, room_height / 2)
	}
	
	layer_sequence_play(id_seq_in)
}
/// Se a sequencia de entrada ainda não foi criada, crio ela
else {
	/// Se 
	if global.next_room_with_player and instance_exists(obj_int_player) {
		id_seq_in = layer_sequence_create("Sequences", obj_int_player.x, obj_int_player.y, asset_seq_in)
	}
	/// Se 
	else {
		id_seq_in = layer_sequence_create("Sequences", room_width / 2, room_height / 2, asset_seq_in)
	}
}


// Posiciono a câmera para o local designado
camera_set_view_pos(view_camera[0], global.next_room_posx, global.next_room_posy)

/// Reseto a posição da câmera para as rooms que ela não se mexe
global.next_room_posx = 0
global.next_room_posy = 0

///
if variable_instance_exists(id, "next_with_mouse") {
	if next_with_mouse {
		///
		window_mouse_set(window_get_width() / 2, window_get_height() / 2.7)
		window_set_cursor(cr_default)
	}
	else {
		//
		window_set_cursor(cr_none)
	}
}
