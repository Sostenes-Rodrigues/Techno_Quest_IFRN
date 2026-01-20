/// Create

/// Criando o tutorial
if !global.tu_pass_html {
	global.tu_pass_html = true
	
	var _tu = instance_create_layer(0, 0, "Instances", obj_tutorial)
	with (_tu) {
		tutorial_imgs = [spr_web_tutorial1, spr_web_tutorial2, spr_web_tutorial3, spr_web_tutorial4]
		tutorial_string = ["Dentro do papel de um Dev front-end, aceite pedidos para criar sites e cumpra todos os seus requerimentos (hoje seu assistente conseguiu 3 clientes para você).",
		"Utilize das seguintes funcionalidades no seu painel da direita: pincel, borracha, preenchimento de tela, conta gotas, inserir (parágrafo, título e imagem) e reset.",
		"Logo em baixo, terá um mini painel para selecionar a cor desejada.",
		"Utilize a rodinha do mouse para aumentar ou diminuir o tamanho da sua área de interração."]
		
		tutorial_length = array_length(tutorial_imgs) - 1
	}
}


///
play_sound_music(snd_web_music)


// Quantos sites devem ser entregados
cont_task = 2

/// Divisões da tela entre: recepção (left), criador de site (middle) e ferramentas para criar o site (right)
div_left = ((sprite_get_width(spr_web_wall) / sprite_get_height(spr_web_wall)) * room_height) / room_width
div_right = .20

// Se é para perguntar ao player se ele quer salvar a img
quest_save_img = true
// Se é para desenhar o input do save img
gui_save_img = false
// Flag para criar a caixa de salvar a arte
save_img = false

// String do estado atual da entrega de sites
string_state = ""

#region Máquina de estados do controle dos pedidos
// Variavel de controle referente a parte de análisar os pedidos
analyse = false

// Estado de quando o cliente estiver entrando na sala
state_entering = function(_x) {
	// Se é a primeira vez que entra nesse estado
	if string_state != "entering" {
		string_state = "entering"
	}
	
	/// Se ele ainda não chegou no meio da sala, ele vai andando
	if _x < 0 {
		if !(global.pause or instance_exists(obj_tutorial)) _x += 1.5;
	}
	// Se chegou no meio da sala
	else {
		// Fica no mesmo lugar
		_x = 0
		
		// Se é para analisar
		if analyse {
			// Vai para o estado de pegando o pedido
			state_machine = state_getting
		}
		// Se NÃO é para analisar
		else {
			// Vai para o estado de falando
			state_machine = state_asking
		}
	}
	
	// Retornando a posição x do cliente
	return _x
}
// Estado de quando o cliente estiver saindo da sala
state_leaving = function(_x) {
	// Se é a primeira vez que entra nesse estado
	if string_state != "leaving" {
		string_state = "leaving"
	}
	
	/// Se ele ainda não saiu da sala, ele vai andando
	if _x > -(room_width * div_left) {
		if !(global.pause or instance_exists(obj_tutorial)) _x -= 1.5;
	}
	// Se saiu da sala
	else {
		// Devo esperar o melhor me chamar
		if analyse {
			/// Passando o tempo minimo de criação
			if time_spent > 0 {
				time_spent--
			}
			
			// Fica parado fora da sala
			_x = -(room_width * div_left)
		
			#region Indico que o player pode chama-lo para receber o pedido (crio uma luz em volta do sino que pode ser clicavel)
			// .071  .84
			// Largura do espaço da recepção
			static _space_w = room_width * div_left
		
			/// Posições X e Y
			static _bell_x = _space_w * -.117
			static _bell_y = room_height * .75
			/// Tamanho e escala
			static _bell_size = _space_w * .4
			//static _bell_scale = sprite_get_width(spr_web_light) / _bell_size
		
			/// Variavel para ir mudando a sprite do brilho
			static _bell_time = 0
			if !(global.pause or instance_exists(obj_tutorial)) _bell_time = (_bell_time + 7/game_get_speed(gamespeed_fps)) % 3;
		
			// Sabendo se estou tocando no sino
			var _bell_in_mouse = point_in_circle(mouse_x, mouse_y, _bell_x + _bell_size / 2, _bell_y + _bell_size / 2, _bell_size / 2) and !(global.pause or instance_exists(obj_tutorial))
		
			// Desenhando o brilho
			//draw_sprite_ext(spr_web_light, _bell_time, _bell_x - _bell_size, _bell_y - _bell_size, _bell_scale, _bell_scale, 0, c_blue, 0.4 - 0.1 * _bell_in_mouse)
			draw_sprite_stretched_ext(spr_web_light, _bell_time, _bell_x, _bell_y, _bell_size, _bell_size, c_yellow, 0.35 - 0.05 * _bell_in_mouse)
		
			// Se clikei no brilho
			if _bell_in_mouse and mouse_check_button_released(mb_left) {
				// Vou para o estado de entrando
				state_machine = state_entering
				// Defino que não posso mais mexer no desenho
				use_feramentas = false
			}
			#endregion
		}
		// Se devo ir logo entrar na sala
		else {
			// Vou para o estado de entrando
			state_machine = state_entering
		}
	}
	
	
	// Retornando a posição x do cliente
	return _x
}
// Estado de quando o cliente estiver pedindo o site
state_asking = function(_x) {
	/// Defino uma vez as variaveis do contador de caracteres e a string copia do texto atual
	static _text_cont = 0
	static _text_copy = ""
	
	// Se é a primeira vez que entra nesse estado
	if string_state != "asking" {
		/// Reseto as variaveis do contador de caracteres e a string copia do texto atual
		_text_cont = 0
		_text_copy = ""
		
		string_state = "asking"
		
		#region Pegando o pedido atual
		static _get_request = function(_array_libray, _array_request, _style = 0) {
			while true {
				var _lo = irandom(array_length(_array_libray) - 1)

				if _array_libray[_lo][1] {
					if _style {
						///
						ti_text = _array_libray[_lo][2]
						pa_text = _array_libray[_lo][3]
						img = _array_libray[_lo][4]
					}
					
					_array_libray[_lo][1] = false
					_array_request = _array_libray[_lo][0]
					break
				}
			}
			
			return _array_request
		}
	
		request.colors = _get_request(request_library.colors, request.colors)
		request.style  = _get_request(request_library.style, request.style, 1)
		request.h1_pos = _get_request(request_library.h1_pos, request.h1_pos)
		request.p_pos  =  _get_request(request_library.p_pos, request.p_pos)
		#endregion
	}
	
	#region Text box
	// Largura do espaço da recepção
	static _space_w = room_width * div_left
	
	/// Margens do balão de fala
	static _ma_top = 22
	static _ma_down = 52
	static _ma_lr = 15
	
	/// Definindo a fonte, o alinhamento vertical e a cor
	draw_set_font(fnt_web_textbox)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_color(c_black)
	
	
	// String da fala atual
	var _text = $"Seu novo cliente quer um site com cores predominantemente {request.colors}, estilo {request.style}, título no canto {request.h1_pos} da tela, descrição no {request.p_pos} e não se esqueça de inserir a logo, título e o texto."
	
	// Largura que o texto deve ocupar
	var _text_w = sprite_get_width(spr_web_textbox) - _ma_lr * 2
	
	// Altura que o texto deve ocupar
	var _text_h = string_height_ext(_text_copy, -1, _text_w)
	
	// Atual cópia da string da fala
	_text_copy = string_copy(_text, 0, _text_cont)
	
	/// Desenhando a caixa de texto e o proprio texto
	draw_sprite_stretched(spr_web_textbox, 0, _space_w / 2 - sprite_get_width(spr_web_textbox) / 2, room_height * .07, sprite_get_width(spr_web_textbox), _ma_top + _ma_down + _text_h)
	draw_text_ext(_space_w / 2 - sprite_get_width(spr_web_textbox) / 2 + _ma_lr, room_height * .07 + _ma_top, _text_copy, -1, _text_w)
	
	/// Resetando a fonte, o alinhamento vertical e a cor
	draw_set_font(-1)
	draw_set_valign(-1)
	draw_set_color(-1)
	
	/// Aumentando o número de caracteres da string cópia até chegar no fim
	if _text_cont <= string_length(_text) {
		if !(global.pause or instance_exists(obj_tutorial)) _text_cont += 0.7;
	}
	#endregion
	
	// Se o cliente terminou de falar
	if _text_cont > string_length(_text) {
		#region Button confirm (Ele vai acinar uma variavel que diz quando as funções de pintura podem funcionar e fez o cliente ir para o estado de sair)
		// Sprite do botão de confirmar
		static _spr_confirm = spr_web_confirm
		static _confirm_size = _space_w * .15
		static _confirm_rad = _confirm_size / 2
		/// Posição do botão
		static _confirm_x = _space_w * .7
		var _confirm_y = _text_h * 1.1 + _confirm_size + _confirm_rad * .6
	
		// Sabendo se o mouse está tocando no botão
		var _confirm_in_mouse = point_in_circle(mouse_x, mouse_y, _confirm_x + _confirm_rad, _confirm_y + _confirm_rad, _confirm_rad) and !(global.pause or instance_exists(obj_tutorial))
	
		// Desenhando o botão
		draw_sprite_stretched_ext(_spr_confirm, 0, _confirm_x, _confirm_y, _confirm_size, _confirm_size, c_white, 1 - 0.2 * _confirm_in_mouse)
		
		// Se clikei no botão
		if _confirm_in_mouse and mouse_check_button_released(mb_left) {
			// Fazendo o player poder usar as funções de desenho
			use_feramentas = true
			
			// Indicando que depois vou receber o site feito
			analyse = true
			
			// Vou para o estado de saindo
			state_machine = state_leaving
		}
		#endregion
	}
	
	// Retornando a posição x do cliente
	return _x
}
// Estado de quando o cliente estiver recebendo o site
state_getting = function(_x) {
	// Defino a variavel do texto da fala
	static _text = ""
	/// Defino uma vez as variaveis do contador de caracteres e a string copia do texto atual
	static _text_cont = 0
	static _text_copy = ""
	// Defino a variavel que conta a avaliação do site
	static _task_complete = 0
	
	// Se é a primeira vez que entra nesse estado
	if string_state != "getting" {
		/// Reseto as variaveis do contador de caracteres e a string copia do texto atual
		_text_cont = 0
		_text_copy = ""
		
		string_state = "getting"
		
		#region Pegando a string da avaliação
		// (max: 8)
		_task_complete = (time_spent <= 0) + (time_colp_spent <= 0) + ti_set + pa_set + paint_img_set + ti_set_correct + pa_set_correct
	
		#region String da fala atual
		if _task_complete == 0 {
			_text = "Nada funciona. O site está inutilizável."
		}
		else if _task_complete == 1 {
			_text = "Vários erros graves. Quase nada funciona como deveria."
		}
		else if _task_complete == 2 {
			_text = "Funciona um pouco, mas está cheio de problemas. Falta muita coisa."
		}
		else if _task_complete == 3 {
			_text = "Cumpre o mínimo. Dá pra usar, mas não impressiona."
		}
		else if _task_complete == 4 {
			_text = "Site usável, com alguns erros leves. Dá conta do recado."
		}
		else if _task_complete == 5 {
			_text = "Visual agradável e tudo funciona bem. Só precisa polir detalhes."
		}
		else if _task_complete == 6 {
			_text = "Quase perfeito. Só faltam ajustes finos."
		}
		else if _task_complete == 7 {
			_text = "Site completo, bonito e redondinho. Pronto pra brilhar."
		}
		#endregion
		#endregion
	}
		
	#region Text box
	// Largura do espaço da recepção
	static _space_w = room_width * div_left
	
	/// Margens do bolão de fala
	static _ma_top = 10
	static _ma_down = 43
	static _ma_lr = 11
	
	/// Definindo a fonte, o alinhamento vertical e a cor
	draw_set_font(fnt_web_textbox)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_color(c_black)
	
	
	// Largura que o texto deve ocupar
	var _text_w = sprite_get_width(spr_web_textbox) - _ma_lr * 2
	
	// Altura que o texto deve ocupar
	var _text_h = string_height_ext(_text_copy, -1, _text_w)
	
	// Atual cópia da string da fala
	_text_copy = string_copy(_text, 0, _text_cont)
	
	/// Desenhando a caixa de texto e o proprio texto
	draw_sprite_stretched(spr_web_textbox, 0, _space_w / 2 - sprite_get_width(spr_web_textbox) / 2, room_height * .07, sprite_get_width(spr_web_textbox), _ma_top + _ma_down + _text_h)
	draw_text_ext(_space_w / 2 - sprite_get_width(spr_web_textbox) / 2 + _ma_lr, room_height * .07 + _ma_top, _text_copy, -1, _text_w)
	
	/// Resetando a fonte, o alinhamento vertical e a cor
	draw_set_font(-1)
	draw_set_valign(-1)
	draw_set_color(-1)
	
	/// Aumentando o número de caracteres da string cópia até chegar no fim
	if _text_cont <= string_length(_text) {
		if !(global.pause or instance_exists(obj_tutorial)) _text_cont += 0.7;
	}
	#endregion
	
	// Se o cliente terminou de falar
	if _text_cont > string_length(_text) {
		#region Button confirm (Ele vai acinar uma variavel que diz quando as funções de pintura podem funcionar e fez o cliente ir para o estado de sair)
		// Sprite do botão de confirmar
		static _spr_confirm = spr_web_confirm
		static _confirm_size = _space_w * .15
		static _confirm_rad = _confirm_size / 2
		/// Posição do botão
		static _confirm_x = _space_w * .7
		var _confirm_y = _text_h + _confirm_size + _confirm_rad * .6
	
		// Sabendo se o mouse está tocando no botão
		var _confirm_in_mouse = point_in_circle(mouse_x, mouse_y, _confirm_x + _confirm_rad, _confirm_y + _confirm_rad, _confirm_rad) and !(global.pause or instance_exists(obj_tutorial))
	
		// Desenhando o botão
		draw_sprite_stretched_ext(_spr_confirm, 0, _confirm_x, _confirm_y, _confirm_size, _confirm_size, c_white, 1 - 0.2 * _confirm_in_mouse)
		
		// Se clikei no botão
		if (_confirm_in_mouse and mouse_check_button_released(mb_left) and !gui_save_img) or save_img {
			// Se não é para perguntar da img ou se já salvou a img
			if !quest_save_img or save_img {
				obj_pause.can_pause = true
				
				//
				save_img = false
				
				// Diminuindo a contador de quantos sites faltam se entregues
				cont_task--
				
				/// CONDIÇÃO DE VITORIA
				if cont_task <= 0 {
					//
					if !instance_exists(obj_control_transition_rooms) {
						// Se ainda não tinha completado no save atual
						if !get_data("c_html") {
							/// Salvando no save atual que esse minigame foi concluido
							save_data("c_html", 1)
			
							//
							in_game_sum_per()
						}
			
						// Passando qual a room o jogo deve direcionar
						global.next_room = rm_int_lobby
		
						/// Aciono o obj de transição
						var _c_tra = instance_create_layer(0, 0, "Instances", obj_control_transition_rooms)
						with(_c_tra) {
							/// Passando os assets das sequencias de entrada e saida
							asset_seq_in  = seq_transcao_in
							asset_seq_out = seq_transcao_out
							/// Passando a posição de onde a câmera de começar na proxima sala
							global.next_room_posx = 192
							global.next_room_posy = 608
				
							// Indico se a proxima room vai ter o player ou não
							global.next_room_with_player = true
							// Indico se o player está na sala atual
							player_in_room = false
				
							// Acionando o método que cria a sequencia de saida
							exit_room()
						}
					}
				}
			
				// Na proxima vez que entrar, vou entregar o pedido
				analyse = false
			
				// Vou para o estado de saindo (Fazer primeiro a pergunta de se o player gostaria de salvar sua arte)
				state_machine = state_leaving
			
				/// Limpando a tela
				paint_clear = true
				paint_clear_alpha = 0
			
				// Resetando o tempo minimo de criação
				time_spent = time_spent_restart
				// Resetando o tempo minimo de usar a cor predominante
				time_colp_spent = time_colp_spent_restart
			
				/// Resetando as variaveis do pedido atual
				request.colors = ""
				request.style  = ""
				request.h1_pos = ""
				request.p_pos  = ""
			}
			// Devo pergunta se o player quer salvar o site
			else if quest_save_img {
				obj_pause.can_pause = false
				
				// Acionando o display do save
				gui_save_img = true
				
				/// Garantindo que o panel do color picker esteja desligado
				instance_destroy(curt.cp);
				curt.cp = noone;
			}
		}
		#endregion
	}
	
	// Retornando a posição x do cliente
	return _x
}
	
// Definindo o estado de inicio (cliente entrando)
state_machine = state_entering
#endregion

#region Criação das structs que vão armazenar diversas caracteristicas de um pedido do cliente e aquela que vai guadar o pedido atual
request_library = {
	colors: [["vermelhas", true], ["verdes", true], ["azuis", true], ["amarelas", true], ["rosas", true], ["roxas", true], ["laranjas", true], ["cinzas", true], ["pretas", true], ["brancas", true]],
	style:  [["irado", true, "Adrenalina Pura", "Mergulhe no universo dos esportes radicais com vídeos insanos, manobras que desafiam a gravidade e transmissões ao vivo direto dos picos mais irados do planeta. Se é loucura, tá aqui.", spr_web_irado],
	["fofo", true, "Mimos & Afetos", "Presentinhos feitos com amor para corações sensíveis. De pelúcias bordadas a cartões cheios de glitter, tudo aqui é criado pra derreter corações e arrancar sorrisos tímidos.", spr_web_fofo],
	["aconchegante", true, "Refúgio do Sabor", "Sinta o cheirinho de pão saindo do forno e o calor do chá na xícara. Receitas, dicas e histórias que abraçam a alma e aquecem o coração - tudo no seu tempo, do seu jeitinho.", spr_web_aconchegante],
	["terror", true, "Sussurros da Névoa", "Você acorda... mas nada parece certo. Cada clique ecoa. Cada sombra esconde segredos. Mergulhe num pesadelo interativo onde a única certeza é que alguém — ou algo — está observando.", spr_web_terror],
	["minimalista", true, "Linhas", "Menos ruído. Mais intenção. Um espaço limpo para destacar design puro, funcional e direto ao ponto. Porque beleza mora na simplicidade que comunica.", spr_web_minimalista],
	["surrealista", true, "Sonhar é Matéria", "O tempo derrete, os olhos flutuam e o real se desmancha em formas que você nunca imaginou. Descubra obras que habitam o limite entre o absurdo e o sublime - onde o impossível mora.", spr_web_surrealista],
	["extravagante", true, "Imperatriz do Caos", "Veludo com neon? Claro. Plumas com spikes? Sempre. Nossas peças gritam, brilham e quebram todas as regras com elegância explosiva. Vista-se como se o mundo fosse sua passarela.", spr_web_extravagante],
	["\"faça o que quiser\"", true, "Por Que Não?", "Uma escova que toca saxofone? Um app que detecta gatos invisíveis? Aqui, o inútil é arte e o absurdo é rei. Se dá pra imaginar, dá pra inventar. A lógica? Deixa lá fora.", spr_web_quiser]],
	h1_pos: [["superior", true], ["superior esquerdo", true], ["superior direito", true], ["meio", true], ["meio à esquerda", true], ["meio à direita", true]],	 //(Talvez já botar aqui as porcentagens de tela usadas no teste)
	p_pos:  [["meio", true], ["meio à esquerda", true], ["meio à direita", true], ["inferior", true], ["inferior esquerdo", true], ["inferior direito", true]]	 //(Talvez já botar aqui as porcentagens de tela usadas no teste)
}

/// Pedido atual
request = {
	colors: "",
	style:  "",
	h1_pos: "",
	p_pos:  ""
}
#endregion

#region Set das variaveis da ferramenta de pintura (middle)
/// Variaveis para o teste de avaliação
time_spent_restart = 20 * game_get_speed(gamespeed_fps)
time_spent = time_spent_restart
ti_set_correct = 0
pa_set_correct = 0
time_colp_spent_restart = 4 * game_get_speed(gamespeed_fps)
time_colp_spent = time_colp_spent_restart
colp = ""

// Pega o "nome" da cor atual
get_color_pencil = function() {
	if time_colp_spent > 0 {
		var _b = ((curt.co >> 16) & 255)   // Blue
		var _g = ((curt.co >> 8) & 255)    // Gree
		var _r = (curt.co & 255)			// Red
		
		if (_r > 180 && _g < 80 && _b < 80) {
			colp = "vermelhas"
		}
		else if (_g > 180 && _r < 80 && _b < 80) {
			colp = "verdes"
		}
		else if (_b > 180 && _r < 80 && _g < 80) {
			colp = "azuis"
		}
		else if (_r > 170 && _g > 170 && _b < 80) {
			colp = "amarelas"
		}
		else if (_r > 180 && _b > 180 && _g < 100) {
			colp = "rosas"
		}
		else if (_r > 100 && _b > 100 && _g < 80) {
			colp = "roxas"
		}
		else if (_r > 160 && _g > 90 && _b < 80) {
			colp = "laranjas"
		}
		else if (abs(_r - _g) < 10 && abs(_r - _b) < 10 && _r < 200 && _r > 50) {
			colp = "cinzas"
		}
		else if (_r < 50 && _g < 50 && _b < 50) {
			colp = "pretas"
		}
		else if (_r > 220 && _g > 220 && _b > 220) {
			colp = "brancas"
		}
		else {
			colp = "Cor indefinida"
		}
	}
}


// Posição x de onde começa a area da surface
paint_area_x = room_width * div_left

/// Tamanhos da surface
surf_w = room_width * (1 - div_left - div_right)
surf_h = room_height

// Criando a surface onde será feita a pintura
surf_painting = surface_create(surf_w, surf_h)
// Controla se precisa atualizar a surface
surf_painting_update = true

/// Criando a surface de overlay (uma outra surface em cima da de pintura para caso queira fazer efeitos extras: not use)
surf_overlay = surface_create(surf_w, surf_h)
surf_overlay_update = true

/// Controla a flag de limpeza (preenche toda surface com uma cor/transparencia)
paint_clear = true
paint_clear_alpha = 0
paint_clear_col = c_black

// Controla a flag de usar a ferramenta do pincel
paint_active = false
// Tamanho atual do raio do pincel
paint_width = 5
// Tamanho minimo do raio do pincel
paint_width_min = 1
// Tamanho maximo do raio do pincel
paint_width_max = 90

// Controla a flag de usar a ferramenta de inserir img
paint_img = false
// Indica se a img já foi colocada
paint_img_set = false

// A img que deve ser usada atualmente
img = noone

// Controla a flag de usar a ferramenta de inserir título
ti = false
// A string do título que deve ser usada atualmente
ti_text = "Title Lorem"
// Indica se o título já foi colocada
ti_set = false

// Controla a flag de usar a ferramenta de inserir paragrafo
pa = false
// A string do paragrado que deve ser usada atualmente
pa_text = "Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis."
// Indica se o paragrafo já foi colocada
pa_set = false

/// Posicionamento anterior do mouse
m_previous_x = 0
m_previous_y = 0

// Ferramentas de pintura do mouse (0 = pincel, 1 = borracha, 2 = Conta gotas)
paint_tool = 0

// Para saber se o mouse está na area de pintura
mouse_in_paint = false
#endregion

#region Set das variaveis do Seletor de ferramenta e Color Picker (ring)
// Controla quando posso utilizar as ferramentas (mas ainda posso seleciona-las)
use_feramentas = false

// Criando a grid das ferramentas, onde cada elemento vai ter a função de sua função
grid_feramentas = ds_grid_create(2, 4)
#region Definindo os metodos dos elementos da grid, o icon de cada e o número da sua ferramenta
grid_feramentas[# 0, 0] = []
grid_feramentas[# 0, 0] = []
grid_feramentas[# 1, 0] = []
grid_feramentas[# 1, 0] = []
grid_feramentas[# 0, 1] = []
grid_feramentas[# 0, 1] = []
grid_feramentas[# 1, 1] = []
grid_feramentas[# 1, 1] = []
grid_feramentas[# 0, 2] = []
grid_feramentas[# 0, 2] = []
grid_feramentas[# 1, 2] = []
grid_feramentas[# 1, 2] = []
grid_feramentas[# 0, 3] = []
grid_feramentas[# 0, 3] = []
grid_feramentas[# 1, 3] = []
grid_feramentas[# 1, 3] = []

grid_feramentas[# 0, 0][0] = function() {
	// Indico que o pincel é a ferramenta atual
	paint_tool = grid_feramentas[# 0, 0][2]
}
grid_feramentas[# 0, 0][1] = spr_web_tool_pencil
grid_feramentas[# 0, 0][2] = 0
grid_feramentas[# 1, 0][0] = function() {
	// Indico que a borracha é a ferramenta atual
	paint_tool = grid_feramentas[# 1, 0][2]
}
grid_feramentas[# 1, 0][1] = spr_web_tool_eraser
grid_feramentas[# 1, 0][2] = 1
grid_feramentas[# 0, 1][0] = function() {
	/// Ativa a flag de limpar com suas caracteristicas
	if use_feramentas {
		paint_clear = true
		paint_clear_col = curt.co
		paint_clear_alpha = 1
	}
}
grid_feramentas[# 0, 1][1] = spr_web_tool_color_filler
grid_feramentas[# 0, 1][2] = noone
grid_feramentas[# 1, 1][0] = function() {
	// Indico que o conta gotas é a ferramenta atual
	paint_tool = grid_feramentas[# 1, 1][2]
}
grid_feramentas[# 1, 1][1] = spr_web_tool_eyedropper
grid_feramentas[# 1, 1][2] = 2
grid_feramentas[# 0, 2][0] = function() {
	// Indico que inserir title é a ferramenta atual
	paint_tool = grid_feramentas[# 0, 2][2]
}
grid_feramentas[# 0, 2][1] = spr_web_tool_h1
grid_feramentas[# 0, 2][2] = 4
grid_feramentas[# 1, 2][0] = function() {
	// Indico que inserir paragrafo é a ferramenta atual
	paint_tool = grid_feramentas[# 1, 2][2]
}
grid_feramentas[# 1, 2][1] = spr_web_tool_p
grid_feramentas[# 1, 2][2] = 5
grid_feramentas[# 0, 3][0] = function() {
	// Indico que inserir imagem é a ferramenta atual
	paint_tool = grid_feramentas[# 0, 3][2]
}
grid_feramentas[# 0, 3][1] = spr_web_tool_image
grid_feramentas[# 0, 3][2] = 3
grid_feramentas[# 1, 3][0] = function() {
	/// Ativa a flag de limpar com suas caracteristicas
	if use_feramentas {
		paint_clear = true
		paint_clear_alpha = 0
		
		///
		time_spent = time_spent_restart
		time_colp_spent = time_colp_spent_restart + 50
	}
}
grid_feramentas[# 1, 3][1] = spr_web_tool_refresh
grid_feramentas[# 1, 3][2] = noone
#endregion

#region Métodos usados no color picker
/// @param x
/// @param y
/// @param block_width
/// @param sidebar_width
/// @param space_width
/// @param background_color
color_picker_create = function(x, y, b = 255, w = 32, s = 10, c = c_white) {
	// Criando a instancia do obj que faz o panel e suas funções
	var i = instance_create_depth(0, 0, depth - 1, obj_color_picker)
	/// Definindo suas caracteristicas base
	with (i) {
		draw.sx = x;
		draw.sy = y;
		draw.bw = b;
		draw.sw = w;
		draw.sp = s;
		draw.bc = c;
	}
	
	// Retornando o id dessa instancia
	return i;

}

/// @param instance
/// @param color_value
color_picker_set = function(i, c) {
	/// Defindo as caracteristicas atuais do painel
	with (i) {
		curt.hu = color_get_hue(c);
		curt.sa = color_get_saturation(c);
		curt.va = color_get_value(c);
		draw.re = true;
	}
}

/// @param instance
color_picker_get = function(i) {
	/// Pegando a cor atual do painel
	var r = c_black;
	with (i) r = make_color_hsv(curt.hu, curt.sa, curt.va)
	
	// Retorna a cor
	return r

}

/// @param color_value
color_to_hex = function(c) {
	/// rgb to hex
	var n = (c & 16711680) >> 16 | (c & 65280) | (c & 255) << 16,
		s = "0123456789ABCDEF",
		r = "";

	repeat (3) {
		var b = n & 255;
		r = string_char_at(s, b div 16 + 1) + string_char_at(s, b % 16 + 1) + r;
		n = n >> 8;
	}
	
	// Retorna a cor em hex
	return "#" + r;

}

/// @param hex_string
hex_to_color = function(h) {
	/// hex to rbg
	var s = string_upper(string_lettersdigits(h)),
		s = string_copy(s, 1, 6),
		l = string_length(s);
		
	if (l == 3) {
		var c1 = string_char_at(s, 1),
			c2 = c1,
			c3 = string_char_at(s, 2),
			c4 = c3,
			c5 = string_char_at(s, 3),
			c6 = c5;
	} else {
		var c1 = string_char_at(s, 1),
			c2 = string_char_at(s, 2),
			c3 = string_char_at(s, 3),
			c4 = string_char_at(s, 4),
			c5 = string_char_at(s, 5),
			c6 = string_char_at(s, 6);
	}

	var r = char_to_num(c1) * 16 + char_to_num(c2),
		g = char_to_num(c3) * 16 + char_to_num(c4),
		b = char_to_num(c5) * 16 + char_to_num(c6);
	
	
	// Retorna a cor em rgb
	return make_color_rgb(r, g, b);

}

/// @param char
char_to_num = function(c) {
	
	var r = string_digits(c);
	if (r != "") return real(r);
	
	switch (c) {
		case "A": r = 10; break;
		case "B": r = 11; break;
		case "C": r = 12; break;
		case "D": r = 13; break;
		case "E": r = 14; break;
		case "F": r = 15; break;
		default : r = 0;
	}

	return r;

}
#endregion

/// Configurações iniciais do trigger do Color Picker
draw = {
	sx : room_width * (1 - div_right) + room_width * .015,			// start x
	sy : room_height * .6,											// start y
	ex : room_width - room_width * .015,							// end x
	ey : (room_height * .6) + room_width * .039,					// end y
	c0 : make_color_rgb(137, 137, 137),									// cor das coisas dentro do trigger
	c1 : make_color_rgb(0, 0, 0)									// cor das coisas fora do trigger
}
/// Configurações iniciais do panel
curt = {
	// Cor inicial do panel do Color Picker
	co : hex_to_color("#FFFFFF"),
	// Id da instancia do obj do painel (começa com noone pq começa desligado)
	cp : noone
}
#endregion


// Parte da esquerda ()
draw_left = function() {
	#region Set das variaveis
	// Largura do espaço da esquerda
	static _gui_w = room_width * div_left
	
	// Cor do fundo
	static _back_col = make_color_rgb(40, 70, 120)
	
	// Para as partes que usam seno e cosseno
	static _degrees = 0
	
	
	#region Variaveis referentes as camadas do cenario e suas ligações com a mecânica de pedidos
	/// Posição do cliente
	static _client_posx = -_gui_w
	var _client_posy = 0
	
	/// Pixels de movimento do cliente e o quanto ele se move
	static _client_spd_walk = 8
	static _client_scrolling_walk = 16
	static _client_spd_stalled = 3
	static _client_scrolling_stalled = 6
	
	static _client_spd = _client_spd_walk
	static _client_scrolling = _client_scrolling_walk
	#endregion		
	#endregion
	
	
	/// Definindo a velocidade de movimento e balanço do cliente dependendo do estado atual do pedido
	if state_machine == state_entering or state_machine == state_leaving {
		_client_spd = _client_spd_walk
		_client_scrolling = _client_scrolling_walk
	}
	else {
		_client_spd = _client_spd_stalled
		_client_scrolling = _client_scrolling_stalled
	}

	/// Aumentando os graus dentro do circulo trigonometrico e pergando o seno e cosseno
	if !(global.pause or instance_exists(obj_tutorial)) _degrees = (_degrees + _client_spd) % 360;
	
	var _sine = dsin(_degrees)
	var _cosine = dcos(_degrees)
	
	/// Efeito do cliente andando
	_client_posy = _client_scrolling * _sine
	
	#region Desenhando cada camada do cenario
	//draw_sprite_stretched(spr_web_sun, 0, 0, 0, _gui_w, room_height)	// Precisa mudar a posição e o tamanho
	draw_sprite_stretched(spr_web_wall, 0, 0, 0, _gui_w, room_height)
	draw_sprite_stretched(spr_web_clock, 0, 0, 0, _gui_w, room_height)
	draw_sprite_stretched(spr_web_client, 0, _client_posx, _client_posy, _gui_w, room_height)
	draw_sprite_stretched(spr_web_table, 0, 0, 0, _gui_w, room_height)
	draw_sprite_stretched(spr_web_others_on_table, 0, 0, 0, _gui_w, room_height)
	draw_sprite_stretched(spr_web_pc, 0, 0, 0, _gui_w, room_height)
	#endregion
	
	
	// Rodando a máquina de estados do controle dos pedidos
	_client_posx = state_machine(_client_posx)
}

// Parte da direita (Seletor de ferramenta e Color Picker)
draw_ring = function() {
	#region Set das variaveis
	// Largura do espaço da direita
	static _gui_w = room_width * div_right
	// Posição x inicial do espaço da direta
	static _gui_x = room_width * (1 - div_right)
	// Margem x
	static _gui_ma_x = _gui_w * .015
	
	// Cor do fundo
	static _back_col = make_color_rgb(50, 50, 90)
	
	/// Quantidade de linhas e colunas da grid das ferramentas
	static _lins = ds_grid_height(grid_feramentas)
	static _cols = ds_grid_width(grid_feramentas)
	
	// Sprite dos itens de ferramenta
	static _tool_spr = spr_web_tool_back
	
	// Tamanho dos itens de ferramenta
	static _tool_size = _gui_w * .265
	#endregion
	
	/// Desenhando o fundo do cenario
	//draw_rectangle_color(_gui_x - 1, 0, _gui_x + _gui_w, room_height, _back_col, _back_col, _back_col, _back_col, false)
	draw_sprite_stretched(spr_web_back_right, 0, _gui_x - 1, 0, _gui_w+1, room_height)
	
	/// Fazendo os botões de seletor de ferramenta
	for(var _l = 0; _l < _lins; _l ++) {
		for(var _c = 0; _c < _cols; _c ++) {
			/// Posições X e Y para cada botão
			var _x1 = _gui_x + _gui_ma_x + _tool_size * _c + ((_gui_ma_x * 13) * _c) + (_gui_ma_x * 7)
			var _y1 = 0 + _gui_ma_x + _tool_size * _l + ((_gui_ma_x * 7) * _l) + (_gui_ma_x * 6)
			
			/// Sabendo se o mouse está sobre o botão
			var _selecionado = false
			_selecionado = point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x1 + _tool_size, _y1 + _tool_size) and !gui_save_img and !(global.pause or instance_exists(obj_tutorial))
				
			// Se clikei nesse botão
			if _selecionado and mouse_check_button_released(mb_left) {
				// Executo a função desse botão
				grid_feramentas[# _c, _l][0]()
			}
			
			// Sabendo se o botão atual é o acionado
			var _click = paint_tool == grid_feramentas[# _c, _l][2]
			
			/// Desenhando as caixas dos itens e indicando se está selecionada pelo "_selecionado"
			draw_set_alpha(1 - (_selecionado * .2))
			draw_sprite_stretched(_tool_spr, _click, _x1, _y1, _tool_size, _tool_size)
			draw_set_alpha(1)
			
			// Desenhando o icon de cada botão
			draw_sprite_stretched(grid_feramentas[# _c, _l][1], 0, _x1, _y1, _tool_size, _tool_size)
		}
	}
	
	#region Color Picker
	#region Color Picker (Atualizo a cor e faço o input de ligar/desligar o painel)
	// Id da instancia do obj do painel (se não tiver é noone)
	var cp = curt.cp;
	
	// Metodo temporario para criar/destruir o panel
	var create_cp = function(cp) {
		if !(global.pause or instance_exists(obj_tutorial)) {
			// Se tem um painel criado
			if (cp) {
				/// Destruo esse painel (desligando-o)
				instance_destroy(cp)
				curt.cp = noone
			}
			// Se não tem um id do obj painel
			else {
				/// Definindo as caracteristicas dessa instancia do obj painel
				var cx = draw.sx,
					cy = draw.ey + 16,
					w  = draw.ex - cx + (room_width * .015) / 2,
					bw = w * .7,
					sw = w - bw - w * .1,
					spw = w - bw - sw,
					col = make_color_rgb(20, 20, 20);
			
				// Crio o obj painel
				curt.cp = color_picker_create(cx, cy, bw, sw / 2, spw / 2, col)
			
				// Passando a cor atual para essa instancia do painel
				color_picker_set(curt.cp, curt.co)
			}
		}
	}
	
	// Se tem um id do obj painel salvo, fico atualizando a cor do painel
	if (cp) curt.co = color_picker_get(cp);
	
	// Se soltei o botão esquerdo do mouse
	if (mouse_check_button_released(mb_left) and !gui_save_img) {
		// Posição x de onde o painel acaba
		var ex = draw.ex
		
		// Se o mouse está dentro da area da setinha de acionar o painel, uso o metodo de criar/destruir o panel
		if (point_in_rectangle(mouse_x, mouse_y, ex - 38, draw.sy, ex, draw.ey)) create_cp(cp);
	}
	#endregion
	
	#region Color Picker (draw background and block & string)
	/// Variaveis das coordenadas do trigger do Color Picker
	var sx = draw.sx,
		sy = draw.sy,
		ex = draw.ex,
		ey = draw.ey;
	
	#region draw background

		draw_set_color(draw.c0);
		draw_set_circle_precision(64);
		draw_roundrect_ext(sx, sy, ex, ey, 4, 4, false);

	#endregion

	#region draw block & string
	
		var co = curt.co,
			cs = color_to_hex(co);
		
		draw_set_color(co);
		draw_rectangle(sx + 7, sy + 7, sx + 31, sy + 31, false);
	
		draw_set_color(draw.c0);
		draw_rectangle(sx + 7, sy + 7, sx + 31, sy + 31, true);
	
		draw_set_color(draw.c1);
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_font(fnt_web_textbox)
		draw_text(sx + 42, sy + 19, cs);
		draw_set_font(-1)
	
		draw_line_width(ex - 27, sy + 16, ex - 19, sy + 24, 2);
		draw_line_width(ex - 12, sy + 16, ex - 20, sy + 24, 2);

	#endregion
	#endregion
	#endregion
}


// Display de salvar a img
area_save_img = function() {
	///
	var _gui_w = display_get_gui_width()
	var _gui_h = display_get_gui_height()
	
	/// Deixando tudo atrás um pouco mais escuro
	draw_set_alpha(.4)
	draw_rectangle_color(0, 0, _gui_w, _gui_h, c_black, c_black, c_black, c_black, false)
	draw_set_alpha(1)
	
	#region Set de variaveis
	var _area_percent = .7
	var _area_width = _area_percent * _gui_w
	var _area_height = _area_percent * _gui_h
	
	var _area_x1 = (_gui_w - _area_width) / 2
	var _area_y1 = (_gui_h - _area_height) / 2
	
	// String de cada "botão"
	static _features_buttons = ["Sim", "Sim, mas só o desenho de fundo", "Não", "Não, não pergunte novamente"]
	#endregion
	
	// Desenhando o fundo
	draw_sprite_stretched(spr_web_tool_back, 0, _area_x1, _area_y1, _area_width, _area_height)
	
	#region Texto e inputs
	draw_set_font(fnt_web)
	draw_set_halign(fa_center)
	
	static _string_height = string_height("I")
	
	/// Desenhando os textos de pergunta e aviso
	draw_text_ext_transformed_color(_gui_w / 2, _area_y1 + _area_height * .12, "Gostaria de salvar seu site?", -1, -1, 2, 2, 0, c_white, c_white, c_white, c_white, 1)
	draw_text_ext_transformed_color(_gui_w / 2, _area_y1 + _area_height * .12 + _string_height * 2.1, "Salvo em \"C:\\Users\\'Usuario'\\AppData\\Local\\" + game_project_name + "\", necessário habilitar para ver pastas ocultas", -1, -1, .5, .5, 0, c_white, c_white, c_white, c_white, 1)
	
	/// Cria todos os "botões"
	for (var i = 0; i < array_length(_features_buttons); i++) {
	    // Peganda o texto de botão
		var _string = _features_buttons[i]
		// Largura desse texto
		var _string_width = string_width(_string)
		
		// Espaçamento entre os botões
		var _space = (_string_height + _area_height * .05) * i
		
		// Posição vertical de cada botão
		var _y = _area_y1 + _area_height * .4 + _space
		
		// Se o mouse está por cima dele
		var _mouse_in_text = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _gui_w / 2 - _string_width / 2, _y - _string_height / 2, _gui_w / 2 + _string_width / 2, _y + _string_height / 2)
		
		/// Definindo a cor que cada botão vai ser desenhado
		var _col = c_black
		if i <= 1 {
			_col = c_lime
			if _mouse_in_text {
				_col = c_green
			}
		}
		else {
			_col = c_red
			if _mouse_in_text {
				_col = c_maroon
			}
		}
		
		// Desenhando o texto
		draw_text_color(_gui_w / 2, _y, _string, _col, _col, _col, _col, 1)
		
		// Se apertei nesse "botão"
		if _mouse_in_text and mouse_check_button_released(mb_left) {
			/// Aciono a função do botão correspondente
			if i == 0 {
				save_img = true
				
				gui_save_img = false
				
				// Verifica se as duas surfaces existem
				if surface_exists(surf_painting) && surface_exists(surf_overlay) {

				    // Cria uma surface temporária com o mesmo tamanho
				    var surf_final = surface_create(surf_w, surf_h)

				    // Define a surface temporária como alvo de desenho
				    surface_set_target(surf_final)

				    // Limpa a surface (opcional, fundo preto transparente)
				    draw_clear_alpha(c_black, 0)

				    // Desenha primeiro a base da pintura
				    draw_surface(surf_painting, 0, 0)

				    // Depois desenha a sobreposição (por cima)
				    draw_surface(surf_overlay, 0, 0)

				    // Retorna o alvo de desenho ao normal
				    surface_reset_target()

				    // Salva a surface final como PNG
				    surface_save(surf_final, "painting_" + string(get_timer()*fps_real) + ".png")

				    // Libera a memória da surface temporária
				    surface_free(surf_final)
				}
			}
			else if i == 1 {
				save_img = true
				
				gui_save_img = false
				
				// Verifica se a surface existe antes de salvar
			    if surface_exists(surf_painting) {
			        // Salva a surface com nome único (timer * fps)
			        surface_save(surf_painting, "painting_" + string(get_timer()*fps_real) + ".png")
			    }
			}
			else if i == 2 {
				save_img = true
				
				gui_save_img = false
			}
			else if i == 3 {
				save_img = true
				
				gui_save_img = false
				//
				quest_save_img = false
			}
		}
	}
	
	draw_set_font(-1)
	draw_set_halign(-1)
	#endregion
}

#region Sistema de Proteção de Surface
// Sprites de backup
sprite_painting_backup = -1
sprite_overlay_backup = -1

// Controle para o sistema de salvar as surfaces ao minimizar o jogo
focus = "default"

/// @function backup_surfaces()
/// @desc Cria sprites de backup das duas surfaces
backup_surfaces = function() {
    // Backup surf_painting
    if surface_exists(surf_painting) {
		if sprite_exists(sprite_painting_backup) {
			sprite_delete(sprite_painting_backup)
		}
		
        sprite_painting_backup = sprite_create_from_surface(surf_painting, 0, 0, surf_w, surf_h, false, false, 0, 0)
    }

    // Backup surf_overlay
    if surface_exists(surf_overlay) {
		if sprite_exists(sprite_overlay_backup) {
			sprite_delete(sprite_overlay_backup)
		}
		
        sprite_overlay_backup = sprite_create_from_surface(surf_overlay, 0, 0, surf_w, surf_h, false, false, 0, 0)
    }
}

/// @function restore_surfaces()
/// @desc Recria surfaces e redesenha os sprites de backup, se existirem
restore_surfaces = function() {
    if !surface_exists(surf_painting) {
        surf_painting = surface_create(surf_w, surf_h)
    }
	surface_set_target(surf_painting)
    

    draw_sprite(sprite_painting_backup, 0, 0, 0)
    
    surface_reset_target()
	
	
    if !surface_exists(surf_overlay) {
        surf_overlay = surface_create(surf_w, surf_h)
    }
	surface_set_target(surf_overlay)
    
    
    draw_sprite(sprite_overlay_backup, 0, 0, 0)
    
    surface_reset_target()
}

#endregion
