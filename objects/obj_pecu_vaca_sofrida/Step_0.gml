if x >= room_width/2 and meio = false{
	speed = 0
	meio = true
	
	//
	audio_stop_sound(snd_pecu_walk_grass)
	
	if instance_exists(obj_pecu_alavanca) {
		obj_pecu_alavanca.pass = false
	}
}


///
if x - sprite_width > room_width {
	var _cow_create = instance_create_layer(-128,y,"Instances_1",obj_pecu_vaca_sofrida)
	_cow_create.speed = 7
	
	play_sound_geral(snd_pecu_mooo)
	
	instance_destroy(obj_pecu_vaca_stats)
	instance_create_layer(0,0,"Instances", obj_pecu_vaca_stats)
	
	instance_destroy(self)
	

}


if speed != 0 {
	if !audio_is_playing(snd_pecu_walk_grass) {
		///
		audio_play_sound(snd_pecu_walk_grass, 5, true)
	}
	
	if (global.pause or instance_exists(obj_tutorial)) {
		x -= speed
	}
}
