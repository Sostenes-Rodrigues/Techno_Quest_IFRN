/// Draw



#region Desenha o background da tela do programa de desenho
var _col1 = c_gray
var _col2 = c_dkgray
/// Quantidade de colunas e linhas
var _q_c = 28
var _q_l = (_q_c * (surf_w * 1.7 / room_width))

for (var c = 0; c < _q_c; c++) {
    for (var l = 0; l < _q_l; l++) {
		// Cor desse quadrado
        var col = ((c % 2 == l % 2) ? _col1 : _col2)
		
		var _m = 0
		if c == _q_c - 1 {
			_m = 2
		}
		
		/// Desenha cada quadrado
		draw_set_alpha(0.98)
        draw_rectangle_color(paint_area_x + surf_w / _q_c * c, surf_h / _q_l * l, paint_area_x + surf_w / _q_c * c + surf_w / _q_c - _m, surf_h / _q_l * l + surf_h / _q_l, col, col, col, col, false)
		draw_set_alpha(1)
    }
}
#endregion

/// Desenha a surface principal se existir
if surface_exists(surf_painting) {
    draw_surface(surf_painting, paint_area_x, 0)
}


/// Desenha a surface overlay se existir (extra: not use)
if surface_exists(surf_overlay) {
    draw_surface(surf_overlay, paint_area_x, 0)
}

// Se o display de salvar o site não está ativa
if !gui_save_img and !(global.pause or instance_exists(obj_tutorial)) {
	// Se a ferramenta ativa for inserir img
	if paint_tool == 3 {
		// Se o mouse está na area de pintura
		if mouse_in_paint and !paint_img_set and use_feramentas {
			/// Desenha a img
			var _img_w = sprite_get_width(img)
			var _img_h = sprite_get_height(img)
			var _draw_img_w = surf_w * .4
			var _draw_img_h = _draw_img_w * (_img_h / _img_w)
			draw_sprite_stretched(img, 0, mouse_x - _draw_img_w / 2, mouse_y - _draw_img_h / 2, _draw_img_w, _draw_img_h)
		
			/// Se soltei o botão esquerdo do mouse, ativo a flag da img
			if mouse_check_button_released(mb_left) {
				paint_img = true
			}
		}
	}
	// Se a ferramenta ativa for inserir título
	else if paint_tool == 4 {
		// Se o mouse está na area de pintura
		if mouse_in_paint and !ti_set and use_feramentas {
			/// Set da fonte e origem horizontal
			draw_set_font(fnt_web)
			draw_set_halign(fa_center)
			draw_set_color(c_black)
		
			// Desenha o texto
			draw_text_ext_transformed(mouse_x, mouse_y, ti_text, -1, surf_w * 0.7, 1.4, 1.4, 0)
		
			/// Reset da fonte e origem horizontal
			draw_set_font(-1)
			draw_set_halign(-1)
			draw_set_color(-1)
		
			/// Se soltei o botão esquerdo do mouse, ativo a flag do ti
			if mouse_check_button_released(mb_left) {
				ti = true
			}
		}
	}
	// Se a ferramenta ativa for inserir paragrafo
	else if paint_tool == 5 {
	// Se o mouse está na area de pintura
	if mouse_in_paint and !pa_set and use_feramentas {
		/// Set da fonte e origem horizontal
		draw_set_font(fnt_web)
		draw_set_halign(fa_center)
		draw_set_color(c_black)
		
		// Desenha o texto
		draw_text_ext_transformed(mouse_x, mouse_y, pa_text, -1, surf_w * 0.6, .8, .8, 0)
		
		/// Reset da fonte e origem horizontal
		draw_set_font(-1)
		draw_set_halign(-1)
		draw_set_color(-1)
		
		/// Se soltei o botão esquerdo do mouse, ativo a flag do pa
		if mouse_check_button_released(mb_left) {
			pa = true
		}
	}
}
}


// Parte da esquerda ()
draw_left()

// Parte da direita (Seletor de ferramenta e Color Picker)
draw_ring()
