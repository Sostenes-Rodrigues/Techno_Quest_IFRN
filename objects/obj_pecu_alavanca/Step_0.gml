var _x = room_width/2
var _y = - 32 + room_height/2



if ativada = true{
	image_index = 1
	if alavanca1 = 0{
	instance_create_layer(_x,_y,"Instances",obj_pecu_vacaDV)
	}
	if alavanca1 = 1{
	instance_create_layer(_x,_y,"Instances",obj_pecu_vacaBH)
	}
	if alavanca1 = 2{
	instance_create_layer(_x,_y,"Instances",obj_pecu_vacaVC)
	}
	if alavanca1 = 3{
	 if obj_pecu_vaca_stats.doente = false and obj_pecu_vaca_stats.suja = false and obj_pecu_vaca_stats.casco = false{
		ponto += 1
		obj_pecu_vaca_sofrida.speed = 10
		ativada = false
		
		obj_pecu_alavanca.pass = true
	 }
	
	}
	ativada = false
}
else{
	image_index = 0
}

/// CONDICAO PARA PROXIMA ETAPA
if ponto >= 4 {
	room_goto(rm_pecu3)
	
	//
	audio_stop_sound(snd_pecu_walk_grass)
}

if alavanca1 = 3 and obj_pecu_vaca_stats.doente = false and obj_pecu_vaca_stats.suja = false and obj_pecu_vaca_stats.casco = false{
	image_blend = c_green
}else{
	if alavanca1 = 3{
		image_blend = c_red
	}
}