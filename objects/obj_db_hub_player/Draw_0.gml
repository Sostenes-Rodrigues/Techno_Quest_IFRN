var _agro = player.c_agro
var _info = player.c_info
var _qui = player.c_quimic
var _manu = player.c_manu

if _agro == 1{
	_agro = "Completo"
}
else{
	_agro = "Incompleto"
}

if _info == 1{
	_info = "Completo"
}
else{
	_info = "Incompleto"
}

if _qui == 1{
	_qui = "Completo"
}
else{
	_qui = "Incompleto"
}

if _manu == 1{
	_manu = "Completo"
}
else{
	_manu = "Incompleto"
}


var _cor = make_color_rgb(117,0,234)
if desenha{
	draw_sprite_ext(spr_db_brilho,0,x,y,2,2,0,_cor,1)
}

// Se o id for o especifico
if instance_exists(obj_db_hub_control) {
	if player.id == obj_db_hub_control.id_player{
		draw_sprite_ext(spr_db_brilho, 0 ,x ,y ,2 ,2 ,0 , c_white,1)
	}
}

/// Alterar a string do sprite baseado se ele está se movendo

var _cabeca = asset_get_index(player.spr_head)
var _cabelo = asset_get_index(player.spr_hair)
var _corpo  = asset_get_index(player.spr_body)
var _perna  = asset_get_index(player.spr_leg)


count +=0.1

count %= 3

image_xscale = xescala
image_yscale = yescala

draw_sprite_ext(_perna, count, x, y, xescala, yescala, 0, make_color_rgb(player.le_r,player.le_g,player.le_b), 1)
draw_sprite_ext(_corpo, count, x, y, xescala, yescala, 0, make_color_rgb(player.bo_r,player.bo_g,player.bo_b), 1)
draw_sprite_ext(_cabeca, count, x, y, xescala, yescala, 0, make_color_rgb(player.he_r,player.he_g,player.he_b), 1)
draw_sprite_ext(_cabelo, count ,x, y, xescala, yescala, 0, make_color_rgb(player.ha_r,player.ha_g,player.ha_b), 1)

