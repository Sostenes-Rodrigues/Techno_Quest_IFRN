
if instance_exists(obj_mapc_memoria) and instance_nearest(x,y,obj_mapc_memoria).x = x and  instance_nearest(x,y,obj_mapc_memoria).y = y{
	
	encaixado = true
	
	///
	if can_snd_plug {
		can_snd_plug = false
		play_sound_geral(snd_mapc_plug)
	}
	
	if instance_nearest(x,y,obj_mapc_memoria).item >= tipo_definido * 4 and instance_nearest(x,y,obj_mapc_memoria).item <= (tipo_definido *4) +3{

		var _num = 6
		for (var _i = 0; _i < _num; _i++){

	
			if instance_nearest(x,y,obj_mapc_memoria).item = obj_mapc_controle.items[_i]{
				ponto = 1
			}
		}
	}
	
}else{
	encaixado = false
	
	can_snd_plug = true
	
	ponto = 0
}
image_index = tipo_definido
