if (global.pause or instance_exists(obj_tutorial)) {
	speed = 0
	image_speed = 0
	
	///
	if audio_sound_is_playable(snd_pecu_walk_grass) {
		audio_stop_sound(snd_pecu_walk_grass)
	}
}
else {
	speed = spd
	image_speed = 1
	
	///
	if !audio_sound_is_playable(snd_pecu_walk_grass) {
		audio_play_sound(snd_pecu_walk_grass, 5, true, .6, 0, 3)
	}
	
	if keyboard_check_pressed(vk_down) and camada <3{
		camada ++
	}

	if keyboard_check_pressed(vk_up) and camada >1{
		camada --
	}


	y = 300 + (100 * camada)
}
