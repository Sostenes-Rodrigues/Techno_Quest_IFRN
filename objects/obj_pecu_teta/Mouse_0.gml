if (global.pause or instance_exists(obj_tutorial)) {
	draw = false
	
	///
	if audio_is_playing(snd_pecu_milk) {
		audio_stop_sound(snd_pecu_milk)
	}
}
else {
	if esforco -5 >= 0{
		esforco -= 5
		obj_pecu_leite.leite += 0.5
	}

	draw = true

	///
	if !audio_is_playing(snd_pecu_milk) {
		audio_play_sound(snd_pecu_milk, 5, true)
	}
}
