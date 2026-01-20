///

// Deixando o jogo aléatorio
randomize()


#region Criando/carregando o arquivo de save das configurações
// Nome do arquivo do save das conf
var _file_name = "conf.json"
	
// Abrindo o arquivo do save ou criando caso não exista
var _file = file_text_open_read(_file_name)
		
// Se esse save já foi criado
if _file {
	// Lendo as informações
	var _json_string = file_text_read_string(_file)
			
	// Fechando o arquivo
	file_text_close(_file)
			
	// Convertendo a string em struct
	var _data = json_parse(_json_string)
			
	///
	global.sounds_geral_per = _data.vol_g / 100
	global.sounds_music_per = _data.vol_m / 100
	global.win_f = _data.win_f
	global.com_game = _data.com_game
}
// Se esse save ainda não tinha sido criado
else {
	// Criando a struct com os meus dados
	var _data = {
		///
		vol_g: 70,
		vol_m: 70,
		win_f: 1,
		com_game: 0
	}
	
	
	// Convertendo os dados em json
	var _json_string = json_stringify(_data)
			
	// Abrindo o arquivo do save ou criando caso não exista
	_file = file_text_open_write(_file_name)
			
	// Gravando as informações nele
	file_text_write_string(_file, _json_string)
			
	// Fechando o arquivo
	file_text_close(_file)
}
#endregion


// Tamanho do GUI
display_set_gui_size(1280, 720)

///
//window_set_size(960, 540)
window_set_size(1280, 720)
window_center()
window_set_fullscreen(global.win_f)


///
audio_group_load(audiogroup_music)

audio_group_set_gain(audiogroup_default, global.sounds_geral_per, 0)
audio_group_set_gain(audiogroup_music, global.sounds_music_per, 0)

/// Deixando as seguintes teclas com a mesma função (no código usar o "vk")
keyboard_set_map(ord("W"), vk_up)
keyboard_set_map(ord("A"), vk_left)
keyboard_set_map(ord("S"), vk_down)
keyboard_set_map(ord("D"), vk_right)

//
window_set_cursor(cr_none)
