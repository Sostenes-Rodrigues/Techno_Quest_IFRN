if (global.pause or instance_exists(obj_tutorial)) exit;

if irrigacao = true and pdveneno = true {
	instance_create_layer(mouse_x,mouse_y,"Instances",obj_agro_pesticide)
	veneno += 0.2
	alarm[0] = 2
	pdveneno = false
	
	if !audio_is_playing(snd_agro_spray) {
		audio_play_sound(snd_agro_spray, 5, true)
	}
}
