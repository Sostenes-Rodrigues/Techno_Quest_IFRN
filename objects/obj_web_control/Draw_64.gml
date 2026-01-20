/// Draw GUI


// Se a ferramenta ativa for conta gotas
if paint_tool == 2 and !gui_save_img {
	if mouse_check_button_released(mb_left) and mouse_in_paint {
		// Redireciona pra surface temporariamente
		var mx = mouse_x - paint_area_x
		var my = mouse_y;
		
		var _cor_get = 0
		if surface_exists(surf_painting) {
		    var _cor_get = surface_getpixel_ext(surf_painting, mx, my);
		}

		
		if ((_cor_get >> 24) & 255) == 255 {	// Alpha
			var _b = ((_cor_get >> 16) & 255)   // Blue
			var _g = ((_cor_get >> 8) & 255)    // Gree
			var _r = (_cor_get & 255)			// Red
				
			instance_destroy(curt.cp);
			curt.cp = noone;
		
			curt.co = make_color_rgb(_r, _g, _b)
		}
	}
}

/// Desenha a posição do mouse com um contorno colorido
if mouse_in_paint and (paint_tool == 0 or paint_tool == 1) and !gui_save_img and !(global.pause or instance_exists(obj_tutorial)) {
	draw_circle_color(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), paint_width, curt.co, curt.co, true)
}

// Se o mouse está na area de pintura
if mouse_in_paint and !gui_save_img and !(global.pause or instance_exists(obj_tutorial)) {
	// Deixo o cursor do OS sem sprite
	window_set_cursor(cr_none)
	
	var _mx = device_mouse_x_to_gui(0)
	var _my = device_mouse_y_to_gui(0)
	
	/// Desenho o icon do botão acionado no lugar do cursor
	if paint_tool == 0 {
		draw_sprite_stretched(spr_web_tool_pencil, 0, _mx, _my - 14, 16, 16)
	}
	else if paint_tool == 1 {
		draw_sprite_stretched(spr_web_tool_eraser, 0, _mx - 5, _my - 6, 16, 16)
	}
	else if paint_tool == 2 {
		draw_sprite_stretched(spr_web_tool_eyedropper, 0, _mx, _my - 14, 16, 16)
	}
	else if paint_tool == 3 and (paint_img_set or !use_feramentas) {
		draw_sprite_stretched(spr_web_tool_image, 0, _mx - 8, _my - 8, 16, 16)
	}
	else if paint_tool == 4 and (ti_set or !use_feramentas) {
		draw_sprite_stretched(spr_web_tool_h1, 0, _mx - 8, _my - 8, 16, 16)
	}
	else if paint_tool == 5 and (pa_set or !use_feramentas) {
		draw_sprite_stretched(spr_web_tool_p, 0, _mx - 8, _my - 8, 16, 16)
	}

}
// Se o mouse NÃO está na area de pintura
else {
	// Deixo o cursor do OS visivel
	window_set_cursor(cr_default)
}

// Se é para desenhar o input do save img
if gui_save_img {
	// Desenha o input
	area_save_img()
}

