if segurando{
	exit
}
if other.segurando = true{
	exit
}

if (saudacao = false and other.saudacao = false){
	var _curso = 0
	var _idade = 0
	var _cidade = 0
////////////////////////////////////////////////////////////////////////////	
	if
	(player.c_info = other.player.c_info
	or
	player.c_manu = other.player.c_manu
	or 
	player.c_agro = other.player.c_agro
	or
	player.c_quimic = other.player.c_quimic){
		_curso = 1
	}
	
	if player.idade = other.player.idade{
		_idade = 1
	}
	if player.cidade = other.player.cidade{
		_cidade = 1
	}
/////////////////////////////////////////////////////////////////////////////
	if _curso + _cidade + _idade == 2{
		if other.x + distancia + sprite_width < room_width{

			direction = point_direction(x,y,other.x + distancia, other.y)
			otherx = other.x+distancia
			direcao = 0
		}else{

			direction = point_direction(x,y,other.x - distancia, other.y)
			otherx = other.x-distancia
			direcao = 1
		}

		tempo = 3 * game_get_speed(gamespeed_fps)
		other.tempo = 3 *game_get_speed(gamespeed_fps)
		saudacao = true
		other.saudacao = true
		other.parado = true
	}
//////////////////////////////////////////////////////////////////////////////
	if _curso + _idade + _cidade > 2{
		if other.x + distancia + sprite_width < room_width{
			
			direction = point_direction(x,y,other.x + distancia, other.y)
			otherx = other.x+distancia
			direcao = 0
			
		}else{

			direction = point_direction(x,y,other.x - distancia, other.y)
			otherx = other.x-distancia
			direcao = 1
		}
		other.parado = true
		tempo = 3 * game_get_speed(gamespeed_fps)
		other.tempo = 3 * game_get_speed(gamespeed_fps)
		saudacao = true
		other.saudacao = true
		
		
	}
}