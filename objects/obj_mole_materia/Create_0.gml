/// Compõem os Protons, Nêutrons e Elétrons		// "proton", "neutron" e "eletron" //
tipo = "proton"
// Para saber se é um elemento, átomo ou molécula
//sub_tipo = "elemento"

// Se foi marcada por está dentro da area testada
death = false

// Texto do estado atual
estado_txt = ""

///  Variaveis para salvar a distancia entre o obj e o mouse
x_save = 0
y_save = 0

/// Metodos dos estados (Metodos são funções locais, ou seja só existem dentro do objeto de criação)
// Estado quando o obj estiver solto na room
estado_solto = function() {
	/// Se é a primeira vez que entro nesse estado
	if estado_txt != "solto" {
		estado_txt = "solto"
		
		// Indicando que posso segurar uma materia
		obj_mole_control.mouse_seg = false
	}
	
	
	// Se pode rodar
	if !(global.pause or instance_exists(obj_tutorial)) {
		/// Teste do mouse e mouse por cima
		var _click = mouse_check_button_pressed(mb_left)
		var _mouse_sobre = collision_point(mouse_x, mouse_y, id, false, false)
		
		/// Se clikei no obj
		if _click {
			// Se o mouse tocou em mim e se o player pode segurar alguém
			if _mouse_sobre and !obj_mole_control.mouse_seg {
				// Indicando que NÃO posso segurar uma materia
				obj_mole_control.mouse_seg = true
			
				// Definindo o novo estado
				estado = estado_segurado
		
				/// Salvando a distancia entre o obj e o mouse
				x_save = x - mouse_x
				y_save = y - mouse_y
			}
		}
	}
}

// Estado quando o obj estiver sendo segurado pelo mouse
estado_segurado = function() {
	/// Se é a primeira vez que entro nesse estado
	if estado_txt != "segurado" {
		estado_txt = "segurado"
		
		// Som indicando que fui segurado
		play_sound_geral(snd_mole_seg)
	}
	
	
	// Se pode rodar
	if !(global.pause or instance_exists(obj_tutorial)) {
		/// Atualiza a posição do objeto para seguir o mouse no ponto que foi segurado
	    x = mouse_x + x_save
	    y = mouse_y + y_save
	
		/// Fazendo com que o player não possa arrastar-lo para fora do espaço definido
		var _control = obj_mole_control
		x = clamp(x, 104, room_width * _control.div_tela)
		y = clamp(y, 51, room_height)

		// Se soltei o botão esquerdo do mouse
		if mouse_check_button_released(mb_left) {
			// Volto a ficar no estado solto
			estado = estado_solto
		}
	}
}

// Estado padrão
estado = estado_solto
