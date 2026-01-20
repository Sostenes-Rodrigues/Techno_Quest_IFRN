/// @description Start Variables
#region Init menu
#region Métodos
// Texto com sombra
shadowed_text = function(_text, _x, _y, _halign, _valign, _shadow_offset, _text_color, _shadow_color, _text_alpha, _shadow_alpha, _txt_w, _txt_h, _xscale=1, _yscale=1, _button=0, _back=true, _line_break=-1) {
	/*
	_text => the texto to be shown
	_x	=>  The X position of the text
	_y	=>	The Y position of the text
	_font	=> The font of the text
	_halign =>	The horizontal alignment of the text (fa_left, fa_center, fa_right)
	_valign	=>	The vertical alignment of the text (fa_top, fa_middle, fa_bottom)
	_text_color => the color of the text
	_shadow_color => the color of the shadow
	_text_alpha	=> the alpha of the text
	_shadow_alpha	=> the alpha of the shadow
	_shadow_offset	=> the shadow offset 
	_delta_x => how many pixls will shake in the X axis
	_delta_y => how manu pixels will shake in the Y axis
	*/
	
	
	// Caso o texto precise ir um pouco para baixo
	var _add_y = 0
	
	// Fundo
	if (_back) draw_sprite_stretched(spr_int_button_menu, 0, _x - _txt_w * _xscale / 2, (_y + _add_y) - _txt_h * _yscale / 2, _txt_w * _xscale, _txt_h * _yscale);
	
	/// Texto
	draw_set_halign(_halign)
	draw_set_valign(_valign)
	draw_set_color(_shadow_color)
	draw_set_alpha(_shadow_alpha)
	
	draw_text_ext_transformed(_x + _shadow_offset, _y + _shadow_offset, _text, -1, _line_break, _xscale, _yscale, 0)
	
	draw_set_alpha(_text_alpha)
	draw_set_color(_text_color)
	
	draw_text_ext_transformed(_x, _y, _text, -1, _line_break, _xscale, _yscale, 0)
	
	draw_set_alpha(1)
	draw_set_color(c_white)
	
	/// Colisão com o mouse
	//draw_rectangle(_x - _txt_w / 2, (_y + _add_y) - _txt_h / 2, _x - _txt_w / 2 +_txt_w, (_y + _add_y) - _txt_h / 2 + _txt_h, true) DEBUG
	if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _x - _txt_w / 2, (_y + _add_y) - _txt_h / 2, _x - _txt_w / 2 +_txt_w, (_y + _add_y) - _txt_h / 2 + _txt_h) and _text != title_text {
		// Indico que estou selecionando pelo mouse
		menu_control_mouse = true
		// Qual botão está selecionado
		selected = _button
		/// Som do passe do botão
		if selected != previous_selected {
			play_sound_geral(snd_int_menu_select)
		}
		
		/// Se clikei nesse botão, ativo sua função
		if mouse_check_button_released(mb_left) action_buttons();
	}
}

// Método que desenha o menu
draw_menu = function(_type_menu) {
	
	
	// Progresso de cada save
	static _slot_progress = [0, 0, 0, 0, 0]
	
	/// Effect init
	ini_time = clamp(ini_time - 1, 0, 50)
	
	if (ini_time > 0) exit;
	
	ini_alp = clamp(ini_alp + .02, 0, 1)
	if (ini_alp < .15) exit;
	draw_set_alpha(ini_alp)
	
	
	// Dimensões da GUI
	static _gui_w = display_get_gui_width()
	static _gui_h = display_get_gui_height()
	
	/// Seletor de curso
	if now_menu == "course selector" {
		#region Start Variables
		// Estrutura de cursos com textos e cores
		static _struct_course_selector = {
			info: {
				txt_p: "Informática",
				txt_d: "Focado em desenvolvimento de sistemas, programação, redes de computadores e tecnologias da informação.",
				cor: make_color_rgb(150, 100, 255),
				tag: "info"
			},
			manu: {
				txt_p: "Manutenção",
				txt_d: "Habilita para instalação, configuração, manutenção e suporte técnico em hardware e software de computadores e redes.",
				cor: make_color_rgb(139, 69, 19),
				tag: "manu"
			},
			agro: {
				txt_p: "Agropecuária",
				txt_d: "Abrange conhecimentos sobre produção animal e vegetal, gestão de propriedades rurais, recursos hídricos e meio ambiente.",
				cor: make_color_rgb(100, 200, 100),
				tag: "agro"
			},
			quimic: {
				txt_p: "Química",
				txt_d: "Trabalha com análises laboratoriais, controle de qualidade, processos químicos e segurança em laboratórios.",
				cor: make_color_rgb(50, 100, 255),
				tag: "quimic"
			}
		}
		
		
		//
		static _load_courses = false
		
		// Nomes das chaves da struct
		static _names_struct = struct_get_names(_struct_course_selector)

		// Quantidade de cursos
		static _length_struct = array_length(_names_struct)

		// Tamanho de cada "cartão"
		static _co_w = _gui_w * 0.2
		static _co_h = _gui_h * 0.7

		// Espaçamento entre os cartões
		static _co_space = _co_w * 0.2

		// Largura total da lista
		static _total_width = _length_struct * _co_w + (_length_struct - 1) * _co_space

		// X inicial para centralizar os cartões
		static _start_x = (_gui_w - _total_width) / 2

		// Controle de seleção
		static _selected = 0
		// Controle de seleção
		static _last_selected = 0
	
		// Prioridade ao mouse
		var _mouse_over = false
		#endregion


		/// Loop desenhando cada cartão (e interração com o mouse e enter)
		for (var i = 0; i < _length_struct; ++i) {
			// Nome da chave
			var _key = _names_struct[i]
			// Struct de cada curso
			var _data = struct_get(_struct_course_selector, _key)

			/// Posições de cada cartão
			var _x = _start_x + i * (_co_w + _co_space)
			var _y1 = _gui_h / 2 - _co_h / 2
			var _y2 = _y1 + _co_h

			// Verificação do mouse
			if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _x, _y1, _x + _co_w, _y2)) {
				// Qual está selecionado
				_selected = i
				// Indica que o mouse está selecionando
				_mouse_over = true
				
				// Se soltei o botão do mouse
				if mouse_check_button_pressed(mb_left) and _load_courses {
					var _choose = struct_get(_data, "tag")
					// Salva o curso escolhido
					save_data("course_choice", _choose)
					//
					save_data("c_quiz", 0)
					
					///
					if _choose == "info" {
						save_data("c_prog", 0)
						save_data("c_html", 0)
					}
					else if _choose == "agro" {
						save_data("c_agro", 0)
						save_data("c_pecu", 0)
					}
					else if _choose == "quimic" {
						save_data("c_reci", 0)
						save_data("c_mole", 0)
					}
					else if _choose == "manu" {
						save_data("c_rede", 0)
						save_data("c_mapc", 0)
					}
					
					// Aciona o método para sair do menu
					exit_menu(_choose, _slot_progress[i])
					
					//
					save_on = false
					
					//
					global.per_com = 0
					
					// Som
					play_sound_geral(snd_int_menu_conf)
				}
			}
			
			// Se esse cartão é o selecionado
			var _is_selected = (_selected == i)

			/// Ajustes de zoom
			var _scale = _is_selected ? 1.1 : 1
			var _w = _co_w * _scale
			var _h = _co_h * _scale
			var _center_x = _x + _co_w / 2
			var _center_y = _gui_h / 2
			var _draw_x1 = _center_x - _w / 2
			var _draw_x2 = _center_x + _w / 2
			var _draw_y1 = _center_y - _h / 2.2
			var _draw_y2 = _center_y + _h / 1.8

			/// Desenha retângulo com cantos arredondados
			draw_set_color(c_white)
			draw_roundrect_ext(_draw_x1, _draw_y1, _draw_x2, _draw_y2, 40, 40, false)

			/// Sprite
			var _spr = asset_get_index("spr_int_player_" + string(_key))
			var _spr_run = asset_get_index("spr_int_player_" + string(_key) + "_walk")
			var _sprite_draw = _is_selected ? _spr_run : _spr
			static _spr_w = _co_w * .5
			static _spr_h = _spr_w * (_co_h / _co_w)
			
			/// Steps subimg
			static _cont = 0
			_cont = (_cont + 1) % ((12 * _length_struct) * sprite_get_number(_sprite_draw))
			var _subimg = floor(_cont / (12 * _length_struct))
			
			// Desenhando a sprite
			draw_sprite_stretched(_sprite_draw, _subimg, _center_x - _spr_w / 2, (_draw_y1 + _co_h * 0.28) - _spr_h / 2, _spr_w, _spr_h)
			
			// Define font
			draw_set_font(fnt_menu_30)
			
			// Texto principal
			shadowed_text(_data.txt_p, _center_x, _draw_y1 + _co_h * 0.6, fa_center, fa_middle, 3, c_black, c_gray, 1, .7, 0, 0, .7, .7, -1, false)
			
			// Texto descritivo
			shadowed_text(_data.txt_d, _center_x, _draw_y1 + _co_h * 0.8, fa_center, fa_middle, 1, c_black, c_gray, 1, .7, 0, 0, .35, .35, -1, false, _co_w*3)
			
			// Reseta font
			draw_set_font(-1)
			
			// Se ele está selecionado
			if (_is_selected) {
				/// Cor de sobreposição
				draw_set_alpha(0.3)
				draw_set_color(_data.cor)
				draw_roundrect_ext(_draw_x1, _draw_y1, _draw_x2, _draw_y2, 40, 40, false)
				draw_set_alpha(1)
				
				// Se prescionei a tecla enter
				if keyboard_check_pressed(vk_enter) and _load_courses {
					var _choose = struct_get(_data, "tag")
					// Salva o curso escolhido
					save_data("course_choice", _choose)
					//
					save_data("c_quiz", 0)
					
					///
					if _choose == "info" {
						save_data("c_prog", 0)
						save_data("c_html", 0)
					}
					else if _choose == "agro" {
						save_data("c_agro", 0)
						save_data("c_pecu", 0)
					}
					else if _choose == "quimic" {
						save_data("c_reci", 0)
						save_data("c_mole", 0)
					}
					else if _choose == "manu" {
						save_data("c_rede", 0)
						save_data("c_mapc", 0)
					}
					
					// Aciona o método para sair do menu
					exit_menu(_choose, _slot_progress[i])
					
					//
					save_on = false
					
					//
					global.per_com = 0
					
					// Som
					play_sound_geral(snd_int_menu_conf)
				}
			}
		}
		
		/// Input via teclado se o mouse não estiver sobre
		if (!_mouse_over) {
			if (keyboard_check_pressed(vk_right)) {
				_selected = (_selected + 1) % _length_struct
			}
			else if (keyboard_check_pressed(vk_left)) {
				_selected = (_selected - 1 + _length_struct) % _length_struct
			}
		}
		
		
		/// Som de selecionar
		if _selected != _last_selected {
			_last_selected = _selected
			
			play_sound_geral(snd_int_menu_select)
		}
		
		//
		_load_courses = true
		
		#region Checklist to skip int
		if (global.com_game) draw_single_checkbox("Pular Introdução", _gui_w / 2, _gui_h * .08);
		#endregion
		
		#region Notice Esc to back
		draw_set_halign(-1)
		draw_set_color(c_white)
		draw_roundrect_ext(-30, -30, 165, 80, 30, 30, false)
		
		draw_set_font(fnt_menu_30)
		draw_set_color(c_black)
		draw_text_transformed(22, 40, "\"Esc\" para\nvoltar", .5, .5, 0)
		draw_set_font(-1)
		draw_set_color(-1)
		
		///
		if keyboard_check_pressed(vk_escape) {
			now_menu = "save slots"
			
			// Feedback sonoro
			play_sound_geral(snd_esc)
		}
		#endregion
	}
	/// Saves Slots
	else if now_menu == "save slots" {
		if global.index_save != -1 {
			_slot_progress[global.index_save] = global.per_com
			global.index_save = -1
		}
		
		#region Variáveis estáticas
		static _slot_width = display_get_gui_width() * 0.6
		static _slot_height = display_get_gui_height() * 0.12
		static _slot_spacing = _slot_height * 0.2
		static _slot_x = (display_get_gui_width() - _slot_width) / 2
		static _slot_y_start = display_get_gui_height() * 0.2
		static _slot_corner = 16
		
		static _hover_index = -1
		
		static _selected_index = -1
		static _last_selected_index = -1
		
		// Impede navegação com teclado quando mouse estiver sobre
		static _input_block = false
		
		
		///
		//
		static _struct_saves = {
			save0: {
				
			},
			save1: {
				
			},
			save2: {
				
			},
			save3: {
				
			},
			save4: {
				
			}
		}
		//
		static _slot_sprites = []
		//show_message(_slot_sprites)
		#endregion
		

		#region Input por Teclado

		// Impede repetição múltipla com uma só tecla
		if !_input_block {
		    if keyboard_check_pressed(vk_down) {
		        _selected_index = (_selected_index + 1) % slot_count
		    }
			else if keyboard_check_pressed(vk_up) {
		        _selected_index = _selected_index - 1
				if (_selected_index < 0) _selected_index = slot_count - 1;
		    }
		}
		#endregion

		#region Desenho do Fundo Principal
		var _bg_x = _slot_x - 20
		var _bg_w = _slot_width + 40
		var _bg_y = _slot_y_start - 20
		var _bg_h = slot_count * (_slot_height + _slot_spacing) - _slot_spacing + 40

		draw_set_alpha(0.6)
		draw_set_color(c_black)
		draw_roundrect_ext(_bg_x - 20, _bg_y, _bg_x + _bg_w + 20, _bg_y + _bg_h, 24, 24, false)
		draw_set_alpha(1)
		#endregion

		#region Desenho dos Slots
		_hover_index = -1
		_input_block = false

		for (var i = 0; i < slot_count; ++i) {
			// Para acessar a struct do save correspondido
			var _index_struct_save = struct_get(_struct_saves, "save" + string(i))
			
			var _y = _slot_y_start + i * (_slot_height + _slot_spacing)
			
			 // Efeito visual
		    var _scale = (_hover_index == i || _selected_index == i) ? 1.05 : 1
		    var _w = _slot_width * _scale
		    var _h = _slot_height * _scale
		    var _x = _slot_x + (_slot_width - _w) / 2
		    var _y_draw = _y + (_slot_height - _h) / 2
			
			
			/// Fundo padrão do slot
		    draw_set_color(c_white)
		    draw_set_alpha(0.6)
		    draw_roundrect_ext(_x, _y_draw, _x + _w, _y_draw + _h, _slot_corner, _slot_corner, false)
		    draw_set_alpha(1)
			
			///
			draw_set_color(c_black)
			draw_set_font(fnt_db)
			
			/// Se for um save já jogado
			if is_string(struct_get(_index_struct_save, "course_choice")) {
			    /// Desenhar ícone do jogador
			    var _spr = _slot_sprites[i]
			    var _icon_size = _h * 0.8
		    
				draw_sprite_stretched(_spr, 0, _x * 1.05, _y_draw + 9, _icon_size * (sprite_get_width(_spr) / sprite_get_height(_spr)), _icon_size)

			    /// Porcentagem de progresso
				draw_set_halign(fa_left)
			    var _pct = string_format(string(round(_slot_progress[i] * 100)) + "%", 0, 0)
			    draw_text(_x + _icon_size + 24, _y_draw + _h * 0.55, "Progresso: " + _pct)
				
				
				#region Botão de deletar o save
				var _bd_px = _slot_x + (_w * .91)
				var _bd_py = _y + _h * .15
				var _bd_sel = false
				static _bd_size = _slot_width * .04
				if point_in_circle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _bd_px + _bd_size / 2, _bd_py + _bd_size / 2, _bd_size / 2) {
					_bd_sel = true
					
					if mouse_check_button_released(mb_left) {
						///
						file_delete("save_" + string(i) + ".json")
						
						//
						save_on = false
						
						// Som de file delete
						play_sound_geral(snd_int_file_delete)
					}
				}	
				draw_set_alpha(1 - (.35 * _bd_sel))
				draw_sprite_stretched(spr_int_icon_delete, 0, _bd_px, _bd_py, _bd_size, _bd_size)
				draw_set_alpha(1)
				#endregion
			}
			// Se for um save novo
			else {
				///
				draw_set_halign(fa_center)
			    draw_set_valign(fa_middle)
				_scale = (_scale == 1.05) ? 1.2 : 1.05
				draw_text_transformed(_x + _w / 2, _y_draw + _h / 2, "Criar Novo Save", _scale, _scale, 0)
			}
			
			///
			draw_set_font(-1)
			
			// Se as informações do save já foram carregadas
			if save_on {
				//
			    var _mouse_over = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _slot_x, _y, _slot_x + _slot_width, _y + _slot_height)

			    // Hover e seleção por mouse
			    if (_mouse_over) {
			        _hover_index = i
			        _input_block = true // Impede navegação por teclado enquanto mouse estiver em cima
				
					//
					_selected_index = i
				
					//
			        if (mouse_check_button_released(mb_left)) {
						// Indicando qual save será jogado
						global.index_save = i
						
						// Som do click
						play_sound_geral(snd_int_menu_conf)
					
						///
						if is_undefined(_slot_sprites[i]) {
							// 
							now_menu = "course selector"
						}
			            else {
							// Aciona o método para sair do menu
							exit_menu(struct_get(_index_struct_save, "course_choice"), _slot_progress[i])
							
							//
							save_on = false
						}
			        }
			    }
			

			    /// Fundo laranja se estiver selecionado
			    if (_selected_index == i) {
			        draw_set_color(c_orange)
			        draw_set_alpha(0.3)
			        draw_roundrect_ext(_x, _y_draw, _x + _w, _y_draw + _h, _slot_corner, _slot_corner, false)
			        draw_set_alpha(1)
				
					// Ação por teclado (ENTER)
					if keyboard_check_pressed(menu_confirmation_buttom) and save_on {
						// Indicando qual save será jogado
						global.index_save = i
						
						// Som do click
						play_sound_geral(snd_int_menu_conf)
						
						///
						if is_undefined(_slot_sprites[i]) {
							// 
							now_menu = "course selector"
						}
			            else {
							// Aciona o método para sair do menu
							exit_menu(struct_get(_index_struct_save, "course_choice"), _slot_progress[i])
							
							//
							save_on = false
						}
					}
			    }
			}
		}
		draw_set_halign(fa_left)
		#endregion
		
		/// Som de selecionar
		if _last_selected_index != _selected_index {
			_last_selected_index = _selected_index
			
			play_sound_geral(snd_int_menu_select)
		}
		
		#region Notice Esc to back
		draw_set_color(c_white)
		draw_roundrect_ext(-30, -30, 165, 80, 30, 30, false)
		
		draw_set_font(fnt_menu_30)
		draw_set_color(c_black)
		draw_text_transformed(22, 40, "\"Esc\" para\nvoltar", .5, .5, 0)
		draw_set_font(-1)
		draw_set_color(-1)
		
		///
		if keyboard_check_pressed(vk_escape) {
			now_menu = menu
			
			_hover_index = -1
			_selected_index = -1
			
			// Feedback sonoro
			play_sound_geral(snd_esc)
		}
		#endregion
	
		// Se os dados dos saves não foram carregados
		if !save_on {
			//
			load_save_slot(_struct_saves)
			//show_message(_struct_saves)
			//
			for (var i = 0; i < slot_count; ++i) {
				
			    ///
				var _index_struct_save = struct_get(_struct_saves, "save" + string(i))
				//show_message(_index_struct_save)
				// Tag do curso
				var _var = struct_get(_index_struct_save, "course_choice")
				//show_message(_var)
				//show_message(typeof(_var))
				//show_message(struct_get(_index_struct_save, _var))
				if is_string(_var) {
					_slot_sprites[i] = asset_get_index("spr_int_player_" + _var)
					
					/// Carregando o progresso
					var _cont_c = 0
					_cont_c += struct_get(_index_struct_save, "c_quiz")
					if _var == "info" {
						_cont_c += struct_get(_index_struct_save, "c_prog")
						_cont_c += struct_get(_index_struct_save, "c_html")
					}
					else if _var == "agro" {
						_cont_c += struct_get(_index_struct_save, "c_agro")
						_cont_c += struct_get(_index_struct_save, "c_pecu")
					}
					else if _var == "quimic" {
						_cont_c += struct_get(_index_struct_save, "c_reci")
						_cont_c += struct_get(_index_struct_save, "c_mole")
					}
					else if _var == "manu" {
						_cont_c += struct_get(_index_struct_save, "c_rede")
						_cont_c += struct_get(_index_struct_save, "c_mapc")
					}
				
					_slot_progress[i] = _cont_c / 3
				}
				else {
					_slot_sprites[i] = undefined
				}
			}
		
			// Não rodar mais certos trechos de código
			save_on = true
		}
	}
	/// View controls (sub-menu option)
	else if now_menu == "controls" {
		
	}
	/// Conf graphic  (sub-menu option)
	else if now_menu == "graphic" {
		// Tamanho e posição do painel
	    var _w = _gui_w * .5
	    var _h = _gui_h * .6
	    var _x = (_gui_w - _w) * 0.5
	    var _y = (_gui_h - _h) * 0.5

	    // Fundo do menu
	    draw_set_color(make_color_rgb(255, 180, 60)) // Laranja
	    draw_roundrect(_x, _y, _x + _w, _y + _h, false)

	    // Título
	    draw_set_font(fnt_menu_30)
	    draw_set_halign(fa_center)
	    draw_set_valign(fa_top)
	    draw_set_color(c_white)
	    draw_text(_x + _w / 2, _y + _h * .02, "Gráficos")
		
		
		#region Switch Tela Cheia (GUI)
		// Posição e tamanho do switch
		var _sw_x = _x + _w * .14;     // posição X do fundo do switch
		var _sw_y = _y + _h * .5;     // posição Y do fundo do switch
		var _sw_w = 80;               // largura do switch
		var _sw_h = 30;               // altura do switch

		// Static vars para manter estado
		static _sw_state = global.win_f // falso = OFF | true = ON
		static _sw_pos   = _sw_state;     // posição do botão animado (0 = esquerda, 1 = direita)

		// Desenha o texto "Tela Cheia"
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_color(c_white);
		draw_text(_sw_x, _sw_y + _sw_h / 2, "Tela Cheia");
		
		///
		static _sw_txt_w = string_width("Tela Cheia") * 4
		var _sw_b_x = _sw_x + _sw_txt_w

		// Checa clique do mouse
		if (mouse_check_button_pressed(mb_left)) {
		    if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _sw_b_x, _sw_y, _sw_b_x + _sw_w, _sw_y + _sw_h)) {
		        _sw_state = !_sw_state; // inverte estado

		        if (_sw_state) {
		            /// AÇÃO QUANDO LIGA (ON)
		            global.win_f = true
		        }
				else {
		            /// AÇÃO QUANDO DESLIGA (OFF)
		            global.win_f = false
					
					window_set_size(1280, 720)
					window_center()
		        }
				
				/// Set fullscreen
				window_set_fullscreen(global.win_f)
				
				// Som do switch
				play_sound_geral(snd_int_switch)
		    }
		}

		// Suaviza a posição (animação)
		var _target = _sw_state ? 1 : 0;
		_sw_pos = lerp(_sw_pos, _target, 0.2); // quanto menor, mais suave (0.1~0.25)

		// Desenha o fundo do switch
		draw_set_color(merge_color(c_red, c_green, _sw_pos)); // transição de vermelho → verde
		draw_roundrect(_sw_b_x, _sw_y, _sw_b_x + _sw_w, _sw_y + _sw_h, false);

		// Posição da bolinha
		var _ball_x = _sw_b_x + 5 + (_sw_w - _sw_h) * _sw_pos;
		var _ball_y = _sw_y + 5;
		var _ball_size = _sw_h - 10;

		// Desenha a bolinha
		draw_set_color(c_white);
		draw_circle(_ball_x + _ball_size / 2, _ball_y + _ball_size / 2, _ball_size / 2, false);
		#endregion


	    // --- Botão Voltar ---
	    var _btn_w = _w * .25
	    var _btn_h = _h * .15
	    var _btn_x1 = _x + (_w - _btn_w) / 2
	    var _btn_y1 = _y + _h * .84
	    var _btn_x2 = _btn_x1 + _btn_w
	    var _btn_y2 = _btn_y1 + _btn_h
		
		static _snd_sel = true
	    var _hover = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _btn_x1, _btn_y1, _btn_x2, _btn_y2)
		if _hover {
			//
			if _snd_sel {
				_snd_sel = false
				play_sound_geral(snd_int_menu_select)
			}
			
			if mouse_check_button_released(mb_left) {
				// Aqui você pode fechar o menu, mudar de estado, etc
		        now_menu = sub_menu_option
				
				// Som do click
				play_sound_geral(snd_int_menu_conf)
			
				// 
				save_data("win_f", global.win_f, "conf")
			}
	    }
		else {
			_snd_sel = true
		}

	    draw_set_color(_hover ? make_color_rgb(100, 255, 100) : make_color_rgb(0, 200, 0))
	    draw_roundrect(_btn_x1, _btn_y1, _btn_x2, _btn_y2, false)

	    draw_set_halign(fa_center)
	    draw_set_valign(fa_middle)
	    draw_set_color(c_white)
	    draw_text_transformed((_btn_x1 + _btn_x2) / 2, (_btn_y1 + _btn_y2) / 2, "Voltar", .8, .8, 0)
	}
	/// Conf sounds   (sub-menu option)
	else if now_menu == "sounds" {
		// Tamanho e posição do painel
	    var _w = _gui_w * .7
	    var _h = _gui_h * .6
	    var _x = (_gui_w - _w) * 0.5
	    var _y = (_gui_h - _h) * 0.5

	    // Fundo do menu
	    draw_set_color(make_color_rgb(255, 180, 60)) // Laranja
	    draw_roundrect(_x, _y, _x + _w, _y + _h, false)

	    // Título
	    draw_set_font(fnt_menu_30)
	    draw_set_halign(fa_center)
	    draw_set_valign(fa_top)
	    draw_set_color(c_white)
	    draw_text(_x + _w / 2, _y, "Volume")
		

	    // --- Sliders ---
	    var _slider_w = _w * .67
	    var _slider_h = _h * .05
	    var _slider_x = _x + (_w - _slider_w) / 2
	    var _knob_r = _h * .065
    
	    // Volume Geral
	    var _slider1_y = _y + _h * .3
	    draw_set_color(c_black)
	    draw_rectangle(_slider_x, _slider1_y - _slider_h/2, _slider_x + _slider_w, _slider1_y + _slider_h / 2, false)
    
	    static _vol_geral = 0
	    _vol_geral = global.sounds_geral_per
		
	    var _knob1_x = _slider_x + _vol_geral * _slider_w
		draw_set_color(c_white)
	    draw_circle(_knob1_x, _slider1_y, _knob_r, false)

	    // Label
	    draw_set_halign(fa_left)
	    draw_set_color(c_black)
	    draw_text_transformed(_slider_x - _w * .12, _slider1_y - _slider_h * .8, "Geral", .5, .5, 0)
		draw_text_transformed(_slider_x + _slider_w + _w * .04, _slider1_y - _slider_h * .8, string(int64(global.sounds_geral_per * 100)) + "%", .5, .5, 0)

	    // Interação do mouse com slider 1
	    if mouse_check_button(mb_left) {
	        var _mx = device_mouse_x_to_gui(0)
	        var _my = device_mouse_y_to_gui(0)
	        if point_in_rectangle(_mx, _my, _slider_x-7, _slider1_y - _knob_r, _slider_x + _slider_w+7, _slider1_y + _knob_r) {
	            _vol_geral = clamp((_mx - _slider_x) / _slider_w, 0, 1)
	            global.sounds_geral_per = _vol_geral
				audio_group_set_gain(audiogroup_default, global.sounds_geral_per, 0)
	        }
	    }

	    // Volume Música
	    var _slider2_y = _y + _h * .6
	    draw_set_color(c_black)
	    draw_rectangle(_slider_x, _slider2_y - _slider_h / 2, _slider_x + _slider_w, _slider2_y + _slider_h / 2, false)
		
	    static _vol_musica = 0
	    _vol_musica = global.sounds_music_per
	    var _knob2_x = _slider_x + _vol_musica * _slider_w
		draw_set_color(c_white)
	    draw_circle(_knob2_x, _slider2_y, _knob_r, false)

	    draw_set_halign(fa_left)
	    draw_set_color(c_black)
	    draw_text_transformed(_slider_x - _w * .12, _slider2_y - _slider_h * .8, "Música", .5, .5, 0)
	    draw_text_transformed(_slider_x + _slider_w + _w * .04, _slider2_y - _slider_h * .8, string(int64(global.sounds_music_per * 100)) + "%", .5, .5, 0)

	    // Interação do mouse com slider 2
	    if mouse_check_button(mb_left) {
	        var _mx = device_mouse_x_to_gui(0)
	        var _my = device_mouse_y_to_gui(0)
	        if point_in_rectangle(_mx, _my, _slider_x-7, _slider2_y - _knob_r, _slider_x + _slider_w+7, _slider2_y + _knob_r) {
	            _vol_musica = clamp((_mx - _slider_x) / _slider_w, 0, 1)
	            global.sounds_music_per = _vol_musica
				audio_group_set_gain(audiogroup_music, global.sounds_music_per, 0)
	        }
	    }

	    // --- Botão OK ---
	    var _btn_w = _w * .25
	    var _btn_h = _h * .15
	    var _btn_x1 = _x + (_w - _btn_w) / 2
	    var _btn_y1 = _y + _h * .84
	    var _btn_x2 = _btn_x1 + _btn_w
	    var _btn_y2 = _btn_y1 + _btn_h
	
		static _snd_sel = true
	    var _hover = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _btn_x1, _btn_y1, _btn_x2, _btn_y2)
		if _hover {
			//
			if _snd_sel {
				_snd_sel = false
				play_sound_geral(snd_int_menu_select)
			}
			
			if mouse_check_button_released(mb_left) {
		        // Aqui você pode fechar o menu, mudar de estado, etc
		        now_menu = sub_menu_option
			
				// Som do click
				play_sound_geral(snd_int_menu_conf)
			
				///
				save_data("vol_g", int64(global.sounds_geral_per * 100), "conf")
				save_data("vol_m", int64(global.sounds_music_per * 100), "conf")
			}
	    }
		else {
			_snd_sel = true
		}

	    draw_set_color(_hover ? make_color_rgb(100, 255, 100) : make_color_rgb(0, 200, 0))
	    draw_roundrect(_btn_x1, _btn_y1, _btn_x2, _btn_y2, false)

	    draw_set_halign(fa_center)
	    draw_set_valign(fa_middle)
	    draw_set_color(c_white)
	    draw_text_transformed((_btn_x1 + _btn_x2) / 2, (_btn_y1 + _btn_y2) / 2, "Voltar", .8, .8, 0)
	}
	/// Menus padrão
	else if !is_string(now_menu) {
		// Largura da gui
		var _x = display_get_gui_width()
		
		#region Title
		/// Só desenha o título se for a tela inicial
		if _type_menu == menu {
			// Set da fonte do título
			draw_set_font(title_font)
	
			// Tamanhos do texto
			var _txt_t_w = string_width(title_text) * 1.1
			var _txt_t_h = string_height(title_text)* 1.17
			// draw title
			shadowed_text(title_text, _x / 2, display_get_gui_width() * .1, fa_center, fa_middle, title_shadow_offset, title_color, title_shadow_color, 1, title_shadow_alpha, _txt_t_w, _txt_t_h)
		}
		#endregion
	
		#region Draw menu
		// Quantidade de botões
		static _number = ds_list_size(_type_menu)
	
		/// Desenhando cada botão com sua função
		draw_set_font(menu_font)
		for (var i = 0; i < _number; i ++) {
			var _text = string(_type_menu[| i]);
			if (_text == "undefined") continue;
			// Tamanhos do texto
			var _txt_w = string_width(_text) * 1.1
			var _txt_h = string_height(_text)* 1.17
			var _color = menu_not_selected_color
			var _sel = selected == i
			if _sel {
				_color = menu_selected_color
			}
		
		
			//
			shadowed_text(_text, _x / 2, menu_start_position + i * menu_separation, fa_center, fa_middle, menu_shadow_offset, _color, menu_shadow_color, (.1 + .7 * _sel) * ini_alp, ini_alp, _txt_w, _txt_h, .9 + .1 * _sel, .9 + .1 * _sel, i)
		}
	
		// Reset da fonte
		draw_set_font(-1)
		#endregion
	
		#region Draw menu arrow
		/// Variação trigonometrica da posição x
		static _angle = 0
		_angle = (_angle + 3) % 357
		var _dx = lengthdir_x(delta_x, _angle)
		
		// Margem
		static _delta_y = -3;
		
		/// Left arrow
		draw_sprite_ext(arrow_sprite, 0, _x / 2 - arrow_width / 2 + menu_shadow_offset + _dx, menu_start_position + selected * menu_separation + _delta_y + menu_shadow_offset, arrow_scale, arrow_scale, 0, menu_shadow_color, menu_shadow_alpha);
		draw_sprite_ext(arrow_sprite, 0, _x / 2 - arrow_width / 2 + _dx, menu_start_position + selected * menu_separation + _delta_y, 1, 1, 0, menu_selected_color, 1);
		/// Right arrow
		draw_sprite_ext(arrow_sprite, 0, _x / 2 + arrow_width / 2 + menu_shadow_offset - _dx, menu_start_position + selected * menu_separation + _delta_y + menu_shadow_offset, -arrow_scale, arrow_scale, 0, menu_shadow_color, menu_shadow_alpha);
		draw_sprite_ext(arrow_sprite, 0, _x / 2 + arrow_width / 2 - _dx, menu_start_position + selected * menu_separation + _delta_y, -1, 1, 0, menu_selected_color, 1);
		#endregion
	}
	
	//
	draw_set_alpha(1)
}

// Aciona a função do botão do menu principal
action_buttons = function() {
	// Sound conf button
	play_sound_geral(snd_int_menu_conf)
	/// Acionando a ação do botão selecionado
	/*
	switch(selected) {
		case 0:	// Começar jogo / Controles
			if now_menu == menu {
				//
				now_menu = "save slots"
			}
			else if now_menu == sub_menu_option {
				now_menu = "controls"
			}
			break;
		case 1:	// Opções / Gráficos
			if now_menu == menu {
				//
				now_menu = sub_menu_option
				//
				selected = 0
			}
			else if now_menu == sub_menu_option {
				now_menu = "graphic"
			}
			break;
		case 2:	// Creditos / Sons
			if now_menu == menu {
				// Chamada da função para rodar os creditos
			}
			else if now_menu == sub_menu_option {
				now_menu = "sounds"
			}
			break;
		case 3: // Sair / Voltar
			if now_menu == menu {
				// Sai do jogo
				game_end()
			}
			else if now_menu == sub_menu_option {
				//
				now_menu = menu
				//
				selected = 0
			}
			break;
	}*/
	switch(selected) {
		case 0:	// Começar jogo / Controles
			if now_menu == menu {
				//
				now_menu = "save slots"
			}
			else if now_menu == sub_menu_option {
				now_menu = "graphic"
			}
			break;
		case 1:	// Opções / Gráficos
			if now_menu == menu {
				//
				now_menu = sub_menu_option
				//
				selected = 0
			}
			else if now_menu == sub_menu_option {
				now_menu = "sounds"
			}
			break;
		case 2:	// Creditos / Sons
			if now_menu == menu {
				/// Chamada da função para rodar os creditos
				// Se o obj controle da transição ainda não foi criado
				if !instance_exists(obj_control_transition_rooms) {
					// Passando qual a room o jogo deve direcionar
					global.next_room = rm_credits
					//
					global.menu_to_cred = true
		
					/// Aciono o obj de transição
					var _c_tra = instance_create_layer(0, 0, "Instances", obj_control_transition_rooms)
					with(_c_tra) {
						/// Passando os assets das sequencias de entrada e saida
						asset_seq_in  = seq_transcao_in
						asset_seq_out = seq_transcao_out
						/// Passando a posição de onde a câmera de começar na proxima sala
						global.next_room_posx = 0
						global.next_room_posy = 0
				
						// Indico se a proxima room vai ter o player ou não
						global.next_room_with_player = false
						// 
						next_with_mouse = false
						// Indico se o player está na sala atual
						player_in_room = true
				
						// Acionando o método que cria a sequencia de saida
						exit_room()
					}
					
					// Destruo o menu
					instance_destroy(obj_int_control, false)
				}
			}
			else if now_menu == sub_menu_option {
				//
				now_menu = menu
				//
				selected = 0
			}
			break;
		case 3: // Sair / Voltar
			if now_menu == menu {
				// Sai do jogo
				game_end()
			}
			break;
	}
}

// Carrega as informações dos saves usadas no slot de saves
load_save_slot = function(_return_struct) {
	// Passando por cada save
	for (var i = 0; i < slot_count; ++i) {
		// Para acessar a struct do save correspondido
		var _name_struct_save = "save" + string(i)
		
		// Nome do arquivo do save slot atual
		var _file_name = "save_" + string(i) + ".json"
	
		// Abrindo o arquivo do save ou criando caso não exista
		var _file = file_text_open_read(_file_name)
		
		// Se esse save já foi criado
		if _file {
			// Lendo as informações
			var _json_string = file_text_read_string(_file)
			
			// Fechando o arquivo
			file_text_close(_file)
			
			// Convertendo a string em struct
			var _data = json_parse(_json_string)
			
			//
			//_return_struct._index_struct_save = _data
			struct_set(_return_struct, _name_struct_save, _data)
		}
		// Se esse save ainda não tinha sido criado
		else {
			// Criando a struct com os meus dados
			var _data = {
				///
				course_choice: 0,
				last_rm: room_get_name(rm_int_ifrn_outside)
			}
			
			//
			//_return_struct._index_struct_save = _data
			struct_set(_return_struct, _name_struct_save, _data)
	
			// Convertendo os dados em json
			var _json_string = json_stringify(_data)
			
			// Abrindo o arquivo do save ou criando caso não exista
			_file = file_text_open_write(_file_name)
			
			// Gravando as informações nele
			file_text_write_string(_file, _json_string)
			
			// Fechando o arquivo
			file_text_close(_file)
		}
	}
}

// Chamado para quando é iniciado o jogo e o player pode se mover
exit_menu = function(_tag, _per) {
	// Desativando o menu
	can_menu = false
	
	///
	global.sel_course = _tag
	global.per_com	  = _per
					
	/// 
	if instance_exists(obj_int_player) {
		with(obj_int_player) {
			///
			player_can_move = true
			sprite_stop = asset_get_index("spr_int_player_" + _tag)
			sprite_walk = asset_get_index("spr_int_player_" + _tag + "_walk")
			//
			init_sprite()
			
			
		}
	}
	// Centralizando o player na câmera para ter um efeito
	if instance_exists(obj_camera) obj_camera.view_y_menu_effect = 0;
	// Permitindo que o jogo seja pausado
	if instance_exists(obj_pause) obj_pause.can_pause = true;
	
	
	///
	window_set_cursor(cr_none)
	
	///
	var _l_rm = undefined
	if checkbox_checked {
		_l_rm = rm_int_lobby
	}
	else {
		_l_rm = asset_get_index(get_data("last_rm"))
	}
	
	//
	if _l_rm != room {
		// Se o obj controle da transição ainda não foi criado
		if !instance_exists(obj_control_transition_rooms) {
			// Passando qual a room o jogo deve direcionar
			global.next_room = _l_rm
		
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
				// 
				next_with_mouse = false
				// Indico se o player está na sala atual
				player_in_room = true
				
				// Acionando o método que cria a sequencia de saida
				exit_room()
			}
		}
		
		return /// WAIT ///
	}
	
	// Mostrar controles
	show_controls = "move"
}

// 
// _why = string com o nome do tutorial a ser ensinado ("move" e "interact")
draw_show_controls = function(_why) {
	static _last_type = ""
	static _player_move = false
	
	static _spr_x = 0
	static _spr_y = 0
	static _spr = spr_int_icon_WASD_setas
	static _spr_a_w = 0
	static _spr_a_h = 0
	static _spr_w = 0
	static _spr_h = 0
	static _txt_x = 0
	static _txt_y = 0
	static _txt = ""
	
	///
	if _why != _last_type {
		if _why == "move" {
			_spr_x = display_get_gui_width() / 2
			_spr_y = display_get_gui_height() * .2
			_spr = spr_int_icon_WASD_setas
			_spr_a_w = sprite_get_width(_spr)
			_spr_a_h = sprite_get_height(_spr)
			_spr_w = display_get_gui_width() * .3
			_spr_h = _spr_w * (_spr_a_h / _spr_a_w)
			_txt_x = _spr_x
			_txt_y = _spr_y - display_get_gui_height() * .1
			_txt = "Movimentação"
			
			_last_type = "move"
		}
		else if _why == "interact" {
			_spr_x = display_get_gui_width() / 1.7
			_spr_y = display_get_gui_height() * .1
			_spr = spr_int_icon_E
			_spr_a_w = sprite_get_width(_spr)
			_spr_a_h = sprite_get_height(_spr)
			_spr_w = display_get_gui_width() * .06
			_spr_h = _spr_w * (_spr_a_h / _spr_a_w)
			_txt_x = _spr_x - display_get_gui_width() * .135
			_txt_y = _spr_y + _spr_h / 2
			_txt = "Interragir:"
			
			_last_type = "interact"
			
			alp_controls = 0
		}
	}
	
	
	if _why == "move" {
		///
		if _player_move {
			alp_controls = clamp(alp_controls - 0.01, 0, 1)
		
			if alp_controls <= 0.1 {
				show_controls = 0
			
				_player_move = false
			}
		}
		else {
			alp_controls = clamp(alp_controls + 0.01, 0, 1)
			
			if instance_exists(obj_int_player) {
				with(obj_int_player) {
					if (x != xprevious or y != yprevious) _player_move = true;
				}
			}
		}
	}
	else if _why == "interact" {
		alp_controls = clamp(alp_controls + 0.01, 0, 1)
	}
	
			
	///
	draw_set_valign(1)
	draw_set_alpha(alp_controls)
	draw_set_font(fnt_menu_30)
	draw_set_halign(fa_center)
	draw_set_color(c_white)
	var _txt_w = string_width(_txt)  * 1.1
	var _txt_h = string_height(_txt) * 1.1
	var _col = make_color_rgb(40, 40, 40)
	draw_rectangle_color(_txt_x - _txt_w / 2, _txt_y - _txt_h / 2, _txt_x + _txt_w / 2 - 7, _txt_y + _txt_h / 2, _col, _col, _col, _col, false)
	draw_text(_txt_x, _txt_y, _txt)
	draw_sprite_stretched(_spr, 0, _spr_x - _spr_w / 2, _spr_y, _spr_w, _spr_h)
	draw_set_alpha(1)
	draw_set_font(-1)
	draw_set_halign(-1)
}

///
draw_single_checkbox = function(_texto, _x, _y) {
	// Font
	draw_set_font(fnt_menu_30)

    // --- Configurações ---
    var _box_size = 28
    var _padding = 12
    var _text_x = _x
    var _text_w = string_width(_texto) * .7
    var _text_h = string_height(_texto) * .7
    var _box_x = _x + _padding + _text_w / 2
    var _box_y = _y - _box_size / 2
    var _back_padding = 10

    var _mx = device_mouse_x_to_gui(0)
    var _my = device_mouse_y_to_gui(0)
    var _click = mouse_check_button_pressed(mb_left)

    // --- Fundo branco ---
    var _back_x1 = _x - _text_w / 2 - _back_padding
    var _back_y1 = _y - _text_h / 2 - _back_padding
    var _back_x2 = _box_x + _box_size + _back_padding
    var _back_y2 = _y + _text_h / 2 + _back_padding

    draw_set_color(c_white)
    draw_roundrect(_back_x1, _back_y1, _back_x2, _back_y2, false)

    // --- Texto ---
    draw_set_color(c_black)
    draw_set_halign(fa_center)
    draw_set_valign(fa_middle)
    draw_text_transformed(_text_x, _y, _texto, .7, .7, 0)

    // --- Caixa do check ---
    draw_set_color(c_dkgray)
    draw_rectangle(_box_x, _box_y, _box_x + _box_size, _box_y + _box_size, false)

    // Hover e clique
    if point_in_rectangle(_mx, _my, _box_x, _box_y, _box_x + _box_size, _box_y + _box_size) {
        draw_set_color(c_gray)
        draw_rectangle(_box_x - 2, _box_y - 2, _box_x + _box_size + 2, _box_y + _box_size + 2, false)
        if _click {
            checkbox_checked = !checkbox_checked
        }
    }

    // --- Atualiza animação ---
    var _target_alpha = checkbox_checked ? 1 : 0
    var _target_scale = checkbox_checked ? 1 : 0.8
    checkbox_check_alpha = lerp(checkbox_check_alpha, _target_alpha, 0.15)
    checkbox_check_scale = lerp(checkbox_check_scale, _target_scale, 0.15)

    // --- Desenha o "✓" com efeito suave ---
    if checkbox_check_alpha > 0.01 {
        draw_set_color(c_lime)
        var _le = _box_size * (checkbox_check_scale * .8)
        var _xx = _box_x + (_box_size - _le) / 2
        var _yy = _box_y + (_box_size - _le) / 2
        draw_sprite_stretched_ext(spr_int_checklist, 0, _xx, _yy, _le, _le, c_lime, checkbox_check_alpha)
    }

    draw_set_color(c_white)
}
#endregion

#region Start Variables
// Usado para trechos que só precisam rodar uma vez/depois das informações serem carregadas
save_on = false

/// Effect init
ini_time = 60
ini_alp = 0.1

// Número de slots de save
slot_count = 5

// Se é pra desenhar o menu
can_menu = true

// Create the list for the menu
menu = ds_list_create();	// list of menu items
ds_list_add(menu, "Começar Jogo", "Configurações", "Créditos", "Sair do jogo")	// the menu items, add or remove items to customize

// Create the list for the menu
sub_menu_option = ds_list_create();	// list of menu items
//ds_list_add(sub_menu_option, "Controles", "Gráficos", "Sons", "Voltar")
ds_list_add(sub_menu_option, "Gráficos", "Sons", "Voltar")

// Qual a parte do menu atual
now_menu = menu

// Menu selected
selected = 0;	// number of the list above that start selected (the first one is 0, the second one is 1 and so on)

/// Menu variables
menu_start_position = 350;	// start y position of the menu
menu_separation = 80;		// y sepraration between menu items
delta_x = 10;	// maximum x movement for the arrow animation
arrow_width = 430; // amount of pixels of distance between arrows
arrow_sprite = spr_int_arrow_menu;	// sprite of the arrow
arrow_scale = 1;	// scale of the arrow sprite

/// Text variables
/// Title
title_text = "Techno Quest IFRN"	// the title of the menu
title_color = make_colour_rgb(47, 158, 65) // the title color
title_font = fnt_menu_60	// the title font
title_shadow_offset = 5	// the title shadow offset
title_shadow_color = c_green	// the title shadow color
title_shadow_alpha = 1	// the title shadow alpha

/// Menu items
menu_font = fnt_menu_30;	// the menu items font
menu_selected_color = c_lime;	// the menu selected item color and this affects the color blend of the arrow
menu_not_selected_color = c_yellow;	// the menu not selected items color
menu_shadow_offset = 2;	// the menu items and arrow shadow offset
menu_shadow_alpha = 1;	// the menu items shadow alpha
menu_shadow_color = c_gray;	// the menu items shadow color

/// Sounds
sound_change = snd_int_menu_select;	// sound when changing the selection
sound_confirmation = snd_int_menu_conf;	// sound when selecting a menu item
// Qual o botão anteriomente selecionado no menu principal
previous_selected = noone

/// Menu control buttoms
menu_confirmation_buttom = vk_enter;	// the buttom to confirm the menu item selected
menu_up_buttom = vk_up;	// the buttom to change the menu item
menu_down_buttom = vk_down;	// the buttom to change the menu item
// Se a seleção é pelo mouse no menu inicial
menu_control_mouse = false

// Quando o jogo começar, mostro os controles
show_controls = false

//
alp_controls = 0

// Checkbox
checkbox_checked = false
checkbox_check_alpha = 0
checkbox_check_scale = 0.8
#endregion
#endregion

///
window_mouse_set(window_get_width() / 2, window_get_height() / 2.7)
window_set_cursor(cr_default)

//
obj_pause.can_pause = false
