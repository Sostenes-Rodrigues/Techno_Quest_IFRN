id_player = noone
root = ""

data = -1

//
create_npcs = function() {
	//
	if instance_exists(obj_db_hub_player) {
		//
		instance_destroy(obj_db_hub_player)
	}
	
	//
	for (var _i = 0;_i < array_length(data);_i++){
		//
		var _npc = instance_create_layer(irandom_range(100, room_width - 100), irandom_range(100, room_height - 100), "Instances", obj_db_hub_player)
		_npc.player.id = data[_i].id
		_npc.player.nome = data[_i].nome
		//_npc.player.senha = data[_i].senha
		//_npc.player.email = data[_i].email
		_npc.player.idade = data[_i].idade
		_npc.player.cidade = data[_i].cidade
		_npc.player.c_info = data[_i].c_info
		_npc.player.c_quimic = data[_i].c_quimic
		_npc.player.c_agro = data[_i].c_agro
		_npc.player.c_manu = data[_i].c_manu
		_npc.player.spr_hair = data[_i].spr_hair
		_npc.player.ha_r = data[_i].ha_r
		_npc.player.ha_g = data[_i].ha_g
		_npc.player.ha_b = data[_i].ha_b
		_npc.player.spr_head = data[_i].spr_head
		_npc.player.he_r = data[_i].he_r
		_npc.player.he_g = data[_i].he_g
		_npc.player.he_b = data[_i].he_b
		_npc.player.spr_body = data[_i].spr_body
		_npc.player.bo_r = data[_i].bo_r
		_npc.player.bo_g = data[_i].bo_g
		_npc.player.bo_b = data[_i].bo_b
		_npc.player.spr_leg = data[_i].spr_leg
		_npc.player.le_r = data[_i].le_r
		_npc.player.le_g = data[_i].le_g
		_npc.player.le_b = data[_i].le_b
	}
	
	//
	data = -1
}

pd_segurar = true

/// Timer para poder fazer a consulta novamente ao banco de dados
timer_query_max = 20 * game_get_speed(gamespeed_fps)
timer_query = 0
