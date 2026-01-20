/// Funções do control principal \\\

#region Funções usadas em sequencias
// Troca de room baseado na "global.next_room" (usada nas sequencias out)
function pass_room() {
	room_goto(global.next_room)
	
	///
	if instance_exists(obj_camera) {
		with(obj_camera) {
			if global.next_room_with_player {
				camera_Show_Width  = camw_save_player
				camera_Show_Height = camh_save_player
			}
			else {
				// Suponha que você tenha o ID ou nome da room
				var _room_id = global.next_room

				// Pega as informações da room
				var _info = room_get_info(_room_id)

				// Agora acessa largura e altura
				var _width = _info.width
				var _height = _info.height
				
				///
				camera_Show_Width  = _width
				camera_Show_Height = _height
			}
		}
	}
}

///
function seq_notice_ini() {
	global.seq_run = true
	
	///
	if instance_exists(obj_pause) {
		obj_pause.can_pause = false
	}
}
function seq_notice_end() {
	global.seq_run = false
	
	///
	if (room == rm_credits or room == rm_int_ifrn_outside or room == rm_db_hub or room == rm_db_registro or room == rm_link_site_ifrn) exit;
	if instance_exists(obj_pause) {
		if !instance_exists(obj_tutorial) {
			obj_pause.can_pause = true
		}
	}
}
#endregion

#region Funções de tocar som
function play_sound_geral(_sound) {
	audio_play_sound(_sound, 0, false)
}
function play_sound_music(_sound) {
	if !audio_is_playing(_sound) {
		audio_play_sound(_sound, 10, true)
	}
}
#endregion

// Essa função recebe qual variavel vai ser criada ou modificada e seu novo valor (_var é string)
function save_data(_var, _val, _type="slots") {
	// Nome do arquivo do save slot atual
	var _file_name = "save_" + string(global.index_save) + ".json"
	
	//
	if (_type == "conf") _file_name = "conf.json";
	
	// Abrindo o arquivo do save ou criando caso não exista
	var _file = file_text_open_read(_file_name)
	
	// Lendo as informações
	var _json_string = file_text_read_string(_file)
	
	// Fechando o arquivo
	file_text_close(_file)
	
	// Convertendo o json em struct
	var _data = json_parse(_json_string)
	
	// Criando ou atualizando essa variavel
	struct_set(_data, _var, _val)
	
	// Convertendo a struct em json
	_json_string = json_stringify(_data)
	
	// Abrindo o arquivo do save ou criando caso não exista
	_file = file_text_open_write(_file_name)
	
	// Gravando as informações nele
	file_text_write_string(_file, _json_string)
	
	// Fechando o arquivo
	file_text_close(_file)
}

// Essa função recebe qual variavel vai ter valor retornado
function get_data(_var, _type="slots") {
	// Nome do arquivo do save slot atual
	var _file_name = "save_" + string(global.index_save) + ".json"
	
	//
	if (_type == "conf") _file_name = "conf.json";
	
	// Abrindo o arquivo do save para ler
	var _file = file_text_open_read(_file_name)
	
	// Lendo as informações
	var _json_string = file_text_read_string(_file)
	
	// Fechando o arquivo
	file_text_close(_file)
	
	// Convertendo o json em struct
	var _data = json_parse(_json_string)
	
	//
	return struct_get(_data, _var)
}


//
function in_game_sum_per() {
	if (global.per_com == 0) {
		global.per_com = .33
		return
	}
	else if (global.per_com == .33) {
		global.per_com = .67
		return
	}
	else if global.per_com == .67 {
		global.per_com = 1
		return
	}
}


// Screenshake
function screenshake(_shake) {
	var _screenshake = instance_create_depth(0, 0, 0, obj_screenshake)
	_screenshake.shake = _shake
}
