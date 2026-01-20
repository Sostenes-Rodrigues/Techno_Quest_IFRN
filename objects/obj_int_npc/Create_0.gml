//
sprite_index = asset_get_index("spr_npc_" + global.sel_course)
//
depth = -y


// Criando a base do meu diálogo (struct)
dialogo =
{
	texto  : ["testando 123", "vcvcvcvcvcvcvc vcvcvcvcvcvcvcvcvcvcvcvcvcvcvcvcv cvcvcvcvvcvcvc vcvcvcvcvcvcvcvcv cvcvcvcvcvcvcvcv cvcvcvcvcvcvcvc vcvc vcvcvcvcvv cvcvcvcvcvcvvcv cvcvcvcvvccvvcvcvcvcvcv cvcvvcvcvcv cvcvcv cvcvvcvcvcvc vvcvcvcvcvcv cvcvcvcvcvc vcvcvvcvc vcvvcvcv cvvcvc"],
	retrato: [sprite_index, obj_int_player.sprite_index],
	txt_vel: .4
};


// Colisao da area do dialogo
dialogo_area = function() {
	var _y = bbox_bottom + margem
	var _player = collision_rectangle(x - larg / 2, _y - margem * 2, x + larg / 2, _y + alt, obj_int_player, false, true)
	
	image_blend = c_white
	// Se o player está na area de dialogo
	if _player and !(!repeat_dial and speak_dial) {
		// DEBUG
		if global.debug {
			image_blend = c_red
		}
		
		// Se o player existe
		if instance_exists(_player) {
			// Se o player apertou E
			if (keyboard_check_pressed(ord("E")) or !need_interaction) and !_player.in_dialogue and !global.pause {
				_player.in_dialogue = true
				
				// Passando o meu id para o player
				_player.npc_dialogo = id
				
				//
				speak_dial = true
			}
			
			//if (keyboard_check_pressed(vk_anykey) or mouse_check_button_pressed(mb_any)) and !keyboard_check_pressed(vk_escape) {
				//_player.estado = _player.estado_parado
			//}
		}
	}
}

// DEBUG da area do dialogo
debug_area = function() {
	var _y = bbox_bottom + margem
	draw_rectangle(x - larg / 2, _y - margem * 2, x + larg / 2, _y + alt, true)
}

// Se o dialogo já foi passado uma vez
speak_dial = false
