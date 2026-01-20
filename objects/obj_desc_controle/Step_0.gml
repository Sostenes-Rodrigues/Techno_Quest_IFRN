
if (global.pause or instance_exists(obj_tutorial)) {
	///
	window_set_cursor(cr_default)
	cursor_sprite = -1
}
else {
	/// Deixa o cursor invisivel e atribui uma sprite
	window_set_cursor(cr_none)
	/// Mouse
	if mouse_check_button(mb_left) {
		cursor_sprite = spr_desc_cursor_seg
	}
	else{
		cursor_sprite = spr_desc_cursor
	}
}



//
if (instance_exists(obj_tutorial)) exit;

///
if !play_123 {
	play_123 = true
	play_sound_geral(snd_desc_contagem_321bit)
}
/// Timer inicial
if timer_init > 0 {
	timer_init --
	
	// Pula o resto do código
	exit
}


#region Criação do lixo
// Vai passando o timer de criação
timer_spawn_lixo --

/*

*/
// Se acabou o tempo
if timer_spawn_lixo < 1 { // Vc pode fazer o Tempo de Geração com mudaças de "estado" que vão trocando a variavel de tempo e de repetição
	// Repetindo a criação do lixo
	repeat(num_repeat) {
		// Chamando o metodo que cria lixo
		cria_lixo()
	}
	
	// Reseta o timer de criação
	timer_spawn_lixo = timer_spawn_lixo_restart
}
#endregion

// Se a poluição chegar a tanto o jogo reinicia
if poluicao > poluicao_max {
	room_restart()
}

// Metodo do que cuida do screen shake
controla_screen_shake()

/// Se o player sobrevivel todo tempo
timer_tempo --

/// CONDICAO DE VITORIA
if timer_tempo <= 0 {
	//
	if !instance_exists(obj_control_transition_rooms) {				
		// Se ainda não tinha completado no save atual
		if !get_data("c_reci") {
			/// Salvando no save atual que esse minigame foi concluido
			save_data("c_reci", 1)
			
			//
			in_game_sum_per()
		}
		
		/// Limpando o sistema de particulas, NESSA ORDEM
		part_type_destroy(particle)
		part_emitter_destroy(part_sys, part_em)
		part_system_destroy(part_sys)

		
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


/// Poluição cai quando não tiver lixo
if !instance_exists(obj_desc_lixo){
	if poluicao>0{
	poluicao--}
}
