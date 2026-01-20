if (global.pause or instance_exists(obj_tutorial) or global.seq_run) exit;


if apertado = false{
	var _num = instance_number(obj_mapc_slot)//Numero de gavetas

	for (var _i = 0; _i < _num; _i++){
	
		ponto += instance_find(obj_mapc_slot,_i).ponto//pega o id das gavetas e adiciona na lista

	}
	ponto += obj_mapc_botao_cooler.ponto
	obj_mapc_pc.ponto = ponto
	apertado = !apertado
}
else{
	obj_mapc_fim.count +=1
	room_restart()
}

