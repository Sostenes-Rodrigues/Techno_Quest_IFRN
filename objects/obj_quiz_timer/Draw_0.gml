draw_set_halign(fa_left)

// Definindo a cor da barra no caso vermelho
draw_set_color(c_red);

// Calcula a largura da barra do cronômetro
var _bar_width = (timer / (game_spd * 90)) * room_width; 

// Desenha a barra na parte superior da tela
// coloquei o cronometro pra ocupar toda a largura porque normalmente em quizz se utlizar de barra
// que vai decrescendo com o tempo
draw_rectangle(0, 0, _bar_width, 20, false);
