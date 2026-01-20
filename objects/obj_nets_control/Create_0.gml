/// Criando o tutorial
if !global.tu_pass_rede {
	global.tu_pass_rede = true
	
	var _tu = instance_create_layer(0, 0, "Instances", obj_tutorial)
	with (_tu) {
		tutorial_imgs = [spr_nets_tutorial1, spr_nets_tutorial2, spr_nets_tutorial3]
		tutorial_string = ["Enquanto estava fora, seus sobrinhos bargunçaram todas as coxeções da casa, agora você precisa fazer que tudo volte a funcionar (siga a lista no canto superior direito).",
		"Use o botão esquerdo do mouse para interagir com o cenário.",
		"Embaixo você pode exibir ou esconder seu inventário que guarda os cabos achados, segure um item e solte onde deseja usa-lo."]
		
		tutorial_length = array_length(tutorial_imgs) - 1
	}
}


// Tocando a música
play_sound_music(snd_nets_theme)

// Guarda o item atual do mouse
item_in_mouse = noone

/// Para saber se o mouse está sobre as interfaces do inventario e da lista de tarefas
mouse_in_tl = false
mouse_in_inv = false

// Espaço para salvar a 1° conexão
link_1 = noone

// Acionador da animação de pegar um item (essa variavel vira uma lista)
trigger_get_item = false

// Guarda o progresso da lista de tarefas
task_list_struct = {
	cables_finds: 0,
	cables_finds_max: 5,
	rot: "c_red",
	cel: "c_red",
	pc:  "c_red",
	mo:  "c_red",
	tv:  "c_red",
	tv_hdmi:  false,	// Precisa desses 2 para a tv está conectada
	tv_coaxial:  false, // Precisa desses 2 para a tv está conectada
	imp: "c_red"
}

// Listas das sprites dos controles de cada parte das conecções que devem ser desenhadas
parts_on_wires = [[false, spr_nets_on_cel, 66, 192], [false, spr_nets_on_coaxial_cod, 68, 149], [false, spr_nets_on_hdmi_mo, 257, 128], [false, spr_nets_on_hdmi_tv, 104, 138], [false, spr_nets_on_imp, 321, 165], [false, spr_nets_on_mo, 274, 120], [false, spr_nets_on_parT_pc, 211, 131], [false, spr_nets_on_tv, 77, 96], [false, spr_nets_on_usb_imp, 257, 137]]

// Criando a grid para o inventario de cabos
grid_inventory = ds_grid_create(12, 1)
ds_grid_clear(grid_inventory, noone)

//
draw_text_get_gui = [0, 0, 0, "", "", 0, 0]


///
// Struct com as informações dos cabos encondidos
hidden_cables_struct = {
	coaxial: {
		spr : spr_nets_hidden_coaxial,
		xpos: 260,
		ypos: 201,
		find: false,
		icon: spr_nets_icon_coaxial,
		ti:   "Cabo Coaxial",
		desc: "Cabo de transmissão de sinal de rádio frequência, utilizado principalmente para TV por assinatura e internet via operadora. Uma extremidade conecta-se ao decodificador e a outra à tomada coaxial proveniente da rede externa."
	},
	hdmi1: {
		spr : spr_nets_hidden_hdmi1,
		xpos: 151,
		ypos: 168,
		find: false,
		icon: spr_nets_icon_hdmi,
		ti:   "Cabo HDMI",
		desc: "Interface digital de alta definição para transmissão simultânea de áudio e vídeo entre dispositivos. Normalmente liga a saída de aparelhos reprodutores à entrada HDMI de monitores ou televisores."
	},
	hdmi2: {
		spr : spr_nets_hidden_hdmi2,
		xpos: 80,
		ypos: 196,
		find: false,
		icon: spr_nets_icon_hdmi,
		ti:   "Cabo HDMI",
		desc: "Interface digital de alta definição para transmissão simultânea de áudio e vídeo entre dispositivos. Normalmente liga a saída de aparelhos reprodutores à entrada HDMI de monitores ou televisores."
	},
	parT: {
		spr : spr_nets_hidden_parT,
		xpos: 152,
		ypos: 25,
		find: false,
		icon: spr_nets_icon_par_t,
		ti:   "Cabo Par Trançado",
		desc: "Condutor de dados em redes locais, composto por pares de fios entrelaçados para reduzir interferências. Realiza a conexão entre roteadores, switches e dispositivos de rede por meio de portas RJ-45."
	},
	usb: {
		spr : spr_nets_hidden_usb,
		xpos: 378,
		ypos: 208,
		find: false,
		icon: spr_nets_icon_usb,
		ti:   "Cabo USB",
		desc: "Padrão universal para conexão e alimentação de periféricos. Possui variações de formato entre as pontas, sendo a conexão típica feita entre o computador e dispositivos como impressoras e teclados."
	}
}
//
rot_col = c_red

/// Métodos
// Controle referente aos cabos encondidos
control_hiddens = function() {
	#region Cables
	#region Set de variaveis
	// Nomes de todos os nomes principais da struct com as informações dos cabos encondidos
	static _hidden_cables_struct_names = struct_get_names(hidden_cables_struct)
	#endregion
	
	/// Criando os desenhos e as colisões
	for (var i = 0; i < array_length(_hidden_cables_struct_names); ++i) {
		// Struct de cada cabo
		var _struct_i = struct_get(hidden_cables_struct, _hidden_cables_struct_names[i])
		
		// Se esse cabo NÃO foi achado
		if !_struct_i.find {
			// Sprite do cabo atual
			var _i_spr = _struct_i.spr
		
		    /// Largura e altura de cada cabo
			var _spr_width  = sprite_get_width(_i_spr)
			var _spr_height = sprite_get_height(_i_spr)
			
			//
			if !(global.pause or instance_exists(obj_tutorial)) {
				// Se o mouse está tocando nesse cabo
				var _mouse_in_but = point_in_rectangle(mouse_x, mouse_y, _struct_i.xpos, _struct_i.ypos, _struct_i.xpos + _spr_width, _struct_i.ypos + _spr_height)
			
				// Se clikei nesse cabo
				if _mouse_in_but and mouse_check_button_released(mb_left) and !mouse_in_tl and !mouse_in_inv and !item_in_mouse and !is_array(trigger_get_item) {
					// Informando que esse cabo foi achado
					_struct_i.find = true
				
					/// Vendo qual elemento da grid está vazia ou se é do mesmo tipo do desse cabo
					for (var c = 0; c < ds_grid_width(grid_inventory); ++c) {
						// Sprite do cabo atual
						var _i_icon = _struct_i.icon
					
					    // Se esse elemento da grid já preenchido
						if is_array(grid_inventory[# c, 0]) {
							// Se esse elemento for igual ao pego
							if grid_inventory[# c, 0][0] == _i_icon {
								// Aumento sua quantidade
								grid_inventory[# c, 0][1]++
							
								// Para o teste
								break
							}
						}
						// Se esse elemento da grid está vazia
						else {
							// Adiciono o cabo achado no inventario
							grid_inventory[# c, 0] = [_i_icon, 1]
						
							//
							trigger_get_item = [_i_icon, _struct_i.ti, _struct_i.desc]
						
							// Para o teste
							break
						}
					}
				
					// Somando 1 na quantidade de cabos achados
					task_list_struct.cables_finds++
					
					// Feedback do item pego
					play_sound_geral(snd_nets_get_item)
				}
			}
			
			/// Desenhando cada cabo
			draw_sprite(_i_spr, 0, _struct_i.xpos, _struct_i.ypos)
		}
	}
	#endregion
	
	#region Rot
	/// Variaveis do roteador
	static _rot_x = 191
	static _rot_y = 130
	static _rot_w = sprite_get_width(spr_nets_rot_light)
	static _rot_h = sprite_get_height(spr_nets_rot_light)
	
	// Desenhando a cor do display
	draw_sprite_stretched_ext(spr_nets_rot_light, 0, _rot_x, _rot_y, _rot_w, _rot_h, rot_col, 1)
	
	// Se ele está desligado
	if rot_col == c_red {
		/// Se clikei no roteador
		if point_in_rectangle(mouse_x, mouse_y, 187, 115, 210, 133) and !(global.pause or instance_exists(obj_tutorial)) {
			if mouse_check_button_released(mb_left) and !item_in_mouse and !is_array(trigger_get_item) {
				/// Indico que ele está ligado
				rot_col = c_green
				task_list_struct.rot = "c_green"
				
				// Feedback do item pego
				play_sound_geral(snd_nets_get_item)
				
				/// Vendo qual elemento da grid está vazia
				for (var c = 0; c < ds_grid_width(grid_inventory); ++c) {
					// Se esse elemento da grid está vazio
					if !is_array(grid_inventory[# c, 0]) {
						// Adiciono o wifi ao inventario
						grid_inventory[# c, 0] = [spr_nets_icon_wifi, 1]
						
						//
						trigger_get_item = [spr_nets_icon_wifi, "Wifi", "Tecnologia de comunicação sem fio baseada em ondas de rádio, utilizada para acesso à rede local e à internet. Muito usado em dispositivos móveis."]
						
						// Paro o teste
						break
					}
				}
			}
		}
	}
	#endregion
}

// Método que cria as coisas do draw gui
method_gui = function() {
	#region Task list
	/// Definindo a fonte, o alinhamento vertical e a cor
	draw_set_font(fnt_nets_tl)
	draw_set_valign(fa_top)
	draw_set_color(c_black)
	
	#region Set de variaveis
	// Largura da lista
	static _tl_width = display_get_gui_width() * .24
	// Cor de fundo da lista
	static _tl_col = c_gray
	
	// A lista fica no canto superior direito
	static _tl_x = display_get_gui_width() + _tl_width
	
	
	/// Margens da lista
	static _tl_ma_top = 5
	static _tl_ma_down = 5
	static _tl_ma_lr = 5
	
	// String
	var _text = $"[c_black][fnt_nets_tl]Ache os cabos: {task_list_struct.cables_finds}/{task_list_struct.cables_finds_max}\nLigue o roteador [{task_list_struct.rot}][scale,0.3][spr_nets_view_task, 0][c_black][scale,1]\nConecte o wifi no celuar [{task_list_struct.cel}][scale,0.3][spr_nets_view_task, 0][c_black][scale,1]\nLigue o cabo de rede no PC [{task_list_struct.pc}][scale,0.3][spr_nets_view_task, 0][c_black][scale,1]\nFaça o monitor pegar vídeo [{task_list_struct.mo}][scale,0.3][spr_nets_view_task, 0][c_black][scale,1]\nFaça a TV pegar sinal [{task_list_struct.tv}][scale,0.3][spr_nets_view_task, 0][c_black][scale,1]\nLigue a impresora no PC [{task_list_struct.imp}][scale,0.3][spr_nets_view_task, 0]"
	
	// Largura que o texto deve ocupar
	var _text_w = sprite_get_width(_tl_width) - _tl_ma_lr * 2
	
	// Altura que o texto deve ocupar
	var _text_h = string_height_ext(_text, -1, _text_w)
	
	// Tamanho do botão de switch
	static _tl_switch_width  = display_get_gui_width() * 0.017
	static _tl_switch_height = display_get_gui_height() * 0.1

	// Velocidade da animação
	static _tl_speed = 20

	// Estado de visibilidade (mostrar ou esconder)
	static _tl_open = true

	// Ângulo da seta
	static _tl_arrow_rot = -90
	
	// Centro X do botão
	var _tl_switch_x = _tl_x - _tl_width - _tl_switch_width
	// Pos y do botão
	var _tl_switch_y = _text_h / 2
	
	// Cor de fundo do switch
	var _tl_switch_col = c_dkgray
	#endregion
	
	
	#region Text box
	//
	if !(global.pause or instance_exists(obj_tutorial)) {
		/// Acionando o botão do switch
		if (point_in_rectangle(device_mouse_x_to_gui(0) + (-display_get_gui_width() * is_array(trigger_get_item)), device_mouse_y_to_gui(0), _tl_x - _tl_width - _tl_switch_width, _text_h / 2 - _tl_switch_height / 2 + _tl_ma_top, _tl_x - _tl_width - 1, _text_h / 2 + _tl_switch_height / 2 + _tl_ma_down)) or (!_tl_open and (item_in_mouse or is_array(trigger_get_item))) {
			// Indico que estou tocando no tl
			mouse_in_tl = true
		
			if (mouse_check_button_pressed(mb_left) or (!_tl_open and (item_in_mouse or is_array(trigger_get_item)))) and !is_array(link_1) {
				// Invertando o estado de visibilidade
			    _tl_open = !_tl_open

			    // Gira a seta em 180°
			    _tl_arrow_rot *= -1
			}
		}
		// Se o mouse NÃO está no botão
		else {
			// Indico que NÃO estou tocando no tl
			mouse_in_tl = false
		
			// Se o mouse está dentro do espaço da lista
			if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _tl_x - _tl_width, 0, _tl_x, _text_h + _tl_ma_top + _tl_ma_down) {
				// Indico que estou tocando no tl
				mouse_in_tl = true
			}
		}
	}
	
	/// Animação de entrada/saída do fundo
	// Calcula o alvo desejado da animação
	var _tl_target_x = _tl_open ? (display_get_gui_width() + _tl_width) : display_get_gui_width();

	// Move suavemente até o alvo
	_tl_x = lerp(_tl_x, _tl_target_x, 0.2)
	
	
	/// Desenho dos elementos
	draw_set_alpha(1)
	// Desenha o botão de switch
	draw_rectangle_color(_tl_x - _tl_width - _tl_switch_width, _text_h / 2 - _tl_switch_height / 2 + _tl_ma_top, _tl_x - _tl_width - 1, _text_h / 2 + _tl_switch_height / 2 + _tl_ma_down, _tl_switch_col, _tl_switch_col, _tl_switch_col, _tl_switch_col, false)

	// Desenha a seta centralizada e girada
	draw_sprite_ext(spr_nets_switch, 0, _tl_x - _tl_width - _tl_switch_width / 2, _text_h / 2 + _tl_ma_top, .25, .25, _tl_arrow_rot, c_white, 1)
	
	
	/// Desenhando o fundo e o proprio texto
	draw_set_alpha(.9)
	
	draw_rectangle_color(_tl_x - _tl_width, 0, _tl_x, _text_h + _tl_ma_top + _tl_ma_down * 4, _tl_col, _tl_col, _tl_col, _tl_col, false)
	
	draw_set_alpha(.9)
	draw_set_font(fnt_nets_tl)
	draw_set_valign(-1)
	draw_set_halign(-1)
	
	//draw_text_ext_transformed(_tl_x - _tl_width + _tl_ma_lr, _tl_ma_top, _text, -1, _text_w, 1, 1, 0)
	//draw_text_scribble_ext(_tl_x - _tl_width + _tl_ma_lr, _tl_ma_top, _text, _text_w)
	//draw_text_scribble_ext(_tl_x - _tl_width + _tl_ma_lr, _tl_ma_top, "[wave][scale,1.4][fnt_db][c_red]Bem vindo, Acesse Sua Conta", _text_w)
	/// Desenhando o texto
	var _scribble_obj = scribble(_text)
		.wrap(_text_w, _text_h*2)
		//.line_spacing(string_height("I") * 1.2)

		//.draw(_guide_text_title_x, _yy, typist);
		.draw(_tl_x - _tl_width + _tl_ma_lr, _tl_ma_top);
	
	draw_set_alpha(1)
	#endregion
	
	/// Resetando a fonte, o alinhamento vertical e a cor
	draw_set_font(-1)
	draw_set_valign(-1)
	draw_set_color(-1)
	#endregion
	
	#region Inventory
	#region Set de variáveis
	// Altura do inventário
	static _inv_height = display_get_gui_height() * 0.15

	// Cor de fundo
	static _inv_col = make_color_rgb(150, 150, 150)
	// Cor de fundo do switch
	static _switch_col = c_dkgray

	// Posição atual do fundo (animado)
	static _inv_y = display_get_gui_height() + _inv_height

	// Margens do inventário
	static _inv_ma_top = 3
	static _inv_ma_down = 3
	static _inv_ma_lr = 4

	// Espaçamento entre itens
	static _inv_space = 3

	// Tamanho do botão de switch
	static _switch_width  = display_get_gui_width() * 0.07
	static _switch_height = _inv_height * 0.17

	// Velocidade da animação
	static _inv_speed = 20

	// Estado de visibilidade (mostrar ou esconder)
	static _inv_open = true

	// Ângulo da seta
	static _inv_arrow_rot = 180
	
	//
	static _inv_grid_co = ds_grid_width(grid_inventory)
	//
	static _inv_grid_width = display_get_gui_width() - _inv_ma_lr * 2
	//
	static _inv_grid_width_ele = _inv_grid_width / _inv_grid_co
	
	// Centro X do botão
	var _switch_x = display_get_gui_width() / 2 - _switch_width / 2
	// Pos y do botão
	var _switch_y = _inv_y - _inv_height - _switch_height
	#endregion
	
	//
	if !(global.pause or instance_exists(obj_tutorial)) {
		/// Acionando o botão do switch
		if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _switch_x, _switch_y, _switch_x + _switch_width, _switch_y + _switch_height)) or (item_in_mouse and !_inv_open) {
			// Indico que estou tocando no inv
			mouse_in_inv = true
		
			if ((mouse_check_button_pressed(mb_left)) or (item_in_mouse and !_inv_open)) and !is_array(link_1) {
				// Invertando o estado de visibilidade
			    _inv_open = !_inv_open

			    // Gira a seta em 180°
			    _inv_arrow_rot = (_inv_open ? 180 : 0)
			}
		}
		// Se o mouse NÃO está no botão
		else {
			// Indico que NÃO estou tocando no inv
			mouse_in_inv = false
		
			// Se o mouse está tocando no inv
			if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), 0, _inv_y - _inv_height, display_get_gui_width(), _inv_y) {
				// Indico que estou tocando no inv
				mouse_in_inv = true
			}
		}
	}

	/// Animação de entrada/saída do fundo
	// Calcula o alvo desejado da animação
	var _target_y = _inv_open ? (display_get_gui_height() + _inv_height) : display_get_gui_height()

	// Move suavemente até o alvo
	_inv_y = lerp(_inv_y, _target_y, 0.2)

	#region Desenho do switch e o fundo
	// Desenha o botão de switch
	draw_rectangle_color(_switch_x, _inv_y - _inv_height - _switch_height, _switch_x + _switch_width, _inv_y - _inv_height, _switch_col, _switch_col, _switch_col, _switch_col, false)

	// Desenha a seta centralizada e girada
	draw_sprite_ext(spr_nets_switch, 0, display_get_gui_width() / 2, _inv_y - _inv_height - (_switch_height / 2), .25, .25, _inv_arrow_rot, c_white, 1)

	// Fundo do inventário
	draw_rectangle_color(0, _inv_y - _inv_height, display_get_gui_width(), _inv_y, _inv_col, _inv_col, _inv_col, _inv_col, false)
	#endregion
	
	#region Desenha os itens do inventario e fazendo sua interação
	/// Passando por cada elemento da grid do inv
	for (var c = 0; c < _inv_grid_co; ++c) {
		var _x = _inv_ma_lr + c * _inv_grid_width_ele - 1
		
	    // Desenhando a outline do espaço de cada item do inv
		draw_rectangle(_x+1, _inv_y - _inv_height + _inv_ma_top, _x + _inv_grid_width_ele, _inv_y - _inv_ma_down, true)
		
		// Se esse espaço está preenchido
		if is_array(grid_inventory[# c, 0]) {
			// Desenho o icon desse item
			draw_sprite_stretched(grid_inventory[# c, 0][0], 0, _x+1, _inv_y - _inv_height + _inv_ma_top, _inv_grid_width_ele, _inv_height - _inv_ma_down * 2)
			
			// Desenho da quantidade
			draw_text_transformed(_x +_inv_grid_width_ele - _inv_ma_lr * 5, _inv_y - _inv_height + _inv_ma_top / 2, $"x{grid_inventory[# c, 0][1]}", 1, 1, 0)
			
			// Se pressionei num espaço de item
			if !(global.pause or instance_exists(obj_tutorial)) {
				if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _x+1, _inv_y - _inv_height + _inv_ma_top, _x+1 + _inv_grid_width_ele, _inv_y - _inv_height + _inv_ma_top + _inv_height - _inv_ma_down * 2) and mouse_check_button_pressed(mb_left) {
					// Passando o item pressionado para o mouse
					item_in_mouse = grid_inventory[# c, 0][0]
				}
			}
		}
	}
	#endregion
	
	// Se tenho um item no mouse
	if item_in_mouse {
		/// Tamanhos do item no mouse
		static _im_w = _inv_grid_width_ele * .6
		static _im_h = (_inv_height - _inv_ma_down * 2) * .6
		
		/// Desenho o item no mouse
		draw_set_alpha(.75)
		draw_sprite_stretched(item_in_mouse, 0, device_mouse_x_to_gui(0) - _im_w / 2, device_mouse_y_to_gui(0) - _im_h / 2, _im_w, _im_h)
		draw_set_alpha(1)
		
		// Se soltei o botão do mouse
		if !(global.pause or instance_exists(obj_tutorial)) {
			if mouse_check_button_released(mb_left) {
			#region Teste de conexão (rot, cel, pc, dec, tv, imp, mo, toC)
			/// Roteador
			if point_in_rectangle(mouse_x, mouse_y, 187, 115, 210, 133) {
				// wifi
				if item_in_mouse == spr_nets_icon_wifi {
					// Se a coneção 1 já foi feita
					if is_array(link_1) {
						// Se é a conexão certa
						if link_1[0] == spr_nets_icon_wifi and link_1[1] == "cel" {
							// Celular conectado ao wifi
							task_list_struct.cel = "c_green"
							
							//
							parts_on_wires[0][0] = true
							
							// Método se remover item do inv
							grid_remove_ele(spr_nets_icon_wifi)
							
							// Reseta a conexão
							link_1 = noone
							
							// Som de conexão
							play_sound_geral(snd_nets_plug1)
						}
						/// Se conectou errado, reseta a conexão
						else {
							link_1 = noone
						}
					}
					// Se agora é a conexão 1
					else {
						link_1 = [spr_nets_icon_wifi, "rot", 199, 129]
						
						// Som de conexão
						play_sound_geral(snd_nets_plug1)
					}
				}
				// par traçado
				else if item_in_mouse == spr_nets_icon_par_t and task_list_struct.rot == "c_green" {
					// Se a coneção 1 já foi feita
					if is_array(link_1) {
						// Se é a conexão certa
						if link_1[0] == spr_nets_icon_par_t and link_1[1] == "pc" {
							// PC conectado na internet
							task_list_struct.pc = "c_green"
							
							//
							parts_on_wires[6][0] = true
							
							// Método se remover item do inv
							grid_remove_ele(spr_nets_icon_par_t)
							
							// Reseta a conexão
							link_1 = noone
							
							// Som de conexão
							play_sound_geral(snd_nets_plug1)
						}
						/// Se conectou errado, reseta a conexão
						else {
							link_1 = noone
						}
					}
					// Se agora é a conexão 1
					else {
						link_1 = [spr_nets_icon_par_t, "rot", 199, 129]
						
						// Som de conexão
						play_sound_geral(snd_nets_plug1)
					}
				}
				else {
					link_1 = noone
					item_in_mouse = noone
				}
			}
			/// Pc
			else if point_in_rectangle(mouse_x, mouse_y, 240, 114, 256, 138) {
				// hdmi
				if item_in_mouse == spr_nets_icon_hdmi and !parts_on_wires[2][0] {
					// Se a coneção 1 já foi feita
					if is_array(link_1) {
						// Se é a conexão certa
						if link_1[0] == spr_nets_icon_hdmi and link_1[1] == "mo" {
							// Monitor ligado no pc
							task_list_struct.mo = "c_green"
							
							//
							parts_on_wires[2][0] = true
							
							// Método se remover item do inv
							grid_remove_ele(spr_nets_icon_hdmi)
							
							// Reseta a conexão
							link_1 = noone
							
							// Som de conexão
							play_sound_geral(snd_nets_plug1)
						}
						/// Se conectou errado, reseta a conexão
						else {
							link_1 = noone
						}
					}
					// Se agora é a conexão 1
					else {
						link_1 = [spr_nets_icon_hdmi, "pc", 248, 134]
						
						// Som de conexão
						play_sound_geral(snd_nets_plug1)
					}
				}
				// par traçado
				else if item_in_mouse == spr_nets_icon_par_t {
					// Se a coneção 1 já foi feita
					if is_array(link_1) {
						// Se é a conexão certa
						if link_1[0] == spr_nets_icon_par_t and link_1[1] == "rot" {
							// Pc conectado na internet
							task_list_struct.pc = "c_green"
							
							//
							parts_on_wires[6][0] = true
							
							// Método se remover item do inv
							grid_remove_ele(spr_nets_icon_par_t)
							
							// Reseta a conexão
							link_1 = noone
							
							// Som de conexão
							play_sound_geral(snd_nets_plug1)
						}
						// Reseta a conexão
						else {
							link_1 = noone
						}
					}
					// Se agora é a conexão 1
					else {
						link_1 = [spr_nets_icon_par_t, "pc", 248, 134]
						
						// Som de conexão
						play_sound_geral(snd_nets_plug1)
					}
				}
				// usb
				else if item_in_mouse == spr_nets_icon_usb {
					// Se a coneção 1 já foi feita
					if is_array(link_1) {
						// Se é a conexão certa
						if link_1[0] == spr_nets_icon_usb and link_1[1] == "imp" {
							// Impresora conectada no pc
							task_list_struct.imp = "c_green"
							
							//
							parts_on_wires[8][0] = true
							parts_on_wires[4][0] = true
							
							// Método se remover item do inv
							grid_remove_ele(spr_nets_icon_usb)
							
							// Reseta a conexão
							link_1 = noone
							
							// Som de conexão
							play_sound_geral(snd_nets_plug1)
						}
						/// Se conectou errado, reseta a conexão
						else {
							link_1 = noone
						}
					}
					// Se agora é a conexão 1
					else {
						link_1 = [spr_nets_icon_usb, "pc", 248, 134]
						
						// Som de conexão
						play_sound_geral(snd_nets_plug1)
					}
				}
				else {
					link_1 = noone
					item_in_mouse = noone
				}
			}
			/// Monitor
			else if point_in_rectangle(mouse_x, mouse_y, 273, 119, 291, 132) {
				// hdmi
				if item_in_mouse == spr_nets_icon_hdmi and !parts_on_wires[2][0] {
					// Se a coneção 1 já foi feita
					if is_array(link_1) {
						// Se é a conexão certa
						if link_1[0] == spr_nets_icon_hdmi and link_1[1] == "pc" {
							// Monitor conectado no pc
							task_list_struct.mo = "c_green"
							
							//
							parts_on_wires[2][0] = true
							
							// Método se remover item do inv
							grid_remove_ele(spr_nets_icon_hdmi)
							
							// Reseta a conexão
							link_1 = noone
							
							// Som de conexão
							play_sound_geral(snd_nets_plug1)
						}
						/// Se conectou errado, reseta a conexão
						else {
							link_1 = noone
						}
					}
					// Se agora é a conexão 1
					else {
						link_1 = [spr_nets_icon_hdmi, "mo", 282, 126]
						
						// Som de conexão
						play_sound_geral(snd_nets_plug1)
					}
				}
				else {
					link_1 = noone
					item_in_mouse = noone
				}
			}
			/// Impresora
			else if point_in_rectangle(mouse_x, mouse_y, 323, 155, 341, 172) {
				// usb
				if item_in_mouse == spr_nets_icon_usb {
					// Se a coneção 1 já foi feita
					if is_array(link_1) {
						// Se é a conexão certa
						if link_1[0] == spr_nets_icon_usb and link_1[1] == "pc" {
							//
							task_list_struct.imp = "c_green"
							
							//
							parts_on_wires[8][0] = true
							parts_on_wires[4][0] = true
							
							//
							grid_remove_ele(spr_nets_icon_usb)
							
							//
							link_1 = noone
							
							// Som de conexão
							play_sound_geral(snd_nets_plug1)
						}
						///
						else {
							link_1 = noone
						}
					}
					// Se agora é a conexão 1
					else {
						link_1 = [spr_nets_icon_usb, "imp", 330, 162]
						
						// Som de conexão
						play_sound_geral(snd_nets_plug1)
					}
				}
				else {
					link_1 = noone
					item_in_mouse = noone
				}
			}
			/// Celular 
			else if point_in_rectangle(mouse_x, mouse_y, 64, 192, 72, 202) {
				// wifi
				if item_in_mouse == spr_nets_icon_wifi {
					// Se a coneção 1 já foi feita
					if is_array(link_1) {
						// Se é a conexão certa
						if link_1[0] == spr_nets_icon_wifi and link_1[1] == "rot" {
							// Celular conectado ao wifi
							task_list_struct.cel = "c_green"
							
							//
							parts_on_wires[0][0] = true
							
							// Método se remover item do inv
							grid_remove_ele(spr_nets_icon_wifi)
							
							// Reseta a conexão
							link_1 = noone
							
							// Som de conexão
							play_sound_geral(snd_nets_plug1)
						}
						/// Se conectou errado, reseta a conexão
						else {
							link_1 = noone
						}
					}
					// Se agora é a conexão 1
					else {
						link_1 = [spr_nets_icon_wifi, "cel", 69, 197]
						
						// Som de conexão
						play_sound_geral(snd_nets_plug1)
					}
				}
				else {
					link_1 = noone
					item_in_mouse = noone
				}
			}
			/// TV
			else if point_in_rectangle(mouse_x, mouse_y, 76, 95, 152, 137) {
				// hdmi
				if item_in_mouse == spr_nets_icon_hdmi and !parts_on_wires[3][0] {
					// Se a coneção 1 já foi feita
					if is_array(link_1) {
						// Se é a conexão certa
						if link_1[0] == spr_nets_icon_hdmi and link_1[1] == "dec" {
							// Tv conectada no decodificador
							task_list_struct.tv_hdmi = true
							
							//
							parts_on_wires[3][0] = true
							
							// Método se remover item do inv
							grid_remove_ele(spr_nets_icon_hdmi)
							
							// Reseta a conexão
							link_1 = noone
							
							// Som de conexão
							play_sound_geral(snd_nets_plug1)
						}
						/// Se conectou errado, reseta a conexão
						else {
							link_1 = noone
						}
					}
					// Se agora é a conexão 1
					else {
						link_1 = [spr_nets_icon_hdmi, "tv", 114, 116]
						
						// Som de conexão
						play_sound_geral(snd_nets_plug1)
					}
				}
				else {
					link_1 = noone
					item_in_mouse = noone
				}
			}
			/// Codificador
			else if point_in_rectangle(mouse_x, mouse_y, 81, 145, 106, 151) {
				// hdmi
				if item_in_mouse == spr_nets_icon_hdmi and !parts_on_wires[3][0] {
					// Se a coneção 1 já foi feita
					if is_array(link_1) {
						// Se é a conexão certa
						if link_1[0] == spr_nets_icon_hdmi and link_1[1] == "tv" {
							// Tv conectado no decodificador
							task_list_struct.tv_hdmi = true
							
							//
							parts_on_wires[3][0] = true
							
							//
							grid_remove_ele(spr_nets_icon_hdmi)
							
							//
							link_1 = noone
							
							// Som de conexão
							play_sound_geral(snd_nets_plug1)
						}
						/// Se conectou errado, reseta a conexão
						else {
							link_1 = noone
						}
					}
					// Se agora é a conexão 1
					else {
						link_1 = [spr_nets_icon_hdmi, "dec", 94, 148]
						
						// Som de conexão
						play_sound_geral(snd_nets_plug1)
					}
				}
				// coaxial
				else if item_in_mouse == spr_nets_icon_coaxial {
					// Se a coneção 1 já foi feita
					if is_array(link_1) {
						// Se é a conexão certa
						if link_1[0] == spr_nets_icon_coaxial and link_1[1] == "toC" {
							// Codificador conectado na tomada coaxial
							task_list_struct.tv_coaxial = true
							
							//
							parts_on_wires[1][0] = true
							
							// Método se remover item do inv
							grid_remove_ele(spr_nets_icon_coaxial)
							
							// Reseta a conexão
							link_1 = noone
							
							// Som de conexão
							play_sound_geral(snd_nets_plug1)
						}
						/// Se conectou errado, reseta a conexão
						else {
							link_1 = noone
						}
					}
					// Se agora é a conexão 1
					else {
						link_1 = [spr_nets_icon_coaxial, "dec", 94, 148]
						
						// Som de conexão
						play_sound_geral(snd_nets_plug1)
					}
				}
				else {
					link_1 = noone
					item_in_mouse = noone
				}
			}
			/// Tomada Coaxial
			else if point_in_rectangle(mouse_x, mouse_y, 66, 151, 70, 157) {
				// coaxial
				if item_in_mouse == spr_nets_icon_coaxial {
					// Se a coneção 1 já foi feita
					if is_array(link_1) {
						// Se é a conexão certa
						if link_1[0] == spr_nets_icon_coaxial and link_1[1] == "dec" {
							// Decodificador conectado na tomada coaxial
							task_list_struct.tv_coaxial = true
							
							//
							parts_on_wires[1][0] = true
							
							// Método se remover item do inv
							grid_remove_ele(spr_nets_icon_coaxial)
							
							// Reseta a conexão
							link_1 = noone
							
							// Som de conexão
							play_sound_geral(snd_nets_plug1)
						}
						/// Se conectou errado, reseta a conexão
						else {
							link_1 = noone
						}
					}
					// Se agora é a conexão 1
					else {
						link_1 = [spr_nets_icon_coaxial, "toC", 68, 154]
						
						// Som de conexão
						play_sound_geral(snd_nets_plug1)
					}
				}
				else {
					link_1 = noone
					item_in_mouse = noone
				}
			}
			/// Se soltou o botão fora de qualquer meio de conexão, reseto a conexão 1
			else {
				link_1 = noone
			}
			#endregion
			
			if (item_in_mouse == noone or !is_array(link_1)) and !audio_is_playing(snd_nets_plug1) {
				///
				screenshake(5)
				play_sound_geral(snd_nets_error)
				play_sound_geral(snd_nets_error)
				
				link_1 = noone
				item_in_mouse = noone
			}
			
			
			// Se não tem nada na conexão 1
			if !is_array(link_1) {
				// Removo o item do mouse
				item_in_mouse = noone
				
				/// Testa se a tv está completamente conectada
				if task_list_struct.tv_coaxial and task_list_struct.tv_hdmi {
					task_list_struct.tv = "c_green"
					//
					parts_on_wires[7][0] = true
				}
				
				/// Testa se o pc está completamente conectada
				if task_list_struct.mo == "c_green" and task_list_struct.pc == "c_green" {
					//
					parts_on_wires[5][0] = true
				}
			}
		}
		}
	}
	#endregion
}

// Recebe uma sprite e uma grid, ela busca por essa sprite dentre os elementos da grid e se achar como primeiro valor do array, diminui sua quantidade que é o segundo valor do array
grid_remove_ele = function(sprite_buscada, grid=grid_inventory) {
    // Pega o tamanho da grid
    var cols = ds_grid_width(grid)
    var rows = ds_grid_height(grid)

    // Percorre cada célula da grid
    for (var i = 0; i < cols; i++) {
        for (var j = 0; j < rows; j++) {
            // Cada elemento da grid (array) testado
            var cell = grid[# i, j]
            
            // Verifica se a célula é um array válido
            if (is_array(cell) && array_length(cell) >= 2) {
                var cell_sprite = cell[0]
                var cell_quant = cell[1]

                // Compara a sprite
                if (cell_sprite == sprite_buscada) {
                    // Reduz quantidade
                    cell_quant -= 1

                    /// Se a quantidade zerar, limpa a célula
                    if (cell_quant <= 0) {
                        grid[# i, j] = noone
                    }
					/// Se NÃO zerar, atualiza essa célula
					else {
                        grid[# i, j] = [cell_sprite, cell_quant]
                    }

                    // Já encontrou e alterou, pode retornar
                    return
                }
            }
        }
    }
}

// Cria uma animação estilo zelda botw que mostra o item pego com sua descrição
gui_get_item = function(_item_spr, _item_ti, _item_desc) {
	#region Set de variaveis
	/// Calcula o tamanho do espaço e o posicionamento dessa caixa
	static _gui_porc = .5
	static _gui_w = room_width * _gui_porc
	static _gui_h = (room_height * _gui_porc) / 1.5
	static _gui_x = room_width / 2 - _gui_w / 2
	static _gui_y = room_height * .4 - _gui_h / 2
	
	// Transparencia inicial dos item para a animação deles aparecendo
	static _alpha = 0
	
	/// Infos do icone do item
	static _item_posx = _gui_x + _gui_w * .15
	static _item_posy = _gui_y + _gui_h / 2
	static _item_pos_size = _gui_h * .5
	
	// Divisão entre o icone e suas strings
	static _div_x = _item_posx + _item_pos_size * 1
	
	// Guarda o sistema de particula usado
	static _part_sys = noone
	
	
	///
	
	
	// Largura que o texto deve ocupar
	static _text_w = _gui_w * 2.5
	
	///
	static _ti_y = _gui_y + _gui_h * .13
	static _desc_y = _ti_y + _gui_h * .2
	#endregion
	
	
	/// Se é o começo da animação, crio o sistema de particulas
	if _alpha == 0 {
		//
		_part_sys = part_system_create(ps_nets_light)
	}
	
	// Vou aumentando o alpha até 100%
	_alpha = clamp((_alpha + .02), 0, 1)
	
	#region Desenho dos elementos
	// Alpha dos itens
	draw_set_alpha(_alpha)
	// Fundo
	draw_sprite_stretched(spr_nets_box, 0, _gui_x, _gui_y, _gui_w, _gui_h)
	// Icone
	draw_sprite_stretched(_item_spr, 0, _item_posx - _item_pos_size / 2, _item_posy - _item_pos_size / 2 - _gui_h * .03, _item_pos_size, _item_pos_size)
	
	//
	draw_text_get_gui = [_div_x, _ti_y, _desc_y, _item_ti, _item_desc, _text_w, _alpha]
	
	// Reseta o alpha
	draw_set_alpha(1)
	#endregion
	
	
	
	/// Espera um tempo para desenha o brilho no item
	part_system_position(_part_sys, -100, -100)
	if _alpha > .1 {
		part_system_position(_part_sys, _item_posx, _item_posy)
	}
	
	
	///
	if mouse_check_button_released(mb_left) and _alpha > .6 and !(global.pause or instance_exists(obj_tutorial)) {
		//
		io_clear()
		//
		trigger_get_item = false
		//
		draw_text_get_gui = [0, 0, 0, "", "", 0, 0]
		//
		_alpha = 0
		
		///
		part_system_clear(_part_sys)
		part_system_destroy(_part_sys)
	}
}
