//draw_text(100,100,leite)


if leite>= 100{
	vacas-= 1
	leite = 0
}

/// CONDICAO PARA PROXIMA ETAPA
if vacas = 0 {
	room_goto(rm_pecu4)
}


//
var _balde_spr_w = sprite_get_width(spr_pecu_balde)
var _balde_spr_h = sprite_get_height(spr_pecu_balde)
var _balde_w = 600
var _balde_h = _balde_w * (_balde_spr_h / _balde_spr_w)

draw_sprite_ext(spr_pecu_leite, 0, room_width / 2.14, room_height - _balde_w/3 + _balde_h, _balde_w / (sprite_get_width(spr_pecu_leite)), _balde_h / _balde_spr_h * (leite / 100), 0, c_white, 1)
draw_sprite_stretched(spr_pecu_balde, 0, room_width / 2.14 - _balde_w / 2, room_height - _balde_w/3, _balde_w, _balde_h)
