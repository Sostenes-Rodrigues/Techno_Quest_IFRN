///
draw_set_color(-1)
draw_set_halign(-1)
draw_set_valign(-1)
draw_set_font(-1)
draw_set_alpha(1)

// Variavel para pegar mais facilmente o fps do jogo
game_speed = game_get_speed(gamespeed_fps)

#region Informações coletadas do player
email	 = ""
senha	 = ""

nome	 = ""
idade	 = ""
cidade	 = ""

//
c_what_course = "c_" + global.sel_course

spr_hair = ""
ha_r	 = 0
ha_g	 = 0
ha_b	 = 0

spr_head = ""
he_r	 = 0
he_g	 = 0
he_b	 = 0

spr_body = ""
bo_r	 = 0
bo_g	 = 0
bo_b	 = 0

spr_leg	 = ""
le_r	 = 0
le_g	 = 0
le_b	 = 0
#endregion

// Variavel para saber se o jogador está conectado a internet
internet_connected = true

#region Database Event Create
#region Explicando as Funções do Firebase
/*
.Listener(): Um listener fica "ouvindo" alterações em um determinado local (nó ou coleção) no banco de dados. Quando um documento é adicionado, modificado ou excluído, ele dispara um evento assíncrono (Async - Social)
.Set(): Envia dados para o Firebase na forma de um objeto JSON. Se um documento com o mesmo ID já existir, ele será sobrescrito. Se nenhum ID for especificado, o Firebase gera um ID único automaticamente.
.Child(): Retorna uma referência ao documento especificado por um ID.
.Delete(): Remove permanentemente um documento especificado pelo id (id.Delete()). Isso não pode ser revertido. Normalmente, é usado junto com .Child() para acessar o documento a ser excluído.
.Query(): Retorna todos os documentos em uma coleção. O resultado é enviado para o evento Async - Social como uma string JSON que contém todos os documentos. json_parse() para transformá-lo em uma estrutura do GameMaker.
*/
#endregion

// Define a raiz do banco de dados Firebase como "highscores".
root = "players" // Nome da "coleção" base que vai ser acessada

// Inicializa a variável 'data' com -1, indicando que os dados ainda não foram carregados. Quando forem carregados, ele se torna uma lista com data elemento sendo uma struct que quarda todos os atributos de uma instancia
data = -1 /// Vai receber uma lista com todos os atributos de uma instancia (Ao criar um npc com, deletar as informações usadas dele da lista para melhor desenpenho)

//
id_in_login = noone

//
cont_erro = 0

//
reset_email_senha = true

// Variavel para saber quando o email foi alterado para saber se deve ou não procurar no database
last_email = ""
// Chamando uma nova consulta para pegar a versão mais recente
//FirebaseFirestore(root).Query()
// ID do database: gamemaker-tutorial-a65fb
#endregion

#region Interface Visual (Método colocado no draw)
// Struct que vai guardar todas as string usadas na interface
library_text = {
	opening: {
		title: "[wave][scale,1.4][fnt_db]Bem vindo, Acesse Sua Conta",
		desc:  "[fnt_db][speed,5]Parabéns por chegar aqui, você pode salvar essa conquista se registrando aqui junto com todos os outros que passaram daqui.Digite seu e-mail e senha para entrar. Caso ainda não tenha uma conta, siga para o próximo passo e cadastre-se!",
		button:"[fnt_db]Entrar/Logar"
	},
	registrar: {
		title: "[wave][scale,1.5][fnt_db]Crie Sua Conta",
		desc:  "[fnt_db][speed,5]Preencha os campos com suas informações para concluir seu cadastro. Assim teremos uma visão mais completa de você.",
		button:"[fnt_db]Continue"
	},
	create_visual: {
		title:	   "[wave][scale,1.5][fnt_db]Personalize Seu Avatar",
		desc:	   "[fnt_db][speed,5]Escolha a aparência do seu avatar! Ajuste cores, partes do corpo e cabelo para deixar ele com a sua cara.",
		button:	   "[fnt_db]Finalizar",
		db_access: "[fnt_db][speed,5][c_yellow][wave]Acessando o Banco de Dados..."
	},
	erro_net: {
		title: "[c_red][scale,2][shake][pulse][fnt_db]ERRO DE REDE!",
		desc:  "[fnt_db][speed,5]Estamos testando sua conexão com a internet. Tente verificar se sua conexão está funcionando.\nCaso não tenha interesse em salvar sua conquista no nosso hub ou não tenha como se conectar à internet, você pode só voltar ao menu principal com o botão \"Sair\" na parte inferior direita.",
	},
	erro_cadastro_desc: {
		db_test_access:	 "[fnt_db][speed,5][c_yellow][wave]Procurando no Banco de Dados...",
		email:			 "[fnt_db][speed,5][c_red]Insira um email com dominio válido! \"exemplo@gmail.com\"",
		senha:			 "[fnt_db][speed,5][c_red]Senha inválida! A senha deve ter pelo menos 8 caracteres, conter letras maiúsculas, minúsculas e números.",
		senha_incorrect: "[fnt_db][speed,5][c_red]Senha incorreta! Verifique se escrevel a senha corretamente",
		nome:			 "[fnt_db][speed,5][c_red]Nome de usuário inválido! O nome deve conter apenas letras e não pode estar vazio.",
		idade:			 "[fnt_db][speed,5][c_red]Insira uma idade válida!",
		cidade:			 "[fnt_db][speed,5][c_red]Insira um nome de cidade válido!"
	}
}

// Variavel de controle acionado pelo botão de continuar para rodar uma parte do código da tabela uma vez
button_action = false

/// Textos escritos no guia
text_guide_title = ""
cont_text_guide_title = 0
text_guide_desc = ""

// Variavel para guardar a conf do texto da descrição
typist = noone

// Texto do botão de proceguir no cadastro
text_button_contine = ""

// Método que vai ser direcionado pelo botão de voltar
return_m = noone

// Desenha a interface e executa seus métodos
draw_interface = function() {
	#region Variaveis usadas na interface
	static _interface_w = room_width * .73
	static _interface_h = room_height * .8
	static _interface_x1 = (room_width - _interface_w) / 2 // Também usado como "_guide_x1"
	static _interface_y1 = (room_height - _interface_h) / 2
	static _interface_x2 = _interface_x1 + _interface_w
	static _interface_y2 = _interface_y1 + _interface_h
	
	// Tamamho de um lado da interface
	static _interface_side1_w = (_interface_w / 2) * .98
	static _interface_side2_w = _interface_w - _interface_side1_w
	
	/// Variaveis da tabela da esquerda (Guia/Assistente)
	static _guide_x2 = _interface_x1 + _interface_side1_w // Também usado como "_guide_x1"
	static _guide_element_margem_w = _interface_w * .02
	static _guide_element_margem_h = _interface_h * .2
	static _spacing_title_text = _interface_y1 * .02
	
	// Tamamhos de um lado das interfaces
	static _interface_side_w = _interface_w / 2
	
	static _guide_text_title_x = _interface_x1 + _guide_element_margem_w
	static _guide_text_title_y = _interface_y1 + _guide_element_margem_h
	
	#region Referente as sprite
	#region Sprite do botão grande
	static _spr_button = spr_db_button
	/// Largura e altura do sprite do botão grande
	static _spr_button_w = sprite_get_width(_spr_button)
	static _spr_button_h = sprite_get_height(_spr_button)
	
	/// Tamanhos dos botões da interface da direita
	static _button_w = _interface_side_w * .7
	static _button_h = _button_w * .17
	static _button_xscale = _button_w / _spr_button_w
	static _button_yscale = _button_h / _spr_button_h
	/// Posição x central do botão de seguir da interface da direita
	static _button_x = _guide_x2 + (_interface_side2_w / 2) - _button_w / 2
	static _button_y = _interface_h * .85
	
	// Margem dos botões pequenos de retornar e voltar ao menu principal
	static _small_button_margem_y = _interface_h * .08
	#endregion
	
	
	#region Sprite do icone de esperar da conexão na net
	static _spr_recharge = spr_db_recharge
	/// Largura e altura do sprite de esperar da conexão na net
	static _spr_recharge_w = sprite_get_width(_spr_recharge)
	static _spr_recharge_h = sprite_get_height(_spr_recharge)
	
	/// Tamanho do icone de esperar da conexão na net da interface da direita
	static _recharge_w = _interface_side_w * .5
	static _recharge_h = _recharge_w
	static _recharge_xscale = _recharge_w / _spr_recharge_w
	static _recharge_yscale = _recharge_h / _spr_recharge_h
	/// Posição x central do icone de esperar da conexão na net da interface da direita
	static _recharge_x = _guide_x2 + (_interface_side2_w / 2)
	static _recharge_y = _interface_h * .5
	#endregion
	#endregion
	
	#endregion
	
	
	#region Backgrounds da interface (Trocar os draws por sprites)
	/// Draw do retangulo da interface
	var _color1 = make_color_rgb(240, 240, 240)
	draw_roundrect_color(_interface_x1, _interface_y1, _interface_x2, _interface_y2, _color1, _color1, false)
	
	/// Draw do retangulo da "guide" (Gambiarra do carai)
	_color1 = make_color_rgb(110, 187, 239)
	draw_roundrect_color(_interface_x1 + 1, _interface_y1, _guide_x2 * .5, _interface_y2, _color1, _color1, false)
	draw_rectangle_color(_interface_x1 + (_interface_x1 * .5) + 1, _interface_y1 + 1, _guide_x2, _interface_y2, _color1, _color1, _color1, _color1, false) // VER SE DEIXA O MAIS 1 NO Y OU COMO AJEITAR
	#endregion
	
	#region Escrevendo o texto do guia
	// Desenhando o texto do titulo
	draw_text_scribble_ext(_guide_text_title_x, _guide_text_title_y, text_guide_title, _guide_x2 - _guide_text_title_x, cont_text_guide_title)
	
	/// Efeito maquina de escrever do título
	if cont_text_guide_title < string_length_scribble(text_guide_title) {
		cont_text_guide_title++
	}
	/// Apagando o efeito de "mexer" do título (Deixar para a tabela de Erro)
	else if cont_text_guide_title == string_length_scribble(text_guide_title) and text_guide_title != library_text.erro_net.title {
		// Tira o efeito "wave" do titulo
		text_guide_title = string_delete(text_guide_title, 1, 6)
		
		cont_text_guide_title++
	}
	
	
	/// Variaveis temporarias da posição do texto de descrição
	var _yy = _guide_text_title_y + string_height("I") * 3
	
	/// Desenhando o texto da descrição
	var _scribble_obj = scribble(text_guide_desc)
		.wrap(_interface_side1_w - _guide_element_margem_w, _interface_h)
		.line_spacing(string_height("I") * 1.2)

		.draw(_guide_text_title_x, _yy, typist);

	#endregion
	
	#region Fazendo os botões pequenos de "retornar" e "voltar para o menu" (como aqui não tem o menu, ele sai do jogo, MUDAR ISSO NO JOGO FINAL) Rodar isso independente de está conectado a net
	// Caracteristicas desses botões
	var _methods_button = [["[fnt_db][c_blue]Voltar", return_method], ["[fnt_db][c_blue]Sair", back_menu]]
		
	#region Interração com os botões da parte inferior da tabela da direita
	// Passa por cada conf dos botões do array de cima
	for (var _i = 0; _i < array_length(_methods_button); _i ++) {
		// Se é não o primeiro metodo da tabela da direita e se é para fazer o borão de sair
		if _i == 0 and (!internet_connected or r_table_atual == r_table_opening) {
			continue
		}
		
		/// Posições e caracteristicas
		var _w  = string_width_scribble(_methods_button[_i][0])
		var _h  = string_height_scribble(_methods_button[_i][0])
		var _x_pos = _guide_x2 + _interface_side2_w / 4 + _i * _interface_side2_w / 2 - _w / 2
		var _y_pos = _button_y + _button_h + _guide_element_margem_h / 4
			
		// Variavel para saber se o mouse está por cima
		var _button_in_mouse_d = point_in_rectangle(mouse_x, mouse_y, _x_pos, _y_pos, _x_pos + _w, _y_pos + _h)
		// Variavel para saber se o botão do mouse esquerdo foi solto 
		var _button_released_d = mouse_check_button_released(mb_left)
	
		// Se o mouse está tocando no botão
		if _button_in_mouse_d {
			// Se o mouse clicou
			if _button_released_d {
				/// Usa o método do botão atual
				_methods_button[_i][1]()
			}
		}
			
		/// Texto do botão de voltar ao menu
		draw_set_halign(1)
		draw_set_valign(1)
		draw_text_scribble(_x_pos + _w / 2, _y_pos + _h / 2, $"[alpha,{1 - (.2 * _button_in_mouse_d)}]" + _methods_button[_i][0])
		draw_set_halign(-1)
		draw_set_valign(-1)
	}
	#endregion
		
	#endregion
		
	
	// Se o usuario está conectado a internet
	if internet_connected {
		// Testa a conexão para ver se caiu (a cada 10 segundos)
		test_net(5)
		
		/// Usando o método atual da tabela da direita
		static _box_w = _interface_side_w * .75
		static _box_h = _box_w * .15
		static _box_x = _guide_x2 + (_interface_side2_w / 2) - _box_w / 2
		static _box_y = _interface_h * .22
		
		// Rodando o método do espaço da direita atual
		r_table_atual(_box_x, _box_y, _box_x + _box_w, _box_y + _box_h)
		
		#region Fazendo o botão grande de "seguir"
		// Variavel que diz se o botão está selecionado
		var _button_sel = false
	
		#region Interração com esse botão
		// Variavel para saber se o mouse está por cima
		var _button_in_mouse = point_in_rectangle(mouse_x, mouse_y, _button_x, _button_y, _button_x + _button_w, _button_y + _button_h)
		// Variavel para saber se o botão do mouse esquerdo foi solto 
		var _button_released = mouse_check_button_released(mb_left)
	
		// Se o mouse está tocando no botão
		if _button_in_mouse {
			// Indicando que o mouse está tocando no botão
			_button_sel = true
		
			// Se o mouse clicou
			if _button_released {
				// Aciona uma parte do código da tabela uma vez
				button_action = true
			}
		}
		// Se o mouse NÃO está tocando no botão
		else {
			// Indicando que o mouse NÃO está tocando no botão
			_button_sel = false
		}
		#endregion
	
		// Desenho do fundo do botão grande de seguir
		//draw_sprite_ext(spr_button_db_big, _button_sel, _button_x, _button_y, _button_xscale, _button_yscale, 0, c_white, 1)
		draw_sprite_ext(_spr_button, _button_sel, _button_x, _button_y, _button_xscale, _button_yscale, 0, c_white, 1)
		
		/// Texto do botão
		draw_set_halign(1)
		draw_set_valign(1)
		draw_text_scribble(_button_x + _button_w / 2, _button_y + _button_h / 2, text_button_contine)
		draw_set_halign(-1)
		draw_set_valign(-1)
		
		#endregion
	}
	// Se o usuario NÃO está conectado a internet
	else {
		/// Fazendo escurecer um pouco a tabela da direita
		_color1 = c_black
		draw_set_alpha(0.2)
		draw_rectangle_color(_guide_x2, _interface_y1 + 1, _interface_x2, _interface_y2, _color1, _color1, _color1, _color1, false)
		draw_set_alpha(1)
		
		// Chamando a função que dar o feedback da falta de conexão e fica verificando se a internet voltou
		r_table_erro_net(_spr_recharge, _recharge_x, _recharge_y, _recharge_xscale, _recharge_yscale)
	}

}

#region Métodos que vão ficar trocando na aréa da tabela da direita

/// (defart) Faz um espaço para colocar o email e a senha, assim descobrindo se a pessoa vai logar ou cadastrar (if CA, next: r_table_registrar. else, next: rm_hub)
r_table_opening = function(_x1, _y1, _x2, _y2) {
	// Se a primeira vez que entro nesse método
	if r_table_atual_text != "opening" {
		/// Definindo o novo texto do guia, botão e resetando o contador de letras
		text_guide_title	= library_text.opening.title
		text_guide_desc		= library_text.opening.desc
		text_button_contine = library_text.opening.button
		
		cont_text_guide_title = 0
		
		// Reseta a conf do texto da descrição
		reset_typist()
		
		// Definindo o método usado no botão de continuar
		r_table_next = r_table_registrar
		
		// Definindo o a string do método atual
		r_table_atual_text = "opening"
	}

	/// Criando as caixas de input   ///RESETAR PARA NÃO TER DIVULGAÇÃO DE DADOS
	static _box_array_o = [["", "Email", false, true], ["", "Senha", false, true]]		// [string, label, selecionado, hide_passw]
	
	if reset_email_senha {
		reset_email_senha = false
		
		_box_array_o = [["", "Email", false, true], ["", "Senha", false, true]]
	}
	
	/// Criando uma caixa de input para cada elemento no array de cima
	for (var _i = 0; _i < array_length(_box_array_o); _i++) {
		// Fazendo essas caixas de deslocarem uma da outra
		var _box_m_y = (_y2 - _y1) * _i * 1.5
		
		// Recebendo as informações das caixas criadas
		var _box_info = input_box(_box_array_o[_i][0], _box_array_o[_i][1], _x1, _y1 + _box_m_y, _x2, _y2 + _box_m_y, _box_array_o[_i][2], _box_array_o[_i][3]) // return: [_text, _b_sel]  de uma caixa espeficica
		
		/// Passar o texto obtido e se essa caixa está selecionada e se é pra esconder a senha
		_box_array_o[_i][0] = _box_info[0]
		_box_array_o[_i][2] = _box_info[1]
		_box_array_o[_i][3] = _box_info[2]
	}
	
	/// Fazendo as variaveis do email e senha recebam oque foi digitado
	email = _box_array_o[0][0]
	senha = _box_array_o[1][0]
	
	// Se o botão de continuar foi acionado
	if button_action {
		/// FALTA: Testar se o email está no database, if testar a senha e fazer em todos esses IFs mudar o texto do guia para dizer qual o problema
		/// Se tudo OK, ir para o hub e passar a lista para o obj controle
		/// Se não cadastrado, ir para a tabela de registrar
		
		#region Prepara para testar se é um email com dominio valido
		static _domain = "@gmail.com"
		static _domain_length = string_length(_domain)
		var _email_length = string_length(email)
		#endregion
    
		// Verifica se o final da string contém "@gmail.com"
		if string_copy(email, _email_length - _domain_length + 1, _domain_length) == _domain and string_pos(" ", email) == 0 {
		    #region Prepara para testar se é uma senha válida
			var _length_ok = string_length(senha) >= 8
		    var _has_upper = false
		    var _has_lower = false
		    var _has_digit = false
    
		    // Percorre cada caractere da senha
		    for (var i = 1; i <= string_length(senha); i++) {
		        var _char = string_char_at(senha, i)
				
				/// Testa os requisitos de caractes
		        if (_char >= "A" and _char <= "Z") _has_upper = true
		        else if (_char >= "a" and _char <= "z") _has_lower = true
		        else if (_char >= "0" and _char <= "9") _has_digit = true
		    }
			#endregion
			
			// Se senha valida
			if _length_ok and _has_upper and _has_lower and _has_digit and string_pos(" ", senha) == 0 {
				#region Verifica se email está no database
				// Verifica se os dados ainda não foram carregados ou se o email atual é diferente do ultimo salvo
				if data == -1 or email != last_email {
					/// Feedback que o jogo está procurando no banco de dados, resetando a variavel do ultimo email e da resposta do db
					if text_guide_desc != library_text.erro_cadastro_desc.db_test_access {
						// Passo um feedback do erro cometido
						text_guide_desc = library_text.erro_cadastro_desc.db_test_access
			
						// Reseta a conf do texto da descrição
						reset_typist()
						
						// Salva o ultimo email salvo como o atual
						last_email = email
						
						// Resetando data como vazio
						data = - 1
						
						// Faz uma consulta onde tem o email igual ao inserido
						FirebaseFirestore(root).WhereEqual("email", email).Query()
					}
				}
				// Caso os dados já tenham sido carregados
				else {
					// Se a resposta da consulta não retornou ninguem (ou seja o email não estava no database ainda)
					if array_length(data) == 0 {
						// Indo para o método de registrar
						r_table_atual = r_table_registrar
						
						// Reseta para botão não acionado
						button_action = false
					}
					// Se a resposta da consulta retornou alguém
					else {
						// Se a senha inserida for igual a senha retornada pelo query
						if senha == data[0].senha {
							if !passing_seq {
								passing_seq = true
								
								//
								id_in_login = data[0].id
								
								// Atualizo o curso finalizado nessa cessão
								set_data_login()
								
								global.seq_run = true
								/// Criando o obj controle do hub e passando as informações necessarias
								var _hub = instance_create_layer(x, y, layer, obj_db_hub_control)
								_hub.id_player = data[0].id
								_hub.root = root
								
								
								/// Indo para a rm do hub
								// Passando qual a room o jogo deve direcionar
								global.next_room = rm_db_hub
							
								var _c_tra = instance_create_layer(0, 0, "Instances", obj_control_transition_rooms)
								with(_c_tra) {
									/// Passando os assets das sequencias de entrada e saida
									asset_seq_in  = seq_transcao_in
									asset_seq_out = seq_transcao_out
									/// Passando a posição de onde a câmera de começar na proxima sala
									global.next_room_posx = 0
									global.next_room_posy = 0
				
									// Indico se a proxima room vai ter o player ou não
									global.next_room_with_player = false
									// Indico se o player está na sala atual
									player_in_room = false
				
									// Acionando o método que cria a sequencia de saida
									exit_room()

									global.pause = false
								}
							}
						}
						// Se a senha inserida for diferente (incorreta)
						else {
							// Passo um feedback do erro cometido
							text_guide_desc = library_text.erro_cadastro_desc.senha_incorrect
			
							// Reseta a conf do texto da descrição
							reset_typist()
				
							// Reseta para botão não acionado
							button_action = false
						}
					}
				}
				#endregion
			}
			// Se senha invalida
			else {
				// Passo um feedback do erro cometido
				text_guide_desc = library_text.erro_cadastro_desc.senha
			
				// Reseta a conf do texto da descrição
				reset_typist()
				
				// Reseta para botão não acionado
				button_action = false
			}
		}
		// Se o final da string NÃO contém "@gmail.com"
		else {
			// Passo um feedback do erro cometido
			text_guide_desc = library_text.erro_cadastro_desc.email
			
			// Reseta a conf do texto da descrição
			reset_typist()
			
			// Reseta para botão não acionado
			button_action = false
		}
	}
}						  

/// (before: r_table_opening) Continua o cadastro já tendo o email e senha (next: r_table_create_visual)
r_table_registrar = function(_x1, _y1, _x2, _y2) {
	// Se a primeira vez que entro nesse método
	if r_table_atual_text != "registrar" {
		/// Definindo o novo texto do guia, botão e resetando o contador de letras
		text_guide_title	= library_text.registrar.title
		text_guide_desc		= library_text.registrar.desc
		text_button_contine = library_text.registrar.button
		
		cont_text_guide_title = 0
		
		// Reseta a conf do texto da descrição
		reset_typist()
		
		// Método que vai ser direcionado pelo botão de voltar
		return_m = r_table_opening
		
		// Definindo o a string do método atual
		r_table_atual_text = "registrar"
	}
	
	/// Criando as caixas de input
	static _box_array_r = [["", "Nome", false], ["", "Idade", false], ["", "Cidade", false]]	// [string, label, selecionado, hide_passw]
	/// Criando uma caixa de input para cada elemento no array de cima
	for (var _i = 0; _i < array_length(_box_array_r); _i++) {
		// Fazendo essas caixas de deslocarem uma da outra
		var _box_m_y = (_y2 - _y1) * _i * 1.5
		
		// Recebendo as informações das caixas criadas
		var _box_info = input_box(_box_array_r[_i][0], _box_array_r[_i][1], _x1, _y1 + _box_m_y, _x2, _y2 + _box_m_y, _box_array_r[_i][2]) // return: [_text, _b_sel]  de uma caixa espeficica
		
		/// Passar o texto obtido e se essa caixa está selecionada
		_box_array_r[_i][0] = _box_info[0]
		_box_array_r[_i][2] = _box_info[1]
	}
	
	/// Fazendo as variaveis do nome, idade e cidade recebam oque foi digitado
	nome = _box_array_r[0][0]
	idade = _box_array_r[1][0]
	if string_digits(idade) == "" or string_digits(idade) != idade {
		idade = 0
	}
	else {
		idade = int64(idade)
	}
	cidade = _box_array_r[2][0]
	
	// Se o botão de continuar foi acionado
	if button_action {
		// Removendo os espaços vazios
		var _n = string_replace_all(nome, " ", "")
		// Se é um nome válido (não nulo, sem caracteres especiais e sem números)
		if string_length(_n) > 0 and string_lettersdigits(_n) == _n and string_digits(_n) == "" {
			// Se é uma idade válida (se está entre 1 - 100 e se for um número inteiro)
			if idade > 1 and idade < 100 {
				// Se é um nome de cidade válido (não nulo, sem caracteres especiais e sem números)
				// Removendo os espaços vazios
				var _c = string_replace_all(cidade, " ", "")
				if string_length(_c) > 0 and string_lettersdigits(_c) == _c and string_digits(_c) == "" {
					// Indo para o método de criar o personagem
					r_table_atual = r_table_create_visual
						
					// Reseta para botão não acionado
					button_action = false
				}
				// Se é um nome de cidade inválido
				else {
					// Passo um feedback do erro cometido
					text_guide_desc = library_text.erro_cadastro_desc.cidade
			
					// Reseta a conf do texto da descrição
					reset_typist()
			
				    // Reseta para botão não acionado
					button_action = false
				}
			}
			// Se é uma idade inválida
			else {
				// Passo um feedback do erro cometido
				text_guide_desc = library_text.erro_cadastro_desc.idade
			
				// Reseta a conf do texto da descrição
				reset_typist()
			
			    // Reseta para botão não acionado
				button_action = false
			}
		} 
		// Se é um nome inválido
		else {
			// Passo um feedback do erro cometido
			text_guide_desc = library_text.erro_cadastro_desc.nome
			
			// Reseta a conf do texto da descrição
			reset_typist()
			
		    // Reseta para botão não acionado
			button_action = false
		}
	}
}

/// (before: r_table_registrar) O player cria seu personagem customizavel (next: rm_hub)
r_table_create_visual = function(_x1, _y1, _x2, _y2) {
	// Se a primeira vez que entro nesse método
	if r_table_atual_text != "create_visual" {
		// Garantindo que "data" vai está vazio para poder pegar o id
		data = -1
		
		/// Definindo o novo texto do guia, botão e resetando o contador de letras
		text_guide_title	= library_text.create_visual.title
		text_guide_desc		= library_text.create_visual.desc
		text_button_contine = library_text.create_visual.button
		
		cont_text_guide_title = 0
		
		// Reseta a conf do texto da descrição
		reset_typist()
		
		// Método que vai ser direcionado pelo botão de voltar
		return_m = r_table_registrar
		
		// Definindo o a string do método atual
		r_table_atual_text = "create_visual"
	}
	
	#region Criação de personagem
	//
	_y2 *= .98
	
	/// Criando as areas de customização	[array com as sprites, array rgb, label]
	static _cus_array = [[["spr_hair1", "spr_hair2", "spr_hair3", "spr_hair4", "spr_hair5"], [255, 255, 255], "Cabelo"], [["spr_head1", "spr_head2", "spr_head3", "spr_head4"], [255, 255, 255], "Cabeça"], 
	[["spr_body1", "spr_body2", "spr_body3", "spr_body4", "spr_body5", "spr_body6"], [255, 255, 255], "Corpo"], [["spr_leg1P", "spr_leg2P", "spr_leg3P"], [255, 255, 255], "Pernas"]]
	
	// Listas com a posição selecionada de cada parte /  pos selecionado atualmente
	static _array_pos = [0, 0, 0, 0]
	
	/// Criando uma area de customização para cada elemento no array de cima
	for (var _i = array_length(_array_pos) - 1; _i >= 0; _i--) {
		// Fazendo essas caixas de deslocarem uma da outra
		var _cus_m_y = (_y2 - _y1) * _i * 1.5
		
		// Recebendo as informações das caixas criadas
		var _cus_info = cus_creation(_x1, _x2 - _x1, _cus_m_y, _y2 - _y1, _cus_array[_i][0], _cus_array[_i][1], _cus_array[_i][2], _array_pos[_i], _i) // return: [a nova posição, [rgb]]
		
		/// Passa qual sprite atual está selecionada e rgb
		_array_pos[_i] = _cus_info[0]
		_cus_array[_i][1][0] = _cus_info[1][0]
		_cus_array[_i][1][1] = _cus_info[1][1]
		_cus_array[_i][1][2] = _cus_info[1][2]
	}
	
	#region Fazendo as variaveis da customização receberem as alterações
	spr_hair = _cus_array[0][0][_array_pos[0]]
	ha_r	 = _cus_array[0][1][0]
	ha_g	 = _cus_array[0][1][1]
	ha_b	 = _cus_array[0][1][2]

	spr_head = _cus_array[1][0][_array_pos[1]]
	he_r	 = _cus_array[1][1][0]
	he_g	 = _cus_array[1][1][1]
	he_b	 = _cus_array[1][1][2]

	spr_body = _cus_array[2][0][_array_pos[2]]
	bo_r	 = _cus_array[2][1][0]
	bo_g	 = _cus_array[2][1][1]
	bo_b	 = _cus_array[2][1][2]

	spr_leg	 = _cus_array[3][0][_array_pos[3]]
	le_r	 = _cus_array[3][1][0]
	le_g	 = _cus_array[3][1][1]
	le_b	 = _cus_array[3][1][2]
	#endregion
	#endregion

	// Se o botão de continuar foi acionado
	if button_action {
		// Verifica se os dados ainda não foram carregados
		if data == -1 {
			/// Feedback que o jogo está procurando no banco de dados, resetando a variavel do ultimo email e da resposta do db
			if text_guide_desc != library_text.create_visual.db_access {
				// Passo um feedback do erro cometido
				text_guide_desc = library_text.create_visual.db_access
			
				// Reseta a conf do texto da descrição
				reset_typist()
						
				// Passando os dados para o database
				set_data()
			}
		}
		// Caso os dados já tenham sido carregados
		else {
			if !passing_seq {
				passing_seq = true
				global.seq_run = true
				#region Deixando as conf do rgb como int
				ha_r = int64(ha_r)
				ha_g = int64(ha_g)
				ha_b = int64(ha_b)
		
				he_r = int64(he_r)
				he_g = int64(he_g)
				he_b = int64(he_b)
		
				bo_r = int64(bo_r)
				bo_g = int64(bo_g)
				bo_b = int64(bo_b)
		
				le_r = int64(le_r)
				le_g = int64(le_g)
				le_b = int64(le_b)
				#endregion
		
				// Deixando idade como int
				idade = int64(idade)
		
				// Reseta para botão não acionado
				button_action = false
			
				/// Criando o obj controle do hub e passando as informações necessarias
				var _hub = instance_create_layer(x, y, layer, obj_db_hub_control)
				_hub.id_player = data[0].id
				_hub.root = root
							
				/// Indo para a rm do hub
				// Passando qual a room o jogo deve direcionar
				global.next_room = rm_db_hub
							
				var _c_tra = instance_create_layer(0, 0, "Instances", obj_control_transition_rooms)
				with(_c_tra) {
					/// Passando os assets das sequencias de entrada e saida
					asset_seq_in  = seq_transcao_in
					asset_seq_out = seq_transcao_out
					/// Passando a posição de onde a câmera de começar na proxima sala
					global.next_room_posx = 0
					global.next_room_posy = 0
				
					// Indico se a proxima room vai ter o player ou não
					global.next_room_with_player = false
					// Indico se o player está na sala atual
					player_in_room = false
				
					// Acionando o método que cria a sequencia de saida
					exit_room()

					global.pause = false
				}
			}
		}
	}
}

// Desenha a interface de erro de conexão da rede
r_table_erro_net = function(_spr_recharge, _x, _y, _xscale, _yscale) {
	// Se a primeira vez que entro nesse método
	if r_table_atual_text != "erro_net" {
		/// Definindo o novo texto do guia, botão e resetando o contador de letras
		text_guide_title	= library_text.erro_net.title
		text_guide_desc		= library_text.erro_net.desc
		
		cont_text_guide_title = 0
		
		// Reseta a conf do texto da descrição
		reset_typist()
		
		// Definindo o a string do método atual
		r_table_atual_text = "erro_net"
	}
	
	// Variavel com o valor da rotação do icone
	static _rot = 0
	/// Aumentando o valor até 360°
	_rot -= 2.2
	_rot %= 360
	
	// Desenhando o icone da esperar da conexão na net
	draw_sprite_ext(_spr_recharge, 0, _x, _y, _xscale, _yscale, _rot, c_white, 1)
	
	/// Testar conexão
	test_net(3)
}

#endregion

#region Outros Métodos
// Método que vai ficar rodando se a conexão com a net estiver estabelecida, testa a conexão para ver se caiu
test_net = function(_seg) {
	/// Variaveis para controlar o timer
	//var _timer_conec_restart = _seg * game_speed
	static _timer_conec = _seg * game_speed
	
	// Passando o timer
	_timer_conec --
	
	// Se o timer zerou
	if _timer_conec < 1 {
		// Envia uma solicitação HTTP simples para um site confiável, PARA FAZER O TESTE DE CONEXÃO A NET
		http_request("http://www.google.com", "GET", 0, 0)
		
		// Reseta o timer
		_timer_conec = _seg * game_speed
	}
}

// Cria uma caixa de input
input_box = function(_text, _label, _x1, _y1, _x2, _y2, _b_sel, _hide_passw=undefined) {
	/// Variaveis de interação
	static _delete_timer = 0
	static _b_color = make_color_rgb(187, 187, 187)
	var _b_mouse = point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2)
	var _b_click = mouse_check_button_released(mb_left)
	
	
	#region Button hide password
	if _hide_passw != undefined {
		var _hide_spr = spr_db_eye
		var _hide_h = display_get_gui_height() * .02
		var _hide_w = _hide_h * (sprite_get_width(_hide_spr) / sprite_get_height(_hide_spr))
		var _hide_x = _x1 + (_x2 - _x1) + _hide_w / 2
		var _hide_y = _y1 + (_y2 - _y1) / 2 - (_hide_h / 2)
		
		var _hide_in_m = point_in_rectangle(mouse_x, mouse_y, _hide_x, _hide_y, _hide_x + _hide_w, _hide_y + _hide_h)
		if _hide_in_m and _b_click {
			if (_hide_passw) _hide_passw = false;
			else _hide_passw = true;
		}
		
		draw_set_alpha(1 - .2 * _hide_in_m)
		draw_sprite_stretched(_hide_spr, _hide_passw, _hide_x, _hide_y, _hide_w, _hide_h)
		draw_set_alpha(1)
	}
	#endregion
	
	// Sempre limita o recepitor do teclado ao ultimo caractere
	keyboard_string = string_char_at(keyboard_string, string_length(keyboard_string))
	
	// Se clicou como o mouse
	if _b_click {
		// Se o mouse está sobre o botão
		if _b_mouse {
			// Atribui esse botão como selecionado
			_b_sel = true
			
			// Ao selecionar um botão, reseta as caractes obtidas pelo teclado
			keyboard_string = ""
		}
		// Se o mouse NÃO está sobre o botão
		else {
			// Atribui esse botão como NÃO selecionado
			_b_sel = false	
		}
	}
	
	// Se o botão está selecionado
	if _b_sel {
		#region Interaction From Input Box (recebe strings do teclado e também as apaga)
		// Se apertei qualquer tecla e o texto tem menos de 60 caracteres
		if string_length(_text) < 60 and keyboard_check(vk_anykey) {
			// Somo o ultimo caractere digitado com o texto atual
			_text += string(keyboard_string)
			
			// Reseto o recepitor do teclado
			keyboard_string = ""
		}
		
		// Se segurei o botão de apagar
		if keyboard_check(vk_backspace) and !keyboard_check_pressed(vk_backspace) and _delete_timer == 2 {
			// Apagando o ultimo caractere
			_text = string_delete(_text, string_length(_text), 1)
			
			//
			_delete_timer = 0
			
			// Reseto o recepitor do teclado
			keyboard_string = ""
		}
		
		// Se apertei o botão de apagar
		if keyboard_check_pressed(vk_backspace) {
			// Apagando o ultimo caractere
			_text = string_delete(_text, string_length(_text), 1)
			
			// Reseto o recepitor do teclado
			keyboard_string = ""
			
			//
			_delete_timer = -4
		}

		// Handle Timer Update
		if _delete_timer != 2 {
			_delete_timer ++
		}
		#endregion
		
		// Cor do botão ao está selecionado
		_b_color = make_color_rgb(172, 172, 201)
	}
	// Se o botão NÃO está selecionado
	else {
		// Defini a cor de volta para o botão não selecionado
		_b_color = make_color_rgb(187, 187, 187)
	}
	
	#region Texto
	/// Desenho da caixa de fundo
	draw_set_alpha(1 - (.25 * _b_mouse))
	draw_roundrect_color(_x1, _y1, _x2, _y2, _b_color, _b_color, false)
	draw_set_alpha(1)
	
	/// Texto do botão
	draw_set_halign(1)
	draw_set_valign(1)
	
	#region Prende o texto dentro da caixa
	// Variavel que guarda o texto visivel na caixa
	var _text_visi = ""
	// Número maximo de caracteres mostrados na caixa
	static _max_length = string_width("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
	
	// Índice de deslocamento
	var _des = 0
	
	// Ajusta o deslocamento até que o texto visível caiba na largura máxima
	while (_des < string_length(_text)) {
	    // Extrai a parte visível do texto
	    _text_visi = string_copy(_text, _des + 1, string_length(_text) - _des);
    
	    // Se a largura do texto atual for menor ou igual à largura permitida, saímos do loop
	    if (string_width(_text_visi) <= _max_length) {
			// Sai do while
	        break
	    }

	    // Aumenta o deslocamento para esconder o primeiro caractere
	    _des += 1
	}
	
	#endregion
	
	if _hide_passw {
		var _text_hide = ""
		for (var i = 0; i < string_length_scribble(_text_visi); ++i) {
		    _text_hide += "*"
		}
		
		draw_text_scribble(_x1 + (_x2 - _x1) / 2, _y1 + (_y2 - _y1) / 1.8, "[fnt_db][scale,1]" + _text_hide)
	}
	else draw_text_scribble(_x1 + (_x2 - _x1) / 2, _y1 + (_y2 - _y1) / 2, "[fnt_db][scale,1]" + _text_visi);
	
	draw_set_halign(-1)
	draw_set_valign(-1)
	draw_roundrect_color(_x1, _y1, _x2, _y2, c_black, c_black, true)
	
	// Label
	draw_text_scribble(_x1 + (_x2 - _x1) * .1, _y1 - (_y2 - _y1) / 4, "[scale,.8][fnt_db][c_black]" + _label)
	
	#endregion
	
	/// Retorna o texto alterado pelo usuario e se esse botão está selecionado
	return [_text, _b_sel, _hide_passw]
}

// Cria um local de customização
cus_creation = function(_x, _w, _y, _h, _array_spr, _array_rgb, _label, _pos, _idx) {
	#region Variaveis
	static _middle = _x + _w / 2
	var _spr = asset_get_index(_array_spr[_pos])
	var _spr_w = sprite_get_width(_spr)
	var _spr_h = sprite_get_height(_spr)
	var _draw_w = room_width * .1
	var _draw_h = _draw_w * (_spr_w / _spr_h)
	var _draw_x = _middle - _draw_w / 2
	var _draw_y = room_height * .08
	var _col = make_color_rgb(_array_rgb[0], _array_rgb[1], _array_rgb[2])
	var _div_y = (_draw_y + _draw_h) * 1.1
	
	var _y_pos = _y + _div_y
	
	var _box_w = _w * .08
	var _box_h = _box_w
	var _box_m_h = (_h - _box_h) / 2
	
	static _space = _w * .1
	#endregion
	
	static _idx_save = -1
	
	/// Desenho de uma parte do player com as configurações atuais
	draw_sprite_stretched_ext(_spr, 0, _draw_x, _draw_y, _draw_w, _draw_h, _col, 1) // AJEITAR A COR
	
	// DEBUG ESPAÇO
	//draw_rectangle_color(_x, _y_pos, _x + _w, _y_pos + _h, c_black, c_black, c_black, c_black, true)
	
	#region Desenho e interração das coisas
	#region Interração com os botões a seguir
	var _sel_left = false
	var _sel_right = false
	// Left
	if point_in_rectangle(mouse_x, mouse_y, _x, _y_pos + _box_m_h, _x + _box_w, _y_pos + _h - _box_m_h) {
		_sel_left = true
		
		//
		if mouse_check_button_released(mb_left) {
			_pos --
			_pos = clamp(_pos, 0, array_length(_array_spr) - 1)
		}
	}
	// Right
	if point_in_rectangle(mouse_x, mouse_y, _x + _box_w * 2.35 + _space, _y_pos + _box_m_h, _x + _box_w + _box_w * 2.35 + _space, _y_pos + _h - _box_m_h) {
		_sel_right = true
		
		//
		if mouse_check_button_released(mb_left) {
			_pos ++
			_pos = clamp(_pos, 0, array_length(_array_spr) - 1)
		}
	}
	#endregion
	
	/// Caixas de left and right com setas
	// Left
	draw_set_alpha(1 - (.2 * _sel_left))
	draw_sprite_stretched(spr_db_button_cus, 0, _x, _y_pos + _box_m_h, _box_w, _h - _box_m_h * 2)
	draw_set_alpha(1)
	// Label
	draw_text_scribble(_x + _box_w * 2.35, _y_pos + _box_h / 2 + _box_m_h, "[fa_center][fa_middle][c_black][scale,1][fnt_db]" + _label)
	// Right
	draw_set_alpha(1 - (.2 * _sel_right))
	draw_sprite_stretched(spr_db_button_cus, 1, _x + _box_w * 2.35 + _space, _y_pos + _box_m_h, _box_w, _h - _box_m_h * 2)
	draw_set_alpha(1)
	
	#region Alteração das cores
	static _rgb_label = [["R", c_red], ["G", c_green], ["B", c_blue]]
	static _pos_b_min = _x + _w * .5
	static _pos_b_max = _x + _w - _space
	static _pos_b_w = _pos_b_max - _pos_b_min
	
	static _pos_b_sel = false
	static _pos_b_i = -1
	
	//
	for (var _i = 0; _i < array_length(_array_rgb); _i++) {
	    // Deslocamento do y
	    var _des_y = (_box_m_h * 2.1) * _i
    
	    // Label
	    draw_text_scribble(_x + _w * .5 - _space / 2, _y_pos + _box_m_h * .20 + _des_y, "[fa_center][fa_middle][c_black][scale,.85][fnt_db]" + _rgb_label[_i][0])
    
	    // Linha de limite
	    draw_rectangle_color(_pos_b_max, _y_pos + _des_y, _pos_b_min, _y_pos + (_box_m_h * .4) + _des_y, c_black, _rgb_label[_i][1], _rgb_label[_i][1], c_black, false)
    
	    // Cálculo correto da posição do slider
	    var _pos_b_des = _array_rgb[_i] / 255
	    var _pos_b_atual = _pos_b_min + (_pos_b_w * _pos_b_des)

	    /// Detectar clique na bolinha
	    var _bolinha_x = _pos_b_atual
	    var _bolinha_y = _y_pos + _box_m_h * .20 + _des_y

	    if point_in_circle(mouse_x, mouse_y, _bolinha_x, _bolinha_y, _box_m_h * .95) {
	        if mouse_check_button_pressed(mb_left) {
				_pos_b_sel = true
				_pos_b_i = _i
				_idx_save = _idx
	        }
	    }
		
		if _pos_b_sel and _i == _pos_b_i and _idx_save == _idx {
			var _novo_valor = clamp((mouse_x - _pos_b_min) / _pos_b_w, 0, 1)
	            _array_rgb[_i] = _novo_valor * 255
			
			if !mouse_check_button(mb_left) {
				_pos_b_sel = false
				_pos_b_i = -1
				_idx_save = -1
			}
		}

	    // Desenhar bolinha do slider
	    draw_circle_color(_bolinha_x, _bolinha_y, _box_m_h * .8, c_black, c_black, false)
	}
	#endregion
	#endregion
	
	/// Retorna a posição atual dessa parte do corpo e a lista do rgb dessa parte atualizado
	return [_pos, _array_rgb]
}

// Método de reset das caracteristica da escrita da descrição
reset_typist = function() {
	typist = scribble_typist()
	typist.in(0.1, 3)
	typist.ease(SCRIBBLE_EASE.CIRC, 50, -string_height("I") * 15, 10, 10, 180, 1)
}

// Método usado no botão de "voltar"
return_method = function () {
	r_table_atual = return_m
}

// Método usado no botão de "Sair"
back_menu = function() {
	//
	if !instance_exists(obj_control_transition_rooms) {
		// Passando qual a room o jogo deve direcionar
		global.next_room = rm_link_site_ifrn
	
		//
		window_set_cursor(cr_none)
	
		///
		if (instance_exists(obj_int_control)) instance_destroy(obj_int_control);
	
		/// Aciono o obj de transição
		var _c_tra = instance_create_layer(0, 0, "Instances", obj_control_transition_rooms)
		with(_c_tra) {
			/// Passando os assets das sequencias de entrada e saida
			asset_seq_in  = seq_transcao_in
			asset_seq_out = seq_transcao_out
			/// Passando a posição de onde a câmera de começar na proxima sala
			global.next_room_posx = 0
			global.next_room_posy = 0
				
			// Indico se a proxima room vai ter o player ou não
			global.next_room_with_player = false
			
			// 
			next_with_mouse = true
			// Indico se o player está na sala atual
			player_in_room = false
				
			// Acionando o método que cria a sequencia de saida
			exit_room()

			global.pause = false
		}
	}
}

// Envia os dados para o database
set_data = function() {
	/// Cria um ds_map para pegar as informações do player
	var _doc = ds_map_create()
	// Pegando o email
	_doc[? "email"]  = email
	// Pegando a senha
	_doc[? "senha"]  = senha
	// Pegando o nome
	_doc[? "nome"]   = nome
	// Pegando a idade
	_doc[? "idade"]  = idade
	// Pegando a cidade
	_doc[? "cidade"] = cidade
	
	/// Passando os cursos completos nesse save
	var _c_info = "c_info"
	var _c_manu = "c_manu"
	var _c_agro = "c_agro"
	var _c_quimic = "c_quimic"
	_doc[? _c_info] = (_c_info == c_what_course)
	_doc[? _c_manu] = (_c_manu == c_what_course)
	_doc[? _c_agro] = (_c_agro == c_what_course)
	_doc[? _c_quimic]  = (_c_quimic == c_what_course)
	
	/// Passando as caracteristicas visuais do personagem
	_doc[? "spr_hair"] = spr_hair // Nome da id sprite
	_doc[? "ha_r"] = round(ha_r)
	_doc[? "ha_g"] = round(ha_g)
	_doc[? "ha_b"] = round(ha_b)
	
	_doc[? "spr_head"] = spr_head // Nome da id sprite
	_doc[? "he_r"] = round(he_r)
	_doc[? "he_g"] = round(he_g)
	_doc[? "he_b"] = round(he_b)
	
	_doc[? "spr_body"] = spr_body // Nome da id sprite
	_doc[? "bo_r"] = round(bo_r)
	_doc[? "bo_g"] = round(bo_g)
	_doc[? "bo_b"] = round(bo_b)
	
	_doc[? "spr_leg"] = spr_leg  // Nome da id sprite
	_doc[? "le_r"] = round(le_r)
	_doc[? "le_g"] = round(le_g)
	_doc[? "le_b"] = round(le_b)
	

	// Envia o documento JSON criado para o Firebase.
	FirebaseFirestore(root).Set(_doc)

	/// Apagando o ds_map
	ds_map_clear(_doc)
	ds_map_destroy(_doc)
}

//
set_data_login = function() {
	/// Cria um ds_map para pegar as informações do player
	var _doc = ds_map_create()
	
	// Passando os cursos completos nesse save
	_doc[? c_what_course] = true
	
	// Envia o documento JSON criado para o Firebase.
	FirebaseFirestore(root + "/" + id_in_login).Update(_doc)
	
	/// Apagando o ds_map
	ds_map_clear(_doc)
	ds_map_destroy(_doc)
}

// Retorna o ID do usuario, usando o email
get_user_id = function(_email) {
	
}
#endregion
#endregion

// Defifinindo o método atual da tabela da direita (defart: Opening)
r_table_atual = r_table_opening
// Variavel para guardar o "texto" do método atual (só tem o proposito de variavel de controlw dentro dos métodos das tabelas)
r_table_atual_text = ""		// "opening", "registrar", "create_visual" e "erro_net"
// Variavel para saber qual método devo ir ao aperta o botão de continuar
r_table_next = r_table_opening


// Quando a sala é carregada, já faz logo um teste de conexão na net
test_net(.2)

//
passing_seq = false
