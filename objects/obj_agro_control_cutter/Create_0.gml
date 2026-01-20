/// Criando o tutorial
if !global.tu_pass_agro {
	global.tu_pass_agro = true
	
	var _tu = instance_create_layer(0, 0, "Instances", obj_tutorial)
	with (_tu) {
		tutorial_imgs = [spr_agro_tutorial1, spr_agro_tutorial2, spr_agro_tutorial3]
		tutorial_string = ["Primeiramente controle um trator e limpe toda grama alta no terreno.",
		"Depois plante arrastando as mudas, regue e proteja seus tomates dos insetos com agrotóxicos (cuidado para não exagerar).",
		"Depois vá para a fábrica e processe sua colheita apertando \"espaço\" ou \"enter\" quando eles estiverem no meio de uma máquina."]
		
		tutorial_length = array_length(tutorial_imgs) - 1
	}
}


///
if !audio_is_playing(snd_agro_music) {
	play_sound_music(snd_agro_music)
}
