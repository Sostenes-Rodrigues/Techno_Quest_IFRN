if (global.pause or instance_exists(obj_tutorial)) exit;

if colisao = true and carregando = true{
	obj_agro_bag.sementes+=1
	instance_destroy(self)
	
	// SCREENSHAKE
	screenshake(2)
	
	// Feedback sonoro
	play_sound_geral(snd_nets_error)
	play_sound_geral(snd_nets_error)
}
carregando = false
