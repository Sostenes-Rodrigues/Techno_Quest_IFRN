/// Desenhar a barra de poluição
if !global.seq_run_out {
	var _medidor = (poluicao / poluicao_max) * 100;
	draw_healthbar(32 ,150, 64, 550, _medidor, c_black, c_green, c_red, 3, 10, 10) // Colocar Variaveis para os parametros
}

//
if (global.seq_run) exit;
/// Timer para a contagem inicial
if timer_init > 0 and !instance_exists(obj_tutorial) {
	draw_set_font(fnt_desc_init)
	draw_set_color(c_white)
	draw_set_halign(1)
	draw_set_valign(1)
	
	// Pega o número do timer (Ver se dar certo)
	var _number = (timer_init div game_get_speed(gamespeed_fps)) + 1
	
	// Desenha ele
	draw_text_transformed(room_width / 2, room_height / 2, string(_number), 1, 1, 0) // Colocar Variaveis para os parametros
	
	draw_set_font(-1)
	draw_set_halign(-1)
	draw_set_valign(-1)
}

if  timer_tempo > 0 {
	draw_set_font(fnt_desc_init)
	draw_set_color(c_white)
	draw_set_halign(1)
	draw_set_valign(1)
	
	// Pega o número do timer (Ver se dar certo)
	var _number = (timer_tempo div game_get_speed(gamespeed_fps)) + 1
	
	// Desenha ele
	draw_text_transformed(room_width / 2, 30, string(_number), 1, 1, 0) // Colocar Variaveis para os parametros
	
	draw_set_font(-1)
	draw_set_halign(-1)
	draw_set_valign(-1)
}
