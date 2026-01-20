if (global.pause or instance_exists(obj_tutorial)) exit;

//Seleciona as gavetas separadamente e troca as gavetas

var _num = instance_number(obj_mapc_gaveta)//Numero de gavetas
var _list = []//lista dos ids das gavetas
var _imageidx = sprite_get_number(obj_mapc_gaveta.sprite_index)//Ve o sprite maximo das gavetas
for (var _i = 0; _i < _num; _i++){
	
	_list[_i] = instance_find(obj_mapc_gaveta,_i)//pega o id das gavetas e adiciona na lista
}

//Troca as gavetas
for (var _i= 0; _i < _num; _i++){
	if _list[_i].tipo_definido + troca_gaveta <_imageidx and _list[_i].tipo_definido + troca_gaveta >=0 {
		
		_list[_i].tipo_definido += troca_gaveta
	}
}