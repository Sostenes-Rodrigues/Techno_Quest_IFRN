if (global.pause or instance_exists(obj_tutorial)) exit;

if obj_pecu_vaca_stats.pdativa and !pass {
	ativada = !ativada
	
	//
	audio_play_sound(snd_pecu_alavanca, 5, false, 1, .5)
}
