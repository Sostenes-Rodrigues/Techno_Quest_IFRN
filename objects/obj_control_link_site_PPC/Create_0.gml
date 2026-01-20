// Estado da mensagem de cópia (fade)
copy_alpha = 0

/// Método de UI para link institucional
draw_link_ui = function() {
    /// URL que será exibida
    var _url = "https://portal.ifrn.edu.br/cursos"
	if !global.menu_to_cred {
		if global.sel_course == "info" {
			_url = "https://portal.ifrn.edu.br/cursos/tecnicos/tecnico-integrado/informatica/"	
		}
		else if global.sel_course == "agro" {
			_url = "https://portal.ifrn.edu.br/cursos/tecnicos/tecnico-integrado/agropecuaria/"	
		}
		else if global.sel_course == "manu" {
			_url = "https://portal.ifrn.edu.br/cursos/tecnicos/tecnico-integrado/manutencao-e-suporte-em-informatica/"	
		}
		else if global.sel_course == "quimic" {
		_url = "https://portal.ifrn.edu.br/cursos/tecnicos/tecnico-integrado/quimica/"	
	}
	}


    /// Área da tela
    var _w = display_get_gui_width()
    var _h = display_get_gui_height()

    /// --- Configuração das posições da caixa de fundo ---
    var _margin = 50
    var _box_w = _w * 0.8
    var _box_h = _h * 0.5
    var _box_x = _w * 0.1
    var _box_y = _h * 0.2

    /// Spr e tamanho do botão de copiar
    var _copy_spr = spr_icon_copy_url
    var _copy_w = _box_w * .035
    var _copy_h = _copy_w
	
	/// Posição da url
	var _url_x = _w / 2 - _copy_w
    var _url_y = _box_y + _box_h / 1.6
	
	/// Posição do botão de copiar
	var _copy_x = _url_x + _copy_w + _margin * 1.5 + _copy_w
    var _copy_y = _url_y - _copy_h / 2

    /// Botão de voltar
    var _back_w = 180
    var _back_h = 50
    var _back_x = (_w - _back_w) / 2
    var _back_y = _h - _back_h - _margin
	
	//
	draw_set_font(fnt_dialogue)

    /// --- Caixa de fundo ---
    draw_set_color(make_color_rgb(40, 40, 40))
    draw_roundrect(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, false)

    // Título
    draw_set_color(c_white)
    draw_set_halign(fa_center)
    draw_set_valign(fa_top)
    draw_text_ext(_w / 2, _box_y + _box_h * .2, "Acesse o portal oficial da instituição para consultar informações detalhadas sobre os cursos e suas ementas.", -1, _box_w * .8)

    /// --- URL clicável ---
	/// Quebra de linha no meio do link

	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)

	/// Divide o link ao meio
	var _mid = string_length(_url) div 2
	var _url_line1 = string_copy(_url, 1, _mid)
	var _url_line2 = string_copy(_url, _mid + 1, string_length(_url) - _mid)

	/// Medidas
	var _mx = device_mouse_x_to_gui(0)
	var _my = device_mouse_y_to_gui(0)

	var _url_line_h = string_height(_url_line1)
	var _url_line_w1 = string_width(_url_line1)
	var _url_line_w2 = string_width(_url_line2)

	/// Posição Y das duas linhas
	var _line1_y = _url_y - _url_line_h * 0.6
	var _line2_y = _url_y + _url_line_h * 0.6

	/// Retângulo total do link (para clique)
	var _min_w = max(_url_line_w1, _url_line_w2)

	var _url_x1 = _url_x - _min_w/2
	var _url_x2 = _url_x + _min_w/2
	var _url_y1 = _line1_y - _url_line_h/2
	var _url_y2 = _line2_y + _url_line_h/2

	/// Hover
	var _hover_url = point_in_rectangle(_mx, _my, _url_x1, _url_y1, _url_x2, _url_y2)

	/// Cor hover
	draw_set_color(_hover_url ? c_aqua : c_blue)

	/// Desenho das duas linhas
	draw_text(_url_x, _line1_y, _url_line1)
	draw_text(_url_x, _line2_y, _url_line2)

	/// Sublinhado independente para cada linha
	if (_hover_url) {
	    draw_line(_url_x - _url_line_w1/2, _line1_y + _url_line_h/2,
	              _url_x + _url_line_w1/2, _line1_y + _url_line_h/2)

	    draw_line(_url_x - _url_line_w2/2, _line2_y + _url_line_h/2,
	              _url_x + _url_line_w2/2, _line2_y + _url_line_h/2)
	}

	/// Clique para abrir link
	if (_hover_url && mouse_check_button_pressed(mb_left)) {
	    url_open(_url)
	}

	/// --- Botão copiar ---
	/// Centralizado entre as duas linhas

	var _copy_spr = spr_icon_copy_url
	var _copy_w = _box_w * .035
	var _copy_h = _copy_w

	var _copy_x = _url_x + _min_w/2 + _margin
	var _copy_y = (_line1_y + _line2_y)/2 - _copy_h/2

	var _hover_copy = point_in_rectangle(_mx, _my, _copy_x, _copy_y, _copy_x + _copy_w, _copy_y + _copy_h)

	draw_sprite_stretched_ext(
	    _copy_spr, 0,
	    _copy_x, _copy_y, _copy_w, _copy_h,
	    _hover_copy ? make_color_rgb(250, 250, 250) : make_color_rgb(190, 190, 190),
	    1
	)

	if (_hover_copy && mouse_check_button_pressed(mb_left)) {
	    clipboard_set_text(_url)
	    copy_alpha = 1
	}

    // --- Botão voltar ---
    var _hover_back = point_in_rectangle(_mx, _my, _back_x, _back_y, _back_x + _back_w, _back_y + _back_h)

    draw_set_color(_hover_back ? make_color_rgb(220, 50, 50) : c_red)
    draw_roundrect(_back_x, _back_y, _back_x + _back_w, _back_y + _back_h, false)

    draw_set_color(c_white)
    draw_text(_back_x + _back_w/2, _back_y + _back_h/2, "Voltar ao Menu")

    if (_hover_back && mouse_check_button_pressed(mb_left)) {
        // Aqui você coloca o que deve acontecer ao voltar
        if !instance_exists(obj_control_transition_rooms) {
			// Passando qual a room o jogo deve direcionar
			global.next_room = rm_int_ifrn_outside
	
			//
			window_set_cursor(cr_none)
	
	
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
				player_in_room = false
				
				// Acionando o método que cria a sequencia de saida
				exit_room()

				global.pause = false
			}
		}
    }

    // --- Mensagem de cópia com fade ---
    if (copy_alpha > 0) {
        draw_set_alpha(copy_alpha)
        draw_set_color(c_white)
        draw_set_halign(fa_center)
        draw_set_valign(fa_middle)
        draw_text(_w/2, _copy_y - 30, "URL copiada para área de transferência")
        draw_set_alpha(1)

        copy_alpha -= 0.015 // diminui até sumir
    }
}
