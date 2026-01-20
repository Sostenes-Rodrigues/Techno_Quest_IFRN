// Controle referente aos cabos encondidos
control_hiddens()

// Linha de conexão
if is_array(link_1) {
	///
	draw_set_color(c_green)
	draw_line_width(link_1[2], link_1[3], mouse_x, mouse_y, 2)
	draw_circle(link_1[2], link_1[3], 4, false)
	draw_set_color(c_white)
}

/// Se tem trigger de mostra o item foi ativo, acino a animação de pegar o item
if is_array(trigger_get_item) {
	gui_get_item(trigger_get_item[0], trigger_get_item[1], trigger_get_item[2])
	
	draw_set_font(fnt_nets_tl)
	draw_set_color(c_white)
	draw_set_valign(fa_top)
	draw_set_halign(fa_left)
	draw_set_alpha(draw_text_get_gui[6])
	
	// Nome
	draw_text_ext_transformed(draw_text_get_gui[0], draw_text_get_gui[1], draw_text_get_gui[3], -1, draw_text_get_gui[5], .5, .5, 0)
	// Descrição
	draw_text_ext_transformed(draw_text_get_gui[0], draw_text_get_gui[2], draw_text_get_gui[4], -1, draw_text_get_gui[5], .25, .25, 0)
}

// Saber se o player completo todas as partes
var _cont_for_win = 0
/// Desenho da lista das etapas já concluidas
for (var i = 0; i < array_length(parts_on_wires); ++i) {
    //
	if parts_on_wires[i][0] {
		draw_sprite(parts_on_wires[i][1], 0, parts_on_wires[i][2], parts_on_wires[i][3])
		
		_cont_for_win ++
		
		/// CONDIÇÃO DE VITORIA
		if _cont_for_win >= array_length(parts_on_wires) {
			///
			if alarm[0] == -1 {
				alarm[0] = 100
			}
		}
	}
}
