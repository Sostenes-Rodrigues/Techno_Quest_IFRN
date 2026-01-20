/// Criando o tutorial
if !global.tu_pass_reci {
	global.tu_pass_reci = true
	
	var _tu = instance_create_layer(0, 0, "Instances", obj_tutorial)
	with (_tu) {
		tutorial_imgs = [spr_desc_tutorial1, spr_desc_tutorial2, spr_desc_tutorial3, spr_desc_tutorial4]
		tutorial_string = ["Evite que diversos objetos contaminem um ambiente, impedindo que o medidor de poluição chegue em 100%.",
		"Arraste os objetos para o descarte usando o botão esquerdo do mouse, mas cuidado, cada objeto tem uma categoria e deve ser jogada no recipiente respectivo.",
		"As categorias são: Produtos de Limpeza, Imflamáveis, Tóxicos, Corrosivos e Radioativos. Os objetos radioativos são instáveis e devem ser descados o mais rápido possível.",
		"Consiga proteger essa área pelo tempo estabelecido para ganhar."]
		
		tutorial_length = array_length(tutorial_imgs) - 1
	}
}


// Toca a música
play_sound_music(snd_desc_music_reciclagem)

// Timer para a contagem inicial
timer_init = 3 * game_get_speed(gamespeed_fps) // 3 segundos
// Som da contagem inicial
play_123 = false

// Timer do tempo a se sobreviver para ganhar
timer_tempo = 59 * game_get_speed(gamespeed_fps) // 60 segundos

//Modo do jogo
modo = 1

// Medidor de poluição
poluicao = 0
// O maximo de poluicao suportado
poluicao_max = 1000

// Poluição gerada pelo discarte incorreto
poluicao_erro = 10

/// Para iniciar o timer de spawnar lixo
timer_spawn_lixo_restart = (2 * (modo) * game_get_speed(gamespeed_fps)) - 1 / timer_tempo*game_get_speed(gamespeed_fps)  // 2 segundos
timer_spawn_lixo = timer_spawn_lixo_restart

// Número de vezes que o lixo é criado de uma vez
num_repeat = 1 * modo

// Variavel de controle para impedir que o player carregue mais de um obj
segurando = true

#region Screen Shake
// O quanto a tela meche
shake_amount = 0

// O tempo que a tela meche
shake_duration = 0

// Metodo do Screen Shake
controla_screen_shake = function() {
	/// Pegando as posições da câmera apenas na primeira vez que essa função for chamada
	static view_x = camera_get_view_x(view_camera[0])
	static view_y = camera_get_view_y(view_camera[0])
	
	// Se ainda está tendo screen shake
	if 	shake_duration > 0 {
		// Passando a duração do screen shake
		shake_duration --
		
		/// Variaveis do quanto a tela mexe (Cada obj vai passar esses parametro ao ativa o screen shake)
		var _offset_x = random_range(-shake_amount, shake_amount)
		var _offset_y = random_range(-shake_amount, shake_amount)
		
		// Definindo a posição da câmera no frame
		camera_set_view_pos(view_camera[0], view_x + _offset_x, view_y + _offset_y);
	}
	// Se acabou o screen shake
	else {
		// Voltando a posição padrão da câmera
		camera_set_view_pos(view_camera[0], view_x, view_y);
	}
}
#endregion

#region Definindo o tipo do lixo aléatorio
// Definindo os pesos
weight[0] = 90		// Lixo normal
weight[1] = 10		// Lixo radiativo
weight_total = 0	// Peso total

/// Pegando o peso total de todos os possiveis casos
for (var _i = 0; _i < array_length(weight); _i ++) {
	weight_total += weight[_i]
}

// Metodo para sortear o tipo do lixo
sortear_tipo = function() {
	/// Esse metodo vai retorna um array, sendo "0" a string do tipo e "1" a sprite_index
	
	// Lista dos tipos normais com sua sprite
	var _tipos = [["metal", spr_desc_lixo_corrosivos], ["papel", spr_desc_lixo_limpeza],
	["vidro", spr_desc_lixo_inflamaveis], ["plastico", spr_desc_lixo_toxicos]];
	
	#region Minha lógica de como fazer o controle de tipos repetidos
	/*
	Vc pode fazer aquele controle para não repetir o mesmo tipo com essa lógica:
	Crie uma variavel de tipos restart, onde sempre vai salvar a lista completa
	Outra que vai guadar o ultimo tipo tirado
	E uma variavel de contador, sempre que um tipo for definido, teste se é igual ao ultimo tipo tirado
	Se for igual, o contador soma 1
	Se for diferente, o contador volta a 0, o ultimo tipo é atualizado e a lista de tipos copia a de restart (array_copy())
	Se o contador chegar a 3, tira esse tipo da lista de tipos (deixando a lista de restart ainda com todas) e repete a criação
	*/
	#endregion
	
	// Obtém um número inteiro aleatório de 1 ao total do peso,
	var _num = irandom_range(1, weight_total)
	// Pegando a quantidade de itens na lista
	var _size = array_length(weight)
	
	// Variavel que vai somando os pesos até escolher um
	var _sum = 0
	
	// Percorrer todos os pesos e ver se o número se enquadra nesse intervalo de peso
	for (var _i = 0; _i < _size; _i ++) {
		// Incrementar a soma dos pesos
		_sum += weight[_i]
		
		// Se o _num for inferior à soma, estamos nesse intervalo, por isso selecione este _i
		if _num <= _sum {
			// DEBUG para ver os resultados
			//show_debug_message("O valor é " + string(weight[_i]) + "  para " + string(_num) + " de " + string(weight_total));
			
			// _i foi selecionado, então faz o caso que tem ele
			switch(_i) {
				case 0:	// Lixo normal
					// Escolhe um dos tipos normais
					var _esco = irandom(array_length(_tipos) - 1)
					
					return _tipos[_esco]
				
				//break;
				
				case 1:	// Lixo Radiativo
					return ["radioativo", spr_desc_lixo_radioativo]
			
				//break;
			}
		
			// Sai desse teste
			break
		}
	}
	
}
#endregion

#region Sistema de Partículas
// Criando o meu sistema de particulas
part_sys = part_system_create()

// Criando o meu emissor de particulas
part_em = part_emitter_create(part_sys) // A lixeira/lixo vai fazer o emitter executar dentro desse obj

// Criando a minha particula
particle = part_type_create()

/// Definindo as caracteristicas da part
// Sprite
part_type_shape(particle, pt_shape_cloud);

/// Cor e alpha, inicio, meio e fim
var _color1 = make_color_rgb(24, 153, 1)
var _color2 = make_color_rgb(16, 173, 5)
var _color3 = make_color_rgb(110, 221, 0)
var _alpha1 = 1
var _alpha2 = .89
var _alpha3 = .76
part_type_colour3(particle, _color1, _color2, _color3);
part_type_alpha3(particle, _alpha1, _alpha2, _alpha3)

// Frames de duração
part_type_life(particle, 12, 22);

// Escala X e Y da sprite
part_type_scale(particle, .6, .6)

// Mudanças do tamanho da part
part_type_size(particle, 0.8, 1.2, 0, .1);

// Mudanças da velocidade da part
part_type_speed(particle, 2.5, 3, 0, 0);

// Força da gravidade e direção
part_type_gravity(particle, .01, 270);

// Mudanças da direção da part
part_type_direction(particle, 50, 130, 0, 1);

// Mudanças da orientação da part
part_type_orientation(particle, 0, 0, 0, 0, false);

#endregion


create_posi = [room_width * .1, room_width * .92, room_height * .17, room_height * .75]

// Metodo para criar o lixo
cria_lixo = function() {
	// Criando o obj lixo
	var _lixo = instance_create_layer(irandom_range(create_posi[0], create_posi[1]), irandom_range(create_posi[2], create_posi[3]), "Lixo", obj_desc_lixo) // Criar variaveis para os parametros
	
	// Definindo seu tipo
	var _tipo_definido = sortear_tipo()
	
	/// Colocando as caracteristicas desse lixo
	_lixo.tipo			= _tipo_definido[0]
	_lixo.sprite_index  = _tipo_definido[1]
	
	if _lixo.tipo == "radioativo" {
		_lixo.timer_poluir_restart *= 3
	}
}
