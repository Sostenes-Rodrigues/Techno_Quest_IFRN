if (moveX != 0 || moveY != 0) {
	image_speed = inputSlow ? 0.3 : 1;
	
	///
	if !audio_is_playing(snd_agro_tractor_engine_on) {
		audio_play_sound(snd_agro_tractor_engine_on, 5, true)
	}
	
	if (moveX != 0) {
		cortador =  sign(moveX)
	}
}
else {
	image_speed = 0;
	image_index = 0;
	
	///
	if audio_is_playing(snd_agro_tractor_engine_on) {
		audio_stop_sound(snd_agro_tractor_engine_on)
	}
}

depth = -bbox_bottom;
