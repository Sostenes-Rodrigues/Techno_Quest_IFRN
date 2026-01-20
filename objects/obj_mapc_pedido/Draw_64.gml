if (global.seq_run) exit;

 // ------------------------------------------------------------------
// CONFIGURA TEXTO
// ------------------------------------------------------------------
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_mapc);

var _get_tipo = obj_mapc_gaveta.tipo_definido
if (_get_tipo == 0) _get_tipo = 1;
else if (_get_tipo == 4) _get_tipo = 2;
else if (_get_tipo == 8) _get_tipo = 3;
else if (_get_tipo == 12) _get_tipo = 4;
else if (_get_tipo == 16) _get_tipo = 5;
else if (_get_tipo == 20) _get_tipo = 6;
draw_text(166, 664, _get_tipo)


var _ix = 0;
var _iy = 0;

for (var _i = 0; _i < total_slots; _i++)
{
    var _slots_x = x + comeco_x + ((tamanho_slot + buffer) * _ix);
    var _slots_y = y + comeco_y + ((tamanho_slot + buffer) * _iy);

    if (pedidos[# INFOS_MAPC.ITEM, _i] != -1)
    {
        // ------------------------------------------------------------------
        // PEGAR TAMANHO REAL DA SPRITE APÓS ESCALA
        // ------------------------------------------------------------------
        var iw = sprite_get_width(spr_mapc_memoria)  * escala_x * .8;
        var ih = sprite_get_height(spr_mapc_memoria) * escala_y * .8;

        // ------------------------------------------------------------------
        // CALCULAR CENTRO EXATO DO SLOT
        // ------------------------------------------------------------------
        var cx = _slots_x + iw * 0.5;
        var cy = _slots_y + ih * 0.6;

        // ------------------------------------------------------------------
        // DESENHAR A SPRITE CENTRALIZADA (COMO ANTES)
        // ------------------------------------------------------------------
        draw_sprite_ext(
            spr_mapc_memoria,
            pedidos[# 0, _i],
            cx,
            cy-35,
            1.4, 1.4,
            0, c_white, 1
        );


        // ------------------------------------------------------------------
        // TEXTO DA QUANTIDADE (EM CIMA)
        // ------------------------------------------------------------------
        draw_text_transformed(
            cx,
            cy - ih * 1.0 -10, // sobe proporcionalmente à sprite
            string(pedidos[# INFOS_MAPC.QUANTIDADE, _i]) + "x",
            0.8, 0.8, 0
        );

        // ------------------------------------------------------------------
        // TEXTO DO MODELO (EM BAIXO)
        // ------------------------------------------------------------------
        draw_text_ext_transformed(
            cx,
            cy + ih * 0.28,
            obj_mapc_controle.lista[pedidos[# INFOS_MAPC.MODELO, _i]],
            -1, tamanho_slot * 1.6, 0.7, 0.7, 0
        );
    }

    _ix++;
    if (_ix >= slots_h)
    {
        _ix = 0;
        _iy++;
    }
}
