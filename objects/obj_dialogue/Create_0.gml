dialogo = noone

// Quantidade de caracteres atual do texto
indice  = 1

// 
pag		= 0

escala_caixa = 0

libera_player = function() {
	if player {
		player.in_dialogue = false
	}
	
	instance_destroy(id)
}

// Metodo para criar o dialogo
cria_dialogo = function(_dialogo) {
	/// Variaveis estaticas dos tamanhos da tela do jogo
	static _gui_w   = display_get_gui_width()
	static _gui_h   = display_get_gui_height()
	static _spr_d   = sprite_get_width(spr_dialogue_box)
				    
	// Convertendo  a escala da caixa de texto em pixel
	var _escala_x   = (_gui_w / _spr_d) * escala_caixa
	var _escala_y   = (_gui_h * .3) / _spr_d // 30% da tela
	
	// Aumenyando a escala da caixa
	escala_caixa = lerp(escala_caixa, 1, .05)
	
	draw_set_color(c_white)
	draw_set_halign(-1)
	draw_set_valign(-1)
	draw_set_font(fnt_dialogue)
	var _txt	    = _dialogo.texto[pag]
	var _txt_atual  = string_copy(_txt, 1, indice)
	var _txt_tam    = string_length(_txt)
	var _txt_vel    = _dialogo.txt_vel
	var _yy		    = _gui_h - (_escala_y * _spr_d)
	var _margem     = string_height("I")
	var _qtd_pag	= array_length(_dialogo.texto) - 1
	
	var _retrato    = _dialogo.retrato[pag]
	var _ret_escala = (_gui_h * .2) / sprite_get_height(_retrato)
	var _ret_y		= _yy + (sprite_get_height(_retrato) / 1) //4
	var _ret_larg	= _ret_escala * sprite_get_height(_retrato)
	
	
	// Caixa de texto
	draw_sprite_ext(spr_dialogue_box, 0, 0, _yy, _escala_x, _escala_y, 0, c_white, 1)
	
	if (escala_caixa > .99) escala_caixa = 1;
	
	/// Só faço o resto se minha caixa de dialogo carregou
	if !(escala_caixa >= 1) {
		exit
	}
	
	if (keyboard_check_pressed(vk_anykey) or mouse_check_button_pressed(mb_any)) and (!keyboard_check_pressed(vk_escape) and !global.pause) {
		/// Pulando a espera de escrever o texto
		if indice < _txt_tam {
			indice = _txt_tam
		}
		/// Passando de pag
		else if pag < _qtd_pag {
			pag ++
		
			indice = 0
		}
		
		/// Já foi mostrado tudo
		else {
			libera_player()
		}
	}
	
	/// Aumentando o indice
	if indice <= _txt_tam and !global.pause {
		indice += _txt_vel
	}
		
	
	// Retrato
	//draw_sprite_ext(_retrato, 0, _margem, _ret_y, _ret_escala, _ret_escala, 0, c_white, 1)
	draw_sprite_stretched_ext(_retrato, 0, _margem, _ret_y, sprite_get_width(_retrato) * _ret_escala, sprite_get_height(_retrato) * _ret_escala, c_white, 1)
	
	// Texto
	draw_text_ext(_margem * 2 + _ret_larg, _yy + _margem, _txt_atual, _margem, _gui_w - _margem * 2 - _ret_larg)
	draw_set_halign(-1)
	draw_set_valign(-1)
	draw_set_font(-1)
}


///
if instance_exists(obj_pause) {
	obj_pause.can_pause = false	
}
