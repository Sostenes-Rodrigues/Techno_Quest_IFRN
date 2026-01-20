draw_set_halign(fa_left)

//
if (game_win) exit;

// Definindo a cor da barra no caso vermelho
if timer >= timer_save / 2 {
	col_per = merge_color(c_yellow, c_green, ((timer - (timer_save / 2)) / (timer_save / 2)))
}
else {
	col_per = merge_color(c_red, c_yellow, (timer / (timer_save / 2)))
}
draw_set_color(col_per);

// Calcula a largura da barra do cronômetro
var _bar_width = floor((timer / timer_save) * display_get_gui_width())

// Desenha a barra na parte superior da tela
// coloquei o cronometro pra ocupar toda a largura porque normalmente em quizz se utlizar de barra
// que vai decrescendo com o tempo
draw_rectangle(0, 0, _bar_width, 20, false);
