if (global.pause or instance_exists(obj_tutorial)) exit;


if audio_is_playing(snd_agro_spray) {
	audio_stop_sound(snd_agro_spray)
}

if irrigacao = false {
	if sementes <= 0 {
		instance_create_layer(room_width * .9 ,room_height * .85 ,"Instances",obj_agro_sprinkler)
	}
}
