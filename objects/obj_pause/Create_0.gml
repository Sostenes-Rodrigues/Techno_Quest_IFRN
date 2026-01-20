#region Funções do sistema de pause

// Função para colocar em cima do step de todos os objetos que devem parar quando o jogo pausar
stop_with_pause = function() {
	io_clear()
	// Se o jogo está pausado
	if global.pause {
		// Não faço mais nada depois que essa função é chamada
		exit
	}
}


funcao_resume = function() {
	io_clear()
    global.pause = false; // Despausa o jogo
	
	///
	if instance_exists(obj_int_player) {
		obj_int_player.image_speed = 1
		window_set_cursor(cr_none)
	}
}

funcao_voltar = function() {
	//
	audio_stop_all()
	//
	io_clear()
	// Passando qual a room o jogo deve direcionar
	global.next_room = rm_int_ifrn_outside
	
	//
	window_set_cursor(cr_none)
	
	cursor_sprite = -1
	
	///
	if (instance_exists(obj_int_control)) instance_destroy(obj_int_control);
	
	/// Aciono o obj de transição
	var _c_tra = instance_create_layer(0, 0, "Instances", obj_control_transition_rooms)
	with(_c_tra) {
		/// Passando os assets das sequencias de entrada e saida
		asset_seq_in  = seq_transcao_in
		asset_seq_out = seq_transcao_out
		/// Passando a posição de onde a câmera de começar na proxima sala
		global.next_room_posx = 982
		global.next_room_posy = 528
				
		// Indico se a proxima room vai ter o player ou não
		global.next_room_with_player = true
		// Indico se o player está na sala atual
		player_in_room = instance_exists(obj_int_player)
				
		// Acionando o método que cria a sequencia de saida
		exit_room()

		global.pause = false
	}
}

funcao_sair = function() {
	io_clear()
	game_end()
}



/// Desenha botões na tela com os textos e funções fornecidos.
// AJEITAR!!!
// Você está pegando a posição x e y da gui, mas está posicionando no x e y da room
desenha_botoes = function(_button_x, _button_y_, _button_texts, _button_functions) {
    // Defina a largura e altura dos botões
    var _largura_button = 200;
    var _altura_botton = 40;
    var _espaco = 40; // Espaçamento entre os botões
	
    // Desenhe os botões
    for (var _i = 0; _i < array_length(_button_texts); _i++) {
        // Calcula a coordenada y do botão atual
        var _button_y = _button_y_ + (_i * (_altura_botton + _espaco));
		
		var _sel = (device_mouse_x_to_gui(0) > _button_x - _largura_button / 2 and device_mouse_x_to_gui(0) < _button_x + _largura_button / 2 and
                    device_mouse_y_to_gui(0) > _button_y - _altura_botton / 2 and device_mouse_y_to_gui(0) < _button_y + _altura_botton / 2);
		
        // Verifica se há uma função associada a este botão
        if (array_length(_button_functions) > _i and _button_functions[_i] != undefined) {
            // Atribui a função associada ao evento de pressionamento do botão esquerdo do mouse
			// AJEITAR!!! Problema principal
            if _sel {
                if mouse_check_button_pressed(mb_left) {
					// Chama a função associada ao botão
					_button_functions[_i]()
					
					play_sound_geral(snd_int_menu_conf)
                }
            }
        }
		
		
		// O DESENHO DOS RETANGULOS E DOS BOTÕES ESTÃO POSICIONADOS CORRETAMENTE PQ SÃO UMA FUNÇÃO "DRAW"
		// NUM EVENTO "DRAW GUI"
        // Desenha o botão
		draw_set_alpha(1 - .2 * _sel)
        draw_set_color(c_white); // Cor de fundo do botão

        draw_rectangle(_button_x - _largura_button / 2, _button_y - _altura_botton / 2, _button_x + _largura_button / 2, _button_y + _altura_botton / 2, false);

        // Desenha o texto centralizado no botão
        draw_set_color(c_black);
        draw_set_font(fnt_pause);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
		draw_text_transformed(_button_x, _button_y, _button_texts[_i], .5, .5, 0)
		
		draw_set_alpha(1)
	}
}

#endregion


//
can_pause = false
