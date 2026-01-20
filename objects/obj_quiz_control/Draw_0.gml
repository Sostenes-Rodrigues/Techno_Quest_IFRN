draw_set_halign(fa_left)

#region Draw vidas
// Defindo a posição para desenhar o texto
var _x = 30
var _y = 60
var _spr = spr_quiz_vida
var _w = 40
var _h = _w * (sprite_get_height(_spr) / sprite_get_width(_spr))

/// Desenhe o número de vidas na tela
for (var i = 0; i < vida; ++i) {
    var _xx = _x + (_w * 1.2) * i
	draw_sprite_stretched(spr_quiz_vida, 0, _xx, _y, _w, _h)
}
#endregion

#region Draw pergunta

// Defina a cor e a fonte do texto
draw_set_color(c_black);
draw_set_font(fnt_quiz);

// Calcular o comprimento do texto
var _texto_largura = string_width(texto);

// Calcule a posição X para centralizar o texto horizontalmente
var _texto_x = (room_width - _texto_largura) / 2;

// aqui tiver que passar um valor pra y se não o texto ficaria
// sempre centralizado ao meio
var _texto_y = 300 / 2;

// Desenhando o texto centralizado na tela
draw_text(_texto_x, _texto_y, texto);

#endregion
