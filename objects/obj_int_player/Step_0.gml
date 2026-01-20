// Verificando se o player não pode se mexer
if (global.pause or !player_can_move) {
	hspd = 0
	vspd = 0
	
	exit
}

///
if in_dialogue {
	if init_dialogue {
		init_dialogue = false
		
		// Criando a instancia do obj que vai criar o dialogo
		var _obj_dialogue = instance_create_depth(0, 0, 0, obj_dialogue)
		// Criando essa variavel com o endereço do player
		_obj_dialogue.player = id
		
		/// Passando o dialogo do npc para o obj dialogo
		with(npc_dialogo) {
			_obj_dialogue.dialogo = dialogo
		}
	}
	
	sprite_index = sprite_stop
	hspd = 0
	vspd = 0
	
	//
	exit
}

//
init_dialogue = true

//Movimento
var _up, _down, _left, _right;

_up = keyboard_check(vk_up) //Tecla que vai movimentar o personagem para cima
_down = keyboard_check(vk_down) //Tecla que vai movimentar o personagem para baixo
_left = keyboard_check(vk_left) //Tecla que vai movimentar o personagem para esquerda
_right = keyboard_check(vk_right) //Tecla que vai movimentar o personagem para direita

//Se estiver se movendo
if (_up or _down or _left or _right) and !(_left and _right or _up and _down) {
	dir = point_direction(0, 0, (_right - _left), (_down - _up))
	
	hspd =  lengthdir_x(vel, dir)//Velocidade horizontal
	vspd =  lengthdir_y(vel, dir)//Velocidade vertical
	sprite_index = sprite_walk
	
	/// Fazendo ele virar
	if dir != 90 and dir != 270 {
		if dir < 90 or dir > 270 {
			image_xscale = 1
		}
		else {
			image_xscale = -1
		}
	}
	
	/// Som de passos
	if audio_exists(step_actual) {
		if !audio_is_playing(step_actual) {
			step_actual = noone
		}
	}
	else {
		step_actual = asset_get_index("snd_int_player_step" + string(step_cont))
		
		play_sound_geral(step_actual)
		
		step_cont++
		if (step_cont > 4) step_cont = 2;
	}
}
//Se não, ele não retorna valor e o personagem não meche
else {
	sprite_index = sprite_stop
	hspd = 0
	vspd = 0
}

//
depth = -y
//show_debug_message(depth)