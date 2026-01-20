// Parar a música da indrodução
audio_stop_all()

// Toca a música do lobby
play_sound_music(snd_int_music_lobby)


/// Criação dos trigger exclusivos
if global.sel_course == "info" {
	/// Programação
	var _tri = instance_create_layer(400, 656, "Instances", obj_int_trigger)
	with (_tri) {
		image_xscale = .75
		image_yscale = .75
		next_room = rm_prog1
		next_with_player = false
		next_with_mouse = true
		need_interaction = true
	}
	
	_tri = instance_create_layer(432, 688, "Instances", obj_int_trigger_minigame)
	with (_tri) {
		sprite_index = spr_int_trigger_prog
	}
	
	/// HTML
	_tri = instance_create_layer(64, 656, "Instances", obj_int_trigger)
	with (_tri) {
		image_xscale = 1
		image_yscale = .75
		next_room = rm_web
		next_with_player = false
		next_with_mouse = true
		need_interaction = true
	}
	
	_tri = instance_create_layer(64 + 24, 645 + 43, "Instances", obj_int_trigger_minigame)
	with (_tri) {
		sprite_index = spr_int_trigger_html
		mask_index = spr_int_trigger_html_mask
	}
}
else if global.sel_course == "agro" {
	/// Agro
	var _tri = instance_create_layer(65, 656, "Instances", obj_int_trigger)
	with (_tri) {
		image_xscale = 1
		image_yscale = .75
		next_room = rm_agro1
		next_with_player = false
		next_with_mouse = true
		need_interaction = true
	}
	
	_tri = instance_create_layer(96, 688, "Instances", obj_int_trigger_minigame)
	with (_tri) {
		sprite_index = spr_int_trigger_agro
	}
	
	/// Pecuaria
	 _tri = instance_create_layer(400, 640, "Instances", obj_int_trigger)
	with (_tri) {
		image_xscale = 1
		image_yscale = 1
		next_room = rm_pecu1
		next_with_player = false
		next_with_mouse = true
		need_interaction = true
	}
	
	_tri = instance_create_layer(432, 688, "Instances", obj_int_trigger_minigame)
	with (_tri) {
		sprite_index = spr_int_trigger_pecu
	}
}
else if global.sel_course == "manu" {
	/// Manutenção de PC
	var _tri = instance_create_layer(400, 656, "Instances", obj_int_trigger)
	with (_tri) {
		image_xscale = 1
		image_yscale = .75
		next_room = rm_mapc
		next_with_player = false
		next_with_mouse = true
		need_interaction = true
	}
	
	_tri = instance_create_layer(432, 692, "Instances", obj_int_trigger_minigame)
	with (_tri) {
		sprite_index = spr_int_trigger_mapc
	}
	
	/// Rede doméstica
	_tri = instance_create_layer(80, 688, "Instances", obj_int_trigger)
	with (_tri) {
		image_xscale = .5
		image_yscale = .25
		next_room = rm_nets
		next_with_player = false
		next_with_mouse = true
		need_interaction = true
	}
	
	_tri = instance_create_layer(96, 688, "Instances", obj_int_trigger_minigame)
	with (_tri) {
		sprite_index = spr_int_trigger_rede
	}
}
else if global.sel_course == "quimic" {
	/// Criação de móleculas
	var _tri = instance_create_layer(400, 656, "Instances", obj_int_trigger)
	with (_tri) {
		image_xscale = 1
		image_yscale = .75
		next_room = rm_mole
		next_with_player = false
		next_with_mouse = true
		need_interaction = true
	}
	
	_tri = instance_create_layer(432, 688, "Instances", obj_int_trigger_minigame)
	with (_tri) {
		sprite_index = spr_int_trigger_mole
	}
	
	/// Reciclagem
	_tri = instance_create_layer(64, 650, "Instances", obj_int_trigger)
	with (_tri) {
		image_xscale = 1
		image_yscale = .85
		next_room = rm_desc
		next_with_player = false
		next_with_mouse = true
		need_interaction = true
	}
	
	_tri = instance_create_layer(96, 697, "Instances", obj_int_trigger_minigame)
	with (_tri) {
		sprite_index = spr_int_trigger_reci
	}
}

/// Trigger do 100% método usado no draw
if global.per_com == 1 {
	//
	global.menu_to_cred = false
	
	/// Trigger de colisão
	var _tri = instance_create_layer(320, 480, "Instances", obj_int_trigger)
	with (_tri) {
		image_xscale = .5
		image_yscale = .25
		next_room = rm_credits
		next_with_player = false
		next_with_mouse = false
		need_interaction = false
	}
}


//
color_door_tri = [0, 0, 0]

///
tri_delay_restart = 15
tri_delay = tri_delay_restart
