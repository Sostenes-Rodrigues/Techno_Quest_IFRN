/// Criando o tutorial
if room == rm_prog3 {
	if !global.tu_pass_prog3 {
		global.tu_pass_prog3 = true
	
		var _tu = instance_create_layer(0, 0, "Instances", obj_tutorial)
		with (_tu) {
			tutorial_imgs = [spr_prog_tutorial3, spr_prog_tutorial4]
			tutorial_string = ["Caixas são obstáculos que bloqueiam um espaço, elas podem ser criadas ou destruídas usando a segunda categoria para ações de interação.",
			"Existem botões que precisam ser pressionados para poder abrir a saída de algumas fases, botões pequenos requerem que o Amilton passe por cima. Botões grandes requerem que o Amilton coloque uma caixa em cima deles."]
		
			tutorial_length = array_length(tutorial_imgs) - 1
		}
	}
}
else if room == rm_prog4 {
	if !global.tu_pass_prog4 {
		global.tu_pass_prog4 = true
	
		var _tu = instance_create_layer(0, 0, "Instances", obj_tutorial)
		with (_tu) {
			tutorial_imgs = [spr_prog_tutorial5]
			tutorial_string = ["Fases maiores exigem usar campos de repetições, encontrados na terceira categoria. Repetições voltam o caminho das ações entre o número até a ação que estiver com um ponto na frente, mude a posição do ponto apertando o botão direito do mouse no número."]
		
			tutorial_length = array_length(tutorial_imgs) - 1
		}
	}
}
else {
	if !global.tu_pass_prog1 {
		global.tu_pass_prog1 = true
	
		var _tu = instance_create_layer(0, 0, "Instances", obj_tutorial)
		with (_tu) {
			tutorial_imgs = [spr_prog_tutorial1, spr_prog_tutorial2]
			tutorial_string = ["Esse aqui é o Amilton o robô, ele precisa completar os níveis e seguir adiante. Você precisa selecionar ações para ele fazer, essas ações podem ser selecionadas a partir das caixas de categoria abaixo e devem ser levadas até a fila da direita para serem lidas.",
			"Caso coloque um comando equivocadamente, você sempre pode arrasta-los para a lixeira ou colocando-os em cima do comando que deseje trocar de posição."]
		
			tutorial_length = array_length(tutorial_imgs) - 1
		}
	}
}

///
if !audio_is_playing(snd_prog_music) {
	play_sound_music(snd_prog_music)
}


/// Metodos
//Adiciona um item a sua escolha nos slots
ds_grid_add_item = function() {
	var _grid = obj_prog_minigame.grid_items
	var _checagem = 0
	while _grid[# INFOS_PROG.ITEMS, _checagem]  != -1{
		_checagem++
	}
	_grid[# 0, _checagem] = argument[0]
	if argument[0] >7{
		_grid[# INFOS_PROG.QTD, _checagem] = argument[0]
		_grid[# INFOS_PROG.REP, _checagem] = _checagem
	}
	

}

//checca se tem um slot vazio
ds_grid_check = function() {
	
	var _grid = obj_prog_minigame.grid_items
	var _checagem = 0
	while _grid[# INFOS_PROG.ITEMS, _checagem]  != -1{
		_checagem++
	}
	return _checagem
}

//limpa os slots
ds_grid_limpar = function() {
	var _grid = obj_prog_minigame.grid_items
	var _checagem = 0
	while _grid[# INFOS_PROG.ITEMS, _checagem]  != -1{
		_grid[# INFOS_PROG.ITEMS, _checagem] = -1
		_grid[# INFOS_PROG.REP, _checagem] = -1
		_grid[# INFOS_PROG.QTD, _checagem] = -1
		_checagem++
	}
	return 0
}

//Faz as ações de determinada ação
ds_grid_action = function() {
	

	if argument[0] = 0{
		obj_prog_robo.time = 32
		obj_prog_robo.vv = -2
		obj_prog_robo.dir = 0
	}
	if argument[0] = 1{
		obj_prog_robo.time = 32
		obj_prog_robo.vh = -2
		obj_prog_robo.dir = 1
		
	}
	if argument[0] = 2{
		obj_prog_robo.time = 32
		obj_prog_robo.vv = +2
		obj_prog_robo.dir = 2
	}
	if argument[0] = 3{
		obj_prog_robo.time = 32
		obj_prog_robo.vh = +2
		obj_prog_robo.dir = 3
	}
	if argument[0] = 4{
		
		instance_create_layer(obj_prog_robo.x + obj_prog_robo.h, obj_prog_robo.y + obj_prog_robo.v,"Instances",obj_prog_bloco)
		}
	if argument[0] = 5{
		instance_create_layer(obj_prog_robo.x + obj_prog_robo.h, obj_prog_robo.y + obj_prog_robo.v,"Instances",obj_prog_destruicao)
		}		
	if argument[0] = 8{
		obj_prog_minigame.grid_items[# INFOS_PROG.ITEMS, z] = 12
		instance_create_layer(0,0,"Instances",obj_prog_rep)
	}
	if argument[0] = 9{
		obj_prog_minigame.grid_items[# INFOS_PROG.ITEMS, z] = 8
		instance_create_layer(0,0,"Instances",obj_prog_rep)
	}
	if argument[0] = 10{
		obj_prog_minigame.grid_items[# INFOS_PROG.ITEMS, z] = 9
		instance_create_layer(0,0,"Instances",obj_prog_rep)
	}
	if argument[0] = 11{
		obj_prog_minigame.grid_items[# INFOS_PROG.ITEMS, z] = 10
		instance_create_layer(0,0,"Instances",obj_prog_rep)
	}
	if argument[0] = 12{
		obj_prog_minigame.grid_items[# INFOS_PROG.ITEMS, z] = obj_prog_minigame.grid_items[# INFOS_PROG.QTD, z]
	}
}




/// @description Variaveis Cabulosas
puerta = 0


minigame = true //Minigame está acontecendo?
scale = 5 //Scala
tamanho_slot = 16 * scale//Tamanho do slot
buffer = 1 * scale//Espaço entre os slots

vitoria = false
draw = false

invy = 0


#region //Variaveis do minigame
//Diz o local do sprite que devem ser feitos os slots
comeco_x = 18 * scale 
comeco_y = 1  * scale 

comeco_x1 = 7 * scale
comeco_y1 = 3 * scale

//Quantos slots tem na horizontal/vertical
slots_h = 1





//Total de slots +1 por causa que a grid começa em 0
total_slots = slots_h * slots_v +1

mouse_weel = total_slots -9
tmouse_weel = 0
umouse_weel = 0
//Tamanho do sprite dos slots
minigame_l = sprite_get_width(spr_prog_minigame) * scale
minigame_a = sprite_get_height(spr_prog_minigame) * scale

//Tamanho do sprite das categorias
categ_l = sprite_get_width(spr_prog_categorias) * scale
categ_y = sprite_get_height(spr_prog_categorias) * scale


categ_draw = false//Desenha na tela a categoria
categ = 0//Diz qual categoria foi selecionada

f = false

#endregion
#region //Grid
/*Item selecionado e a posição da grid selecionado,
se forem -1 quer dizer q n tem nada selecionado*/
item_selecionado = -1
pos_selecionada = -1
qtd_selecionada = -1
rep_selecionada = -1

//Cria uma grid com x de tamanho e z de slots.
grid_items = ds_grid_create(INFOS_PROG.ALTURA,total_slots)
ds_grid_set_region(grid_items, 0, 0, 2, total_slots-1, -1)

#endregion
#region //Play
play = false //O minigame esta sendo executado?

//Tamanho do sprite do botão play
play_l = sprite_get_width(spr_prog_play) * scale
play_a = sprite_get_height(spr_prog_play) * scale

z = 0
check = 0 //Checa qual slot está vazio
dir = 0 //Direção do personagem
clear = false //Variável que diz quando limpar os slots
sp = 0
si = 0
#endregion

