/// Digo ao pause que ele não pode pausar
if instance_exists(obj_pause) {
	obj_pause.can_pause = false
}

/// Variaveis de objeto
tutorial_imgs = [spr_web_tutorial1, spr_web_tutorial2, spr_web_tutorial3]
tutorial_string = ["Lorem ipsum dolor sit amet consectetur adipiscing elit. Amet consectetur adipiscing elit quisque faucibus ex sapien. Quisque faucibus ex sapien vitae pellentesque sem placerat. Vitae pellentesque sem placerat in id cursus mi.",
"Lorem ipsum dolor sit amet consectetur adipiscing elit. Sit amet consectetur adipiscing elit quisque faucibus ex. Adipiscing elit quisque faucibus ex sapien vitae pellentesque.",
"Lorem ipsum dolor sit amet consectetur adipiscing elit. Consectetur adipiscing elit quisque faucibus ex sapien vitae. Ex sapien vitae pellentesque sem placerat in id. Placerat in id cursus mi pretium tellus duis. Pretium tellus duis convallis tempus leo eu aenean."]
tutorial_length = array_length(tutorial_imgs) - 1

//
img_cont_subimg = 0

tu_alp = 0
tu_alp_acel = 0

// Método da UI do tutorial
tutorial_ui = function() {
	#region Variaveis
    /// Variaveis staticas
    static _tutorial_index = 0
    static _tutorial_offset = 0
    static _tutorial_speed = 0.12
    
    /// Tamanho da UI
    var _w = display_get_gui_width()
    var _h = display_get_gui_height()
    var _box_w = _w * 0.65
    var _box_h = _h * 0.85
    var _box_x = (_w - _box_w) / 2
    var _box_y = (_h - _box_h) / 2
	
	/// Tela do desenho
	var _img_w = _box_w * 0.75
	var _img_h = _img_w * (9 / 16)
	var _img_x = (_w - _img_w) / 2
    var _img_y = _box_y + _box_h * 0.1
    #endregion
	
	/// Caixa de fundo
    draw_set_color(c_dkgray)
    draw_roundrect(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h, false)
	
	#region IMGs Carrosel
    /// Atualização de posição (suavidade)
    var _target = _tutorial_index * _img_w
    _tutorial_offset = lerp(_tutorial_offset, _target, _tutorial_speed)
	if point_distance(_tutorial_offset, 0, _target, 0) < 2 {
		_tutorial_offset = _target
	}
    
    /// Área de recorte (não deixa sprite vazar)
	var _scissor = gpu_get_scissor()
	var _sci_w = window_get_width() * 0.489
	var _sci_h = _sci_w
	var _sci_x = (window_get_width() - _sci_w) / 2
    var _sci_y = window_get_height() * .1
    gpu_set_scissor(_sci_x, _sci_y, _sci_w, _sci_h)
    
	///
	// 60 FPS
	var frames_por_subimg = 25

	// Incrementa o contador
	img_cont_subimg++

	// Calcula o total de subimagens
	var _total_subimgs = sprite_get_number(spr_web_tutorial1)

	// Reinicia o contador quando atingir o ciclo completo
	if (img_cont_subimg >= frames_por_subimg * _total_subimgs) img_cont_subimg = 0;

	// Calcula a subimagem atual
	var _subimg = floor(img_cont_subimg / frames_por_subimg)
	
    /// Desenhar sprites do tutorial
    for (var i = 0; i < array_length(tutorial_imgs); i++) {
        var _spr = tutorial_imgs[i]
        var _xx = _img_x + (i * _img_w) - _tutorial_offset
        var _yy = _img_y
        
        draw_sprite_stretched(_spr, _subimg, _xx, _yy, _img_w, _img_h)
    }
    
    // Desativa scissor
    gpu_set_scissor(_scissor);
    #endregion
	
	#region Texto
	/// Posição do texto
	var _txt_x = display_get_gui_width() / 2
	var _txt_y = _img_y + _img_h + _box_h * 0.05
	
	/// Sets para o texto
	draw_set_font(fnt_tutorial)
	draw_set_halign(fa_middle)
	draw_set_valign(fa_top)
	
	/// Escrevendo o texto (ver se bota o scribbe)
	draw_set_color(c_black)
	draw_text_ext_transformed(_txt_x + 2, _txt_y + 2, tutorial_string[_tutorial_index], -1, _box_w * .95, 1, 1, 0)
	draw_set_color(c_white)
	draw_text_ext_transformed(_txt_x, _txt_y, tutorial_string[_tutorial_index], -1, _box_w * .95, 1, 1, 0)
	#endregion
	
    #region Botões de navegação
	/// Posição do mouse na gui
    var _mx = device_mouse_x_to_gui(0)
    var _my = device_mouse_y_to_gui(0)
    
	/// Tamanho do botão
    var _btn_w = _box_w * 0.05
    var _btn_h = _box_h * 0.1
	// Margem dele entre a borda
    var _btn_mar = (_box_w / 2 - _img_w / 2) / 2 - _btn_w / 2
    
	/// Posições
    var _left_x = _box_x + _btn_mar
    var _left_y = _img_y + (_img_h - _btn_h) / 2
    var _right_x = _box_x + _box_w - _btn_w - _btn_mar
    var _right_y = _left_y
	
	// Para o "<>" (quando for sprite, tirar isso)
	draw_set_valign(fa_middle)
    
    /// Esquerda
	if !(_tutorial_index <= 0) {
	    /// Check do mouse
		var _check_btnl = point_in_rectangle(_mx, _my, _left_x, _left_y, _left_x + _btn_w, _left_y + _btn_h)
	    if _check_btnl {
	        if mouse_check_button_pressed(mb_left) {
				// Passa para a esquerda
	            _tutorial_index = max(0, _tutorial_index - 1)
	        }
	    }
		
		/// Desenho do botão
		draw_set_alpha((1 - .2 * _check_btnl) * tu_alp)
		draw_set_color(c_navy)
	    draw_rectangle(_left_x, _left_y, _left_x + _btn_w, _left_y + _btn_h, false)
	    draw_set_color(c_yellow)
	    draw_text(_left_x + _btn_w/2, _left_y + _btn_h/2, "<")
		draw_set_alpha(1)
	}
    
    #region Direita
	/// Sets dependendo se é o ultimo slide
	var _last_slide = false
	draw_set_color(c_navy)
	if (_tutorial_index >= tutorial_length) {
		_last_slide = true
		
	    draw_set_color(c_green)
	}
	
	/// Check do mouse
	var _check_btnr = point_in_rectangle(_mx, _my, _right_x, _right_y, _right_x + _btn_w, _right_y + _btn_h)
	if _check_btnr {
	    if mouse_check_button_pressed(mb_left) {
			if _last_slide {
				///
				_tutorial_index = 0
				_tutorial_offset = 0
				
				instance_destroy(id)
				
				if instance_exists(obj_pause) {
					obj_pause.can_pause = true
				}
			}
			else {
				_tutorial_index = min(tutorial_length, _tutorial_index + 1)
			}
	    }
	}
	
	/// Desenho do botão
	draw_set_alpha((1 - .2 * _check_btnr) * tu_alp)
	draw_rectangle(_right_x, _right_y, _right_x + _btn_w, _right_y + _btn_h, false)
	draw_set_color(c_yellow)
	draw_text(_right_x + _btn_w/2, _right_y + _btn_h/2, ">")
	draw_set_alpha(1)
	#endregion
	#endregion
}
