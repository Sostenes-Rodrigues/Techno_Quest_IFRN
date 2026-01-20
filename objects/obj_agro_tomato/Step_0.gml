if (global.pause or instance_exists(obj_tutorial)) {
	alarm[0] += 1
	alarm[1] += 1
}
else {
	var _coli = instance_place(x, y ,obj_agro_machine)

	if (keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_space)) and pdclica {
		if _coli {
			if is_inside(id, _coli) {
				_coli = instance_place(x, y, obj_agro_coli_rit)
				if _coli {
					obj_agro_spawner_tomato.ponto += _coli.ponto
					_coli.draw = true
					_coli.alarm[0] = 30
					//_coli.image_xscale += 1.5
					//_coli.image_yscale += 1
					alarm[0] = 20
					pdclica = false
			
					control_sprite()
			
					control_inter_this_time = true
				}
				else {
					_coli = instance_place(x, y, obj_agro_coli_rit2)
					obj_agro_spawner_tomato.ponto += _coli.ponto
					_coli.draw = true
					_coli.alarm[0] = 30
					//_coli.image_xscale += 1.5
					//_coli.image_yscale += 1
					alarm[0] = 20
					pdclica = false
			
					control_sprite()
			
					control_inter_this_time = true
				}
			}
			else {
				obj_agro_spawner_tomato.ponto -= 1
				draw = true
				alarm[1] = 30
			
				control_inter_this_time = true
			
				// SCREENSHAKE
				screenshake(4)
				
				// Feedback sonoro
				play_sound_geral(snd_agro_rit_error)
			}
		}
		else {
			obj_agro_spawner_tomato.ponto -= 1
			draw = true
			alarm[1] = 30
		
			control_inter_this_time = true
		
			// SCREENSHAKE
			screenshake(4)
			
			// Feedback sonoro
			play_sound_geral(snd_agro_rit_error)
		}
	}

	if _coli {
		control_touch_machine = true
	}
	else {
		if control_touch_machine {
			control_touch_machine = false
		
			if !control_inter_this_time {
				obj_agro_spawner_tomato.ponto -= 1
				draw = true
				alarm[1] = 30
				
				// SCREENSHAKE
				screenshake(4)
				
				// Feedback sonoro
				play_sound_geral(snd_agro_rit_error)
			}
		}
	
		control_inter_this_time = false
	}
}
