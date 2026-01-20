// Definindo a imagem da sprite que vou usar
image_index = irandom(sprite_get_number(sprite_index) - 1)

///
image_xscale = .5
image_yscale = .5

// Texto do estado atual
estado_txt = ""

// Tipo
tipo = ""

// O quanto cada lixo polui por intervalo
quant_polui = 5

/// Timer para o lixo gerar poluição
timer_poluir_restart = 1 * game_get_speed(gamespeed_fps)
timer_poluir = 0

/// Distorção da sprite no efeito de splash
splash_xscale = 2
splash_yscale = 0.6

// Porcentagem que o efeito do splash vai alterrando a escala a cada frame
splash_amt = .25

///  Variaveis para salvar a distancia entre o lixo e o mouse
x_save = 0
y_save = 0

/// Metodos dos estados (Metodos são funções locais, ou seja só existem dentro do objeto de criação)
estado_solto = function() {
	/// Se é a primeira vez que entro nesse estado
	if estado_txt != "solto" {
		estado_txt = "solto"
		
		// Reseta o timer de poluir
		timer_poluir = timer_poluir_restart
		
		// Profundida padrão
		depth = 100
	}
	
	// Vai passando o tempo do timer
	timer_poluir --
	
	/// Se o obj controle existe
	var _control = obj_desc_controle
	if instance_exists(_control) {
		// Se acabou o tempo
		if timer_poluir < 1 {
			// Se for o lixo radioativo
			if tipo == "radioativo" {
				// Me explodo
				instance_destroy(id)
				
				// Pulo o resto do código
				exit
			}
			
			// Reseta o timer de poluir
			timer_poluir = timer_poluir_restart
		
			// Aumenta a poluição
			_control.poluicao += quant_polui

			// Som do lixo poluindo
			audio_play_sound(snd_desc_smoke, 10, false, .5, 0.17)
			
			/// Efeito de splash
			image_xscale = splash_xscale
			image_yscale = splash_yscale
			
			/// Criando a particula de poluição
			// Setando a posição do emitter
			part_emitter_region(_control.part_sys, _control.part_em, x - 20,  x + 20, y - 5, y + 5, ps_shape_rectangle, ps_distr_gaussian)
	
			// Fazendo o emitter criar uma particula
			part_emitter_burst(_control.part_sys, _control.part_em, _control.particle, 10)
		}
	
		/// Se clikei no lixo
		if mouse_check_button_pressed(mb_left) and !(global.pause) {
			
			// Se posso segurar um lixo
			if _control.segurando {
				if collision_point(mouse_x, mouse_y, id, 0, false) {
					// Definindo o novo estado
					estado = estado_segurado
					
					// Não posso segurar outro lixo
					_control.segurando = false
		
					/// Salvando a distancia entre o obj e o mouse
					x_save = x - mouse_x
					y_save = y - mouse_y
				}
			}
		}
	}
}

estado_segurado = function() {
	/// Se é a primeira vez que entro nesse estado
	if estado_txt != "segurado" {
		estado_txt = "segurado"
		
		
		// Fazendo o lixo que estou segurando sempre ficar em cima dos outros
		depth = 99
	}
	
	/// Atualiza a posição do objeto para seguir o mouse no ponto que foi segurado
	var _x_dir = mouse_x + x_save
	var _y_dir = mouse_y + y_save
    x = _x_dir
    y = _y_dir
	
	/// Fazendo com que o player não possa arrastar o lixo para fora da room
	x = clamp(x, 0, room_width)
	y = clamp(y, 0, room_height)
	
	// Se soltei o botão esquerdo do mouse
	if mouse_check_button_released(mb_left) and !(global.pause) {
		// Volto a ficar solto
		estado = estado_solto
		
		// Se o obj controle existe
		if instance_exists(obj_desc_controle) {
			// Posso segurar outro lixo
			obj_desc_controle.segurando = true
		}
	}
}

// Estado padrão
estado = estado_solto
