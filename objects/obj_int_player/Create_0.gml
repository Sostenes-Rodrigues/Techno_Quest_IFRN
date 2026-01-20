// Inherit the parent event
event_inherited();

/// Defalt das sprites
if room == rm_int_lobby {
	sprite_stop = asset_get_index("spr_int_player_" + global.sel_course + "_V")
	sprite_walk = asset_get_index("spr_int_player_" + global.sel_course + "_V_walk")
}
else {
	sprite_stop = asset_get_index("spr_int_player_" + global.sel_course)
	sprite_walk = asset_get_index("spr_int_player_" + global.sel_course + "_walk")
}


/// Velocidades
hspd = 0 //Velocidade horizontal
vspd = 0 //Velocidade horizontal
vel = 2 //Velocidade que ele vai andar
if (global.debug) vel *= 4;
// Direção
dir = 0

// Por padrão ele não pode se mover
player_can_move = false

//
in_dialogue = false
//
init_dialogue = false

// Instancia do npc que estou interragindo
npc_dialogo = noone

// Lado que começa
image_xscale = -1

// Método que configura a sprite que ele possui
init_sprite = function() {
	sprite_index = sprite_stop
	/// Velocidades da animação
	sprite_set_speed(sprite_stop, 4, spritespeed_framespersecond)
	sprite_set_speed(sprite_walk, 6, spritespeed_framespersecond)

	/// Configura o centro da sprite
	sprite_set_offset(sprite_stop, sprite_get_width(sprite_stop) / 2, sprite_get_height(sprite_stop))
	sprite_set_offset(sprite_walk, sprite_get_width(sprite_walk) / 2, sprite_get_height(sprite_walk))
}

//
init_sprite()

//
step_actual = noone
step_cont = 2
