/// Step


#region Sistema de Proteção de Surface
// Se o jogo está em foco
if window_has_focus() == true {
	if focus == "waiting" {
		focus = "return"
		
		restore_surfaces()
	}
}
// Se o jogo NÃO está em foco
else if window_has_focus() == false {
    if focus == "default" {
		focus = "exit"
	}
}

/// Restaura a surface
if focus == "return" {
    alarm[0] = 9
	
	focus = "default"
}

/// Faz backup
else if focus == "exit" {
    backup_surfaces()
	
	focus = "waiting"
}
#endregion

// Se o display de salvar o site está ativa
if gui_save_img {
	exit
}

// Posição do mouse usado nas partes da surface, já que ela está deslocada do inicio da tela
var _mouse_x_surf = mouse_x - paint_area_x

// Para saber se o mouse está na area de pintura
mouse_in_paint = point_in_rectangle(mouse_x, mouse_y, paint_area_x, 0, paint_area_x + surf_w - 2, room_height)

// Se o mouse está na area de pintura
if mouse_in_paint {
	#region Ações dos inputs referente a mecânica de paint
	#region Inputs do mouse
	// Verifica se o botão esquerdo foi pressionado
	if mouse_check_button_pressed(mb_left) {
	    /// Armazena a posição inicial do mouse ao clicar
	    m_previous_x = _mouse_x_surf
	    m_previous_y = mouse_y
		
		// Pega o "nome" da cor atual
		get_color_pencil()
	}

	// Verifica se o botão esquerdo do mouse está sendo pressionado
	if mouse_check_button(mb_left) and use_feramentas {
	    // Ativa a flag de pintura
	    paint_active = true
	}
	// Caso contrário, se antes estava pintando
	else if paint_active {
	    // Desativa a flag de pintura
	    paint_active = false
	}

	/// Troca de cor com o scroll do mouse
	// Verifica se o scroll foi movido para cima
	if mouse_wheel_up() {
		// Aumenta a largura do pincel
	    paint_width += 0.6
	    /// Limita o valor máximo
	    if paint_width > paint_width_max {
	        paint_width = paint_width_max
	    }
	}
	// Verifica se o scroll foi movido para baixo
	else if mouse_wheel_down() {
		// Diminui a largura do pincel
	    paint_width -= 0.6
	    /// Limita o valor mínimo
	    if paint_width < paint_width_min {
	        paint_width = paint_width_min
	    }
	}
	#endregion

	#region Inputs do teclado
	// Verifica se a tecla ENTER foi pressionada
	if keyboard_check_pressed(vk_enter) {
	    // Verifica se a surface existe antes de salvar
	    if surface_exists(surf_painting) {
	        // Salva a surface com nome único (timer * fps)
	        surface_save(surf_painting, "painting_" + string(get_timer()*fps_real) + ".png")
	    }
	}
	// Verifica se a tecla ENTER foi pressionada
	if keyboard_check_pressed(vk_home) {
	    // Verifica se as duas surfaces existem
		if surface_exists(surf_painting) && surface_exists(surf_overlay) {

		    // Cria uma surface temporária com o mesmo tamanho
		    var surf_final = surface_create(surf_w, surf_h)

		    // Define a surface temporária como alvo de desenho
		    surface_set_target(surf_final)

		    // Limpa a surface (opcional, fundo preto transparente)
		    draw_clear_alpha(c_black, 0)

		    // Desenha primeiro a base da pintura
		    draw_surface(surf_painting, 0, 0)

		    // Depois desenha a sobreposição (por cima)
		    draw_surface(surf_overlay, 0, 0)

		    // Retorna o alvo de desenho ao normal
		    surface_reset_target()

		    // Salva a surface final como PNG
		    surface_save(surf_final, "painting_" + string(get_timer()*fps_real) + ".png")

		    // Libera a memória da surface temporária
		    surface_free(surf_final)
		}
	}
	#endregion
	#endregion
}
// Se o mouse NÃO está na area de pintura
else {
	/// Anulo o save das coordenadas do mouse usado na ferramenta do pincel
	m_previous_x = _mouse_x_surf
	m_previous_y = mouse_y
}

#region Desenhando na surface
if ((global.pause or instance_exists(obj_tutorial)) or instance_exists(obj_tutorial)) exit;

/// Se estiver usando uma ferramenta do mouse ou limpando, ativa a flag para desenhar/atualizar a surface
if paint_active or paint_clear {
    surf_painting_update = true
}
// Verifica se precisa atualizar a surface
if surf_painting_update {
	// Verifica se a surface ainda existe
    if !surface_exists(surf_painting) {
		// Cria a surface se necessário
        restore_surfaces()
    }
	
	// Define a surface como alvo de desenho
    surface_set_target(surf_painting)
	
	// Se estiver usando uma ferramenta do mouse e o mouse está na area de pintura
    if paint_active and mouse_in_paint {
		// Se a ferramenta ativa for pincel
        if paint_tool == 0 {
			// Desenha uma linha entre a posição anterior e a atual com a cor e espessura do pincel
            draw_line_width_colour(m_previous_x, m_previous_y, _mouse_x_surf, mouse_y, paint_width * 2, curt.co, curt.co)
			
			// Desenha um círculo na posição atual do mouse
            draw_circle_color(_mouse_x_surf, mouse_y, paint_width, curt.co, curt.co, false)
			
			///
			if colp == request.colors and time_colp_spent > 0 {
				time_colp_spent--
			}
        }
		// Se a ferramenta for borracha
		else if paint_tool == 1 {
			// Muda o modo de mistura para subtração
            gpu_set_blendmode(bm_subtract)
			
			// Desenha a linha com cor branca (apagando)
            draw_line_width_colour(m_previous_x, m_previous_y, _mouse_x_surf, mouse_y, paint_width * 2, c_white, c_white)
			
			// Desenha o círculo da borracha
            draw_circle_color(_mouse_x_surf, mouse_y, paint_width, c_white, c_white, false)
			
			// Restaura o modo de mistura normal
            gpu_set_blendmode(bm_normal)
        }
		
		/// Atualiza a posição anterior do mouse
        m_previous_x = _mouse_x_surf
        m_previous_y = mouse_y
    }
	
	// Se for para limpar a pintura
    else if paint_clear {
        // Preenche toda a surface com uma cor e transparencia (ou seja, apaga toda surface)
        draw_clear_alpha(paint_clear_col, paint_clear_alpha)
		
		/// Reseta toda a surface OVERLAY
		surface_reset_target()
		surface_set_target(surf_overlay)
		draw_clear_alpha(c_black, 0)
		
		/// Reseta todas as variaveis de elementos únicos
		paint_img_set = false
		ti_set = false
		pa_set = false
		img_set_correct = false
		ti_set_correct = false
		pa_set_correct = false
		
        // Desativa a flag de limpar a surface
        paint_clear = false
		
		//
		if time_colp_spent > 0 {
			// Pega o "nome" da cor atual
			get_color_pencil()
			
			//
			if colp == request.colors {
				time_colp_spent -= 50
			}
		}
    }

    // Restaura o alvo de desenho para a tela
    surface_reset_target()

    // Desativa a flag de atualizar a surface
    surf_painting_update = false
}


/// Se estiver usando a ferramenta de colocar img, ti ou pa, ativa a flag para desenhar/atualizar a surface OVERLAY
if paint_img or ti or pa {
	surf_overlay_update = true
}
// Verifica se precisa atualizar a overlay
if surf_overlay_update {
    // Verifica se a surface existe
    if !surface_exists(surf_overlay) {
        // Cria a surface caso não exista
        restore_surfaces()
    }

    // Define a surface como alvo
    surface_set_target(surf_overlay)
	
	// Se for para inserir a img
    if paint_img {
		/// Desenha a img
		var _img_w = sprite_get_width(img)
		var _img_h = sprite_get_height(img)
		var _draw_img_w = surf_w * .4
		var _draw_img_h = _draw_img_w * (_img_h/ _img_w)
		draw_sprite_stretched(img, 0, _mouse_x_surf - _draw_img_w / 2, mouse_y - _draw_img_h / 2, _draw_img_w, _draw_img_h)
		
		// Indica que a img já foi colocada
		paint_img_set = true
		
        // Desativa a flag do img
        paint_img = false
    }
	// Se for para inserir a ti
	else if ti {
		/// Set da fonte e origem horizontal
		draw_set_font(fnt_web)
		draw_set_halign(fa_center)
		draw_set_color(c_black)
		
		// Desenha o texto
		draw_text_ext_transformed(_mouse_x_surf, mouse_y, ti_text, -1, surf_w * 0.7, 1.4, 1.4, 0)
		
		/// Reset da fonte e origem horizontal
		draw_set_font(-1)
		draw_set_halign(-1)
		draw_set_color(-1)
		
		
		// Indica que o ti já foi colocada
		ti_set = true
		
        // Desativa a flag do ti
        ti = false
		
		#region Sabendo se o título foi colocado na posição certa
		if request.h1_pos == "superior" {
			if mouse_y < room_height / 2 {
				ti_set_correct = true
			}
		}
		else if request.h1_pos == "superior esquerdo" {
			if (mouse_y < room_height / 2) and (_mouse_x_surf < surf_w / 2) {
				ti_set_correct = true
			}
		}
		else if request.h1_pos == "superior direito" {
			if mouse_y < room_height / 2 and (_mouse_x_surf > surf_w / 2) {
				ti_set_correct = true
			}
		}
		else if request.h1_pos == "meio" {
			if point_distance(0, room_height / 2, 0, mouse_y) < room_height * .2 {
				ti_set_correct = true
			}
		}
		else if request.h1_pos == "meio à esquerda" {
			if (point_distance(0, room_height / 2, 0, mouse_y) < room_height * .2) and (_mouse_x_surf < surf_w / 2) {
				ti_set_correct = true
			}
		}
		else if request.h1_pos == "meio à direita" {
			if (point_distance(0, room_height / 2, 0, mouse_y) < room_height * .2) and (_mouse_x_surf > surf_w / 2) {
				ti_set_correct = true
			}
		}
		#endregion
	}
	// Se for para inserir a pa
	else if pa {
		/// Set da fonte e origem horizontal
		draw_set_font(fnt_web)
		draw_set_halign(fa_center)
		draw_set_color(c_black)
		
		// Desenha o texto
		draw_text_ext_transformed(_mouse_x_surf, mouse_y, pa_text, -1, surf_w * 0.6, .8, .8, 0)
		
		/// Reset da fonte e origem horizontal
		draw_set_font(-1)
		draw_set_halign(-1)
		draw_set_color(-1)
		
		
		// Indica que o pa já foi colocada
		pa_set = true
		
        // Desativa a flag do pa
        pa = false
		
		#region Sabendo se o paragrafo foi colocado na posição certa
		if request.p_pos == "meio" {
			if (point_distance(0, room_height / 2, 0, mouse_y) < room_height * .2) {
				pa_set_correct = true
			}
		}
		else if request.p_pos == "meio à esquerda" {
			if (point_distance(0, room_height / 2, 0, mouse_y) < room_height * .2) and (_mouse_x_surf < surf_w / 2) {
				pa_set_correct = true
			}
		}
		else if request.p_pos == "meio à direita" {
			if (point_distance(0, room_height / 2, 0, mouse_y) < room_height * .2) and (_mouse_x_surf > surf_w / 2) {
				pa_set_correct = true
			}
		}
		else if request.p_pos == "inferior" {
			if (mouse_y > room_height / 2) {
				pa_set_correct = true
			}
		}
		else if request.p_pos == "inferior esquerdo" {
			if (mouse_y > room_height / 2) and (_mouse_x_surf < surf_w / 2) {
				pa_set_correct = true
			}
		}
		else if request.p_pos == "inferior direito" {
			if (mouse_y > room_height / 2) and (_mouse_x_surf > surf_w / 2) {
				pa_set_correct = true
			}
		}
		#endregion
	}
	
    // Restaura o alvo para a tela (nada está sendo desenhado)
    surface_reset_target()

    // Para de atualizar a overlay
    surf_overlay_update = false
}
#endregion



//show_debug_message($"time_spent: {time_spent}\ntime_colp_spent: {time_colp_spent}\nh1 set: {ti_set}\npa set: {pa_set}\nimg set: {paint_img_set}\nh1 set C: {ti_set_correct}\npa set C: {pa_set_correct}")
//show_debug_message(window_has_focus())
