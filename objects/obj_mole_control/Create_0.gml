/// Criando o tutorial
if !global.tu_pass_mole {
	global.tu_pass_mole = true
	
	var _tu = instance_create_layer(0, 0, "Instances", obj_tutorial)
	with (_tu) {
		tutorial_imgs = [spr_mole_tutorial1, spr_mole_tutorial2, spr_mole_tutorial3, spr_mole_tutorial4, spr_mole_tutorial5]
		tutorial_string = ["Conclua as listas de elementos e moléculas a direita da tela, selecionando um item da lista com o mouse (se ele estiver desbloqueado) você poderá ver algumas de suas características.",
		"Embaixo terá 3 recipientes com as menores matérias do universo: prótons (+), nêutrons (n) e  eletrons (-). A esquerda embaixo tem um botão de reset para limpar o ambiente, voltando tudo aos recipientes.",
		"No meio da tela, encontrasse no meio para fazer os processos, o quadrado na esquerda é o espaço de entrada e o círculo na direita é o espaço de saída, você pode arrastar todas as matérias na tela para esses espaços e usar 3 botões.",
		"O primeiro botão é o de juntar, coloque os materiais no quadrado e se tiver algo exato com aquela composicão, será criado dentro do círculo, o segundo separa UMA matéria dentro do circulo em seus componentes e o terceiro cria a matéria que estiver selecionada na lista se os matériais estiverem na tela.",
		"No canto superior esquerdo terá um ícone de lâmpada, vocé pode aciona-lo para mostrar um guia da próxima criação que deve ser feita."]
		
		tutorial_length = array_length(tutorial_imgs) - 1
	}
}



/// Listas ds dos elementos e moleculas (cada coordenada vai ter suas caracteristicas)
// Como vão ser acessadas posteriormente, 
grid_element  = ds_grid_create(4, 2)
grid_molecule = ds_grid_create(4, 2)

///  [desbloqueado, spr_icon, texto da descrição]
ds_grid_clear(grid_element, [false, spr_mole_interogation, ""])
ds_grid_clear(grid_molecule, [false, spr_mole_interogation, ""])

// Para saber qual caixa das grids o mouse apertou por ultimo ("-1" nas coordenadas caso não tenha ninguem selecionado)
grid_posxy_click = [-1, -1, grid_element]

// Saber se o mouse está tocando nós botões (porta de comunicação entre os 2 métodos do draw)
button_dupli_sel = false

// Contador de quantas materias foram pega dentro de uma área
cont_get = 0

/// Ds_map para guadar as informações do que está dentro do input/output (procurar a função que dar um defart num ds_map)
ma_cont = ds_map_create()
#region Conta quanto de cada tipo de materia foi pego na area testada
ma_cont[? "proton"]	    = 0
ma_cont[? "neutron"]	= 0
ma_cont[? "eletron"]	= 0
/////
ma_cont[? "hidrogenio"] = 0
ma_cont[? "helio"]	    = 0
ma_cont[? "litio"]	    = 0
ma_cont[? "berilio"]	= 0
ma_cont[? "boro"]	    = 0
ma_cont[? "carbono"]	= 0
ma_cont[? "nitrogenio"] = 0
ma_cont[? "oxigenio"]   = 0
/////
ma_cont[? "h2"]		    = 0
ma_cont[? "h2o"]	    = 0
ma_cont[? "ch4"]	    = 0
ma_cont[? "nh3"]	    = 0
ma_cont[? "nh4"]	    = 0
ma_cont[? "li2"]	    = 0
ma_cont[? "lih"]	    = 0
ma_cont[? "beh2"]	    = 0
#endregion

/// Ds_map com o sprite correspondente ao tipo
ma_spr = ds_map_create()
#region Sprite correspondente ao tipo
ma_spr[? "proton"]	   = spr_mole_proton
ma_spr[? "neutron"]	   = spr_mole_neutron
ma_spr[? "eletron"]	   = spr_mole_eletron
/////
ma_spr[? "hidrogenio"] = spr_mole_hidrogenio
ma_spr[? "helio"]	   = spr_mole_helio
ma_spr[? "litio"]	   = spr_mole_litio
ma_spr[? "berilio"]	   = spr_mole_berilio
ma_spr[? "boro"]	   = spr_mole_boro
ma_spr[? "carbono"]	   = spr_mole_carbono
ma_spr[? "nitrogenio"] = spr_mole_nitrogenio
ma_spr[? "oxigenio"]   = spr_mole_oxigenio
/////
ma_spr[? "h2"]		   = spr_mole_h2
ma_spr[? "h2o"]		   = spr_mole_h2o
ma_spr[? "ch4"]		   = spr_mole_ch4
ma_spr[? "nh3"]		   = spr_mole_nh3
ma_spr[? "nh4"]		   = spr_mole_nh4
ma_spr[? "li2"]		   = spr_mole_li2
ma_spr[? "lih"]		   = spr_mole_lih
ma_spr[? "beh2"]	   = spr_mole_beh2
#endregion

/// Ds_map com as receitas das materias
ma_receitas = ds_map_create()
#region Receitas de quantas materias de cada tipo formam cada elemento e cada molecula [pro, neu, ele]
ma_receitas[? "hidrogenio"] = [[1, "proton"], [1, "neutron"], [1, "eletron"]]
ma_receitas[? "helio"]		= [[2, "proton"], [2, "neutron"], [2, "eletron"]]
ma_receitas[? "litio"]		= [[3, "proton"], [3, "neutron"], [3, "eletron"]]
ma_receitas[? "berilio"]	= [[4, "proton"], [4, "neutron"], [4, "eletron"]]
ma_receitas[? "boro"]		= [[5, "proton"], [5, "neutron"], [5, "eletron"]]
ma_receitas[? "carbono"]	= [[6, "proton"], [6, "neutron"], [6, "eletron"]]
ma_receitas[? "nitrogenio"] = [[7, "proton"], [7, "neutron"], [7, "eletron"]]
ma_receitas[? "oxigenio"]	= [[8, "proton"], [8, "neutron"], [8, "eletron"]]
/////		Lógica: lista com lista que tem a quantidade e depois o elemento
ma_receitas[? "h2"]			= [[2, "hidrogenio"]]
ma_receitas[? "h2o"]		= [[2, "hidrogenio"], [1, "oxigenio"]]
ma_receitas[? "ch4"]		= [[1, "carbono"],	  [4, "hidrogenio"]]
ma_receitas[? "nh3"]		= [[1, "nitrogenio"], [3, "hidrogenio"]]
ma_receitas[? "nh4"]		= [[1, "nitrogenio"], [4, "hidrogenio"]]
ma_receitas[? "li2"]		= [[2, "litio"]]
ma_receitas[? "lih"]		= [[1, "litio"],	  [1, "hidrogenio"]]
ma_receitas[? "beh2"]		= [[1, "berilio"],	  [2, "hidrogenio"]]
#endregion

/// Ds_map com as informações para conectar com os grid
ma_grid = ds_map_create()
#region Informações: [ds_grid, xpos, ypos, texto da descrição]
ma_grid[? "hidrogenio"] = [grid_element, 0, 0, "Hidrogênio - O elemento mais leve e abundante do universo! Ele é o combustível das estrelas e essencial para a vida na Terra."]
ma_grid[? "helio"]		= [grid_element, 1, 0, "Hélio - Um gás nobre que não reage com quase nada. Ele é usado em balões porque é mais leve que o ar e não explode como o hidrogênio."]
ma_grid[? "litio"]		= [grid_element, 2, 0, "Lítio - Um metal superleve que pode flutuar na água! Ele é usado em baterias recarregáveis, como as de celulares."]
ma_grid[? "berilio"]	= [grid_element, 3, 0, "Berílio - Um metal raro e superduro, usado em aviões e naves espaciais por ser leve e resistente."]
ma_grid[? "boro"]		= [grid_element, 0, 1, "Boro - Um elemento discreto, mas essencial! Ele fortalece vidros especiais e é importante para plantas crescerem saudáveis. E um elemento escasso tanto no sistema solar quanto na crosta terrestre."]
ma_grid[? "carbono"]	= [grid_element, 1, 1, "Carbono - O elemento da vida! Ele forma desde carvão e diamantes até o DNA e tudo que é vivo."]
ma_grid[? "nitrogenio"] = [grid_element, 2, 1, "Nitrogênio - Esse gás compõe 78% do ar que respiramos! Ele é essencial para proteínas e fertilizantes."]
ma_grid[? "oxigenio"]	= [grid_element, 3, 1, "Oxigênio - Sem ele, não existiria fogo nem respiração! Ele forma 21% do ar e é essencial para a vida na Terra."]
/////
ma_grid[? "h2"]			= [grid_molecule, 0, 0, "Gás Hidrogênio - Dois átomos de hidrogênio se unem para formar um gás altamente inflamável. É usado como combustível e foi o responsável pela explosão do Hindenburg!"]
ma_grid[? "h2o"]		= [grid_molecule, 1, 0, "Água - A molécula da vida! Formada por dois hidrogênios e um oxigênio, cobre 70% da Terra e é essencial para todos os seres vivos."]
ma_grid[? "ch4"]		= [grid_molecule, 2, 0, "Metano - Um gás inflamável produzido por vulcões e até por vacas! É um dos principais componentes do gás natural."]
ma_grid[? "nh3"]		= [grid_molecule, 3, 0, "Amônia - Um gás de cheiro forte usado em produtos de limpeza e na fabricação de fertilizantes."]
ma_grid[? "nh4"]		= [grid_molecule, 0, 1, "Íon Amônio - Uma versão carregada da amônia, muito usada como fertilizante para plantas."]
ma_grid[? "li2"]		= [grid_molecule, 1, 1, "Diliteto de Lítio - Um composto raro de lítio que não é muito estável e reage fácil com a água."]
ma_grid[? "lih"]		= [grid_molecule, 2, 1, "Hidreto de Lítio - Um sólido branco usado para armazenar hidrogênio em reações químicas."]
ma_grid[? "beh2"]		= [grid_molecule, 3, 1, "Hidreto de Berílio - Uma substância reativa que pode liberar hidrogênio quando aquecida."]
#endregion

// Porcentagem de divisão da tela (main - tabelas de elementos e moleculas)
div_tela = .775

// Metodo dos elementos visuais do draw (Fazer as colisões com os componentes aqui)
elements_draw = function() {
	/// Tamanho do espaço que será usado para o draw
	static _draw_w = room_width * div_tela // 77.5% da largura da tela
	static _draw_h = room_height
	
	/// Margem do espaço que deve ser pulado do tamanho dessa parte
	static _draw_margem_left  = _draw_w * .2
	static _draw_margem_right = _draw_w - _draw_w * .14
	//draw_point(_draw_margem_left, 100)
	//draw_point(_draw_margem_right, 100)
	
	// A sprite da seta
	static _spr_seta  = spr_mole_seta
	static _spr_botao = spr_mole_caixinha
	

	#region Desenhos dos input e output do mecanismo de trasformação
	#region Variaveis do posicionamento, tamanho e cor do input/output e seta (figure e seta)
	/// Coordenadas da figura 1 (quadrado)
	static _figure_x1		= _draw_w * .2
	static _figure_x2		= _figure_x1 + _draw_w * .18
	static _figure_y1		= _draw_h * .35
	static _figure_y2		= _figure_y1 + _draw_w * .18
	
	/// Tamanhos da seta
	static _spr_seta_w		= sprite_get_width(_spr_seta)
	static _spr_seta_h		= sprite_get_height(_spr_seta)
	static _seta_w			= _draw_w * .12							// Usar esses
	static _seta_h			= _seta_w * (_spr_seta_h / _spr_seta_w) // Usar esses
	
	/// Coordenadas da figura 2 (circulo)
	static _figure2_r		= _draw_w * .1								 // Tamanho do raio
	static _figure2_x		= _draw_margem_right - _figure2_r / 2
	static _figure2_y		= _figure_y1 + (_figure_y2 - _figure_y1) / 2 // Também usado no Y da seta
	
	// Espaço entre a figura 1 e 2
	static _figure_spacing = _figure2_x - _figure_x2
	
	// Cor usada na figura 1
	var _color			= make_color_rgb(143, 140, 164)
	
	// Posição X da seta
	static _seta_x = _figure_x2 + _figure_spacing / 2 - _seta_w / 2 - _figure2_r / 2
	
	/// Tamanho dos 3 botões
	static _botao_w = (_seta_w) / 2.5
	#endregion

	/// Desenhando o input (retangulo)
	draw_roundrect_color(_figure_x1, _figure_y1, _figure_x2, _figure_y2, c_black, c_black, false)
	draw_roundrect_color(_figure_x1+2, _figure_y1+2, _figure_x2-2, _figure_y2-2, _color, _color, false)
	
	/// Desenho da seta do transformador
	_color = c_yellow
	draw_sprite_stretched_ext(_spr_seta, 0, _seta_x, _figure2_y - _seta_h / 1, _seta_w, _seta_h, _color, 1) // Ver como fazer o y ficar sempre no meio
	
	#region Criação dos botões do meio e seus metodos
	
	#region Metodos usados nos botões
	// Saber se uma materia está no input (retorna uma lista com todas as instancias)
	///@function materials_in_area(x_ori, y_ori, obj, radius, input[1]-output[2])
	static _materials_in_area = function(_x, _y, _obj, _radius, _tipo) {
		// Número de instancias do obj
		var _num = instance_number(_obj)
		// Lista com todas as instancias do obj
		var _list = []
		// Lista com as instancias dentro do input
		var _return_list = []


		/// Primeiro, faça uma lista de todas as instâncias de um determinado obj
		for (var _i = 0; _i < _num; _i++ ) {
			// Inserindo cada instancia nessa lista
		    _list[_i] = instance_find(_obj, _i)
		}

		// Em seguida, desativar todas as instâncias fora do raio indicado ou adiciona na lista de retorno as que tiverem dentro
		for (var _i = 0; _i < _num; _i++ ) {
			// Se é uma instancia valida
			if _list[_i] {
				// Testa a area quadrada do input
				if _tipo == 1 {
					// Se está fora do espaço
				    if (_list[_i].x - _x > _radius or _list[_i].y - _y > _radius) or (_list[_i].x <= _x or _list[_i].y <= _y) {
						// Desativando a instancia
				        instance_deactivate_object(_list[_i])
					}
					// Se está dentro do espaço
					else {
						// Inserindo ela na lista de retorno
						array_push(_return_list, _list[_i])
					}
				}
				// Testa a area circular do output
				if _tipo == 2 {
					// Se está fora do espaço
					if point_distance(_list[_i].x, _list[_i].y, _x, _y) > _radius {
						// Desativando a instancia
				        instance_deactivate_object(_list[_i])
					}
					// Se está dentro do espaço
					else {
						// Inserindo ela na lista de retorno
						array_push(_return_list, _list[_i])
					}
				}
			}
		}

		// Por fim, ative todas as instâncias que acabámos de desativar.
		instance_activate_object(_obj);
	
		// E devolve a lista
		return _return_list
	}

	
	// Botão de juntar
	static _button_run = function(_x, _y, _radius, _get_inst) {
		// Colocando em uma lista todas as instancias da materia que estão dentro do input
		var _list = _get_inst(_x, _y, obj_mole_materia, _radius, 1)
		// Número de quantas instancias estão na lista
		var _length = array_length(_list)
		
		/// Conta quanto tem de cada coisa dentro da lista para o ds_map do contador
		for (var _i = 0; _i < _length; _i ++) {
			ma_cont[? _list[_i].tipo] ++
			cont_get++
			
			// Marcando as instancias do obj materia dentro do input
			_list[_i].death = true
		}
	}
	
	// Botão de separar
	static _button_back = function(_x, _y, _radius, _get_inst) {
		// Colocando em uma lista todas as instancias da materia que estão dentro do input
		var _list = _get_inst(_x, _y, obj_mole_materia, _radius, 2)
		// Número de quantas instancias estão na lista
		var _length = array_length(_list)
		
		/// Conta quanto tem de cada coisa dentro da lista para o ds_map do contador
		for (var _i = 0; _i < _length; _i ++) {
			
			ma_cont[? _list[_i].tipo] ++
			
			//
			cont_get++
			
			// Marcando as instancias do obj materia dentro do input
			_list[_i].death = true
		}
	}
	
	// Botão de repetir a ultima junção se possivel
	static _button_dupli = function(_x, _y, _radius, _get_inst, _name_ma) {
		#region Cópia da lista da receita da materia que precisa ser duplicada
		// Criar um novo array vazio para armazenar a cópia
		var _list_re = [];

		// Pegar o array original da ds_map
		var _original = ma_receitas[? _name_ma];

		// Copiar cada elemento individualmente para garantir independência
		for (var i = 0; i < array_length(_original); ++i) {
			// Criar nova sub-lista
		    _list_re[i] = array_create(array_length(_original[i]))

		    /// Copiar os elementos internos (cópia profunda)
		    for (var j = 0; j < array_length(_original[i]); ++j) {
		        _list_re[i][j] = _original[i][j];
		    }
		}
		#endregion
		
		// Colocando em uma lista todas as instancias da materia que estão dentro do input
		var _list_inst = _get_inst(_x, _y, obj_mole_materia, _radius, 1)
		// Número de quantas instancias estão na lista
		var _length = array_length(_list_inst)
		
		/// Conta quanto tem de cada coisa dentro da lista para o ds_map do contador
		for (var _i = 0; _i < _length; _i ++) {
			ma_cont[? _list_inst[_i].tipo] ++
			cont_get++
		}
		
		// Andando por cada instancia
		for (var i = 0; i < _length; ++i) {
		    // Andando por cada parte da receita
			for (var r = 0; r < array_length(_list_re); ++r) {
			    // Se a quantidade de ingredientes dessa parte da receita for maior do que zero
				if _list_re[r][0] > 0 {
					// Se o ingrediente dessa parte da receita é do mesmo tipo que a instancia da materia atual
					if _list_re[r][1] == _list_inst[i].tipo {
						// Marcando a instancia do obj materia
						_list_inst[i].death = true
						
						// Subtraindo em 1 a quantidade desse ingrediente
						_list_re[r][0] --
						
						// Quebrando o for que anda pelas partes da receita pq uma instancia só pode subtrair uma vez a quantidade
						break
					}
				}
			}
		}
		
		/// Confirmando se temos todos os ingredientes da receita
		var _cont_conf = 0
		for (var r = 0; r < array_length(_list_re); ++r) {
			if _list_re[r][0] == 0 {
				_cont_conf++
			}
		}
		
		// Se todas as partes da receita estão completas
		if _cont_conf == array_length(_list_re) {
			// Retorna que pode criar a materia
			return true
		}
		
		/// Se chegou até aqui que dizer que nem todos os valores de quantidade da receita chegaram a zero
		// Resetando a marca
		obj_mole_materia.death = false
		/// Resetando o map do contador
		var _keys_cont = ds_map_keys_to_array(ma_cont)
		for (var _i = 0; _i < array_length(_keys_cont); _i++) {
			ma_cont[? _keys_cont[_i]] = 0
		}
		// Retorna que NÃO pode criar a materia 
		return false
	}
	
	
	// Lista com os metodos dos
	static _methods_buttons = [_button_run, _button_back, _button_dupli]
	#endregion
	
	// Contador de botões criados
	var _cont = 0
	
	// Lista com os icones dos botoes
	static _spr_icones = [spr_mole_run, spr_mole_back, spr_mole_dupli]
	
	/// Fazendo os 3 botões abaixo da seta
	repeat(3) {
		// Espaçamento (no meio entre a fig 1 e a seta, até entre a seta e a fig 2, tudo isso dividido pelo número de botões)
		static _x1_margem = (_seta_x - _figure_x2) / 2 - _botao_w / 2
		static _space = ( _figure2_x - _figure2_r - _figure_x2 ) / 3
		
		/// Posições
		var	   _x1 = _figure_x2 + _x1_margem + (_space * _cont) + 2 // "2" pixel entre o espaço livre e a origem da fig 1 e 2
		static _y1 = _figure_y2 - _botao_w
		
		// Usada para indicar se o mouse está nesse item especifico e se não tem nenhuma materia tocando no botão
		var _selecionado = point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x1 + _botao_w, _y1 + _botao_w) and !collision_rectangle(_x1, _y1, _x1 + _botao_w, _y1 + _botao_w, obj_mole_materia, false, true)
		button_dupli_sel = _selecionado
		
		/// Assionando o metodo do botão ao clicar
		if _selecionado and !(global.pause or instance_exists(obj_tutorial)) {
			if mouse_check_button_released(mb_left) {
				// Para saber se os maps da receita e do contador são iguais
				var _equal = noone
				
				/// Usando o metodo do botão apertado
				switch (_cont) {
					// Run
					case 0:
						// Som
						play_sound_geral(snd_mole_run)
					
						// Botando no map de cont quanto tem de cada coisa
						_methods_buttons[_cont](_figure_x1, _figure_y1, _figure_x2 - _figure_x1, _materials_in_area)
						
						// Keys da map das receitas
						static _keys_re = ds_map_keys_to_array(ma_receitas)
						
						// Andando por todas as chaves do map das receitas
						for (var _i = 0; _i < array_length(_keys_re); _i ++) {
							// Variavel para contar quantas o número de materia testada
							var _cont_get_equal = 0
							
							// Lista da receita atual
							var _list_rec_atual = ma_receitas[? _keys_re[_i]]
							
							// Andando por cada lista contendo a quantidade e o nome de cada ingrediente
							for (var _ele = 0; _ele < array_length(_list_rec_atual); _ele ++) {
								/// Pegando o nome e a quantidade de cada ingrediente da receita
								var _name = _list_rec_atual[_ele][1]
								var _counter = _list_rec_atual[_ele][0]
								
								// Vai somando o número de cada tipo de materia criada
								_cont_get_equal += _counter
								
							    // Se algum valor da receita for diferente do que foi pego dentro da zona
								if _counter != ma_cont[? _name] {
									// Impedindo que chegue no teste final
									break
								}
								
								// Se todos os ingredientes de uma receita estão ok (já que o codigo consegui chegar aqui no ultimo loop)
								if _ele == array_length(_list_rec_atual) - 1 {
									// Passando o nome do composto formado
									_equal[0] = [1, _keys_re[_i]]
									
									// Se a quantidade de materia pega é diferente da pega da receita
									if cont_get != _cont_get_equal {
										// Cancela a criação
										_equal = noone
									}
								}
							}
						}
					break
					
					// Back
					case 1:
						// Som
						play_sound_geral(snd_mole_back)
					
						// Botando no map de cont quanto tem de cada coisa
						_methods_buttons[_cont](_figure2_x, _figure2_y, _figure2_r, _materials_in_area)
						
						/// Listas das chaves e valores do map das materia dentro do output
						var _array_keys = ds_map_keys_to_array(ma_cont)
						var _array_values = ds_map_values_to_array(ma_cont)
						
						// Passando por cada chave do map do contador
						for (var i = 0; i < array_length(_array_keys); i++) {
							// Se a quantidade dessa materia é 1
						    if _array_values[i] == 1 {
								// Vai guadar o nome da materia que estava no output (única)
								var _get_ma = _array_keys[i]
								
								// Se só tem uma materia dentro do output e se é uma materia com receita
								if cont_get == 1 and ds_map_exists(ma_receitas, _get_ma) {
									// Passo a lista com a receita dessa materia
									_equal = ma_receitas[? _get_ma]
								}
								
								// Quebra o for
								break
							}
						}
						
					break
					// Dupli
					case 2:
						// Se tiver algum elemento selecionado
						if grid_posxy_click[0] != -1 {
							/// Se o grid selecionado já foi desbloqueado
							var _grid = grid_posxy_click[2]
							if _grid[# grid_posxy_click[0], grid_posxy_click[1]][0] {
								// Pegando o nome da materia pelo nome do sprite
								var _str_ma = string_delete(sprite_get_name(_grid[# grid_posxy_click[0], grid_posxy_click[1]][1]), 0, 9)
								
								// Testando se a materia pode ser criada e botando no map de cont quanto tem de cada coisa
								if _methods_buttons[_cont](0, 0, room_width, _materials_in_area, _str_ma) {
									// Passando o nome da materia que deseja ser formado
									_equal[0] = [1, _str_ma]
									// Som
									play_sound_geral(snd_mole_dupli)
								}
							}
						}
					break
				}
				
				// Quantidade de TIPOS de materias a serem criadas
				var _quant_mat = array_length(_equal)
				
				// Se a lista de criação tem algo a ser criado
				if _quant_mat > 0 {
					// Para saber se teve algum problema no meio da criação
					var _confirme = false
					
					// Indo por cada tipo de materia na receita
					for (var i = 0; i < _quant_mat; i++) {
						// Repete pela quantidade de cada tipo de materia
						repeat (_equal[i][0]) {
							// Para saber se devo criar a proxima materia
							var _continue = false
							
							with (obj_mole_materia) {
								// Se pelo uma materia está marcada para ser destruida no processo de criar algo
								if death {
									// Posso continuar o processo
									_continue = true
								}
							}
							
							// Se posso continuar o processo
							if _continue {
								// Conta quantas tentativas foram necessarias para criar a materia
								var _cont_test = 0
							
								// Enquanto ainda não criei uma materia sem está dentro de outra
								while (true) {
									// Aumenta o número de tentativa
									_cont_test++
								
									// Se o número de tentativas ultrapassar 400
									if _cont_test > 400 {
										/// Feedback
										play_sound_geral(snd_mole_erro)
										screenshake(2)
									
										// Tirando o marcador das materias que seriam destruidas para a criação de algo
										obj_mole_materia.death = false
										
										// Indicando que teve um problema na criação, para depois destruir as materias que iam ser criadas pelo processo atual
										_confirme = true
									
										// Quebrando o while true
										break
									}
									
									/// Variaveis de onde a materia atual deve ser criada
									var _x_cre = 0
									var _y_cre = 0
									
									// Se Run ou Dupli
									if _cont == 0 or _cont == 2 {
										// Se é a primeira tentativa de criação
										if _cont_test == 1 {
											/// Crio no meio do output
											_x_cre = _figure2_x
											_y_cre = _figure2_y
										}
										// Se não é a primeira tentativa
										else {
											/// Lógica do raio reaproveitada dos recipientes
											/// Usando o tamanho da materia como margem, para eles não ficarem fora do recipiente
											static _marg_x = sprite_get_width(spr_mole_proton)
											static _marg_y = sprite_get_height(spr_mole_proton)
											
											/// Tamanho maximo que ele pode criar até a borda
											static _w = (_figure2_r * 2 - _marg_x) / 2
											static _h = (_figure2_r * 2 - _marg_y) / 2
										
											/// Escolhendo de 0 a 100% da distancia maxima
											var _spc_w = _w * random(1)
											var _spc_h = _h * random(1)
		
											// Deixando aléatorio a direção
											var _dir = irandom(359)
		
											/// Posição de criação
											_x_cre = _figure2_x + lengthdir_x(_spc_w, _dir)
											_y_cre = _figure2_y + lengthdir_y(_spc_h, _dir)// - _h - sprite_height * 0.2 // "0.2" corresponde a distancia do espaço da sprite, tem que ser o mesmo no debug do draw
										}
									}
									// Se Back
									else if _cont == 1 {
										// Tamanho do diametro do input
										var _figure_le = _figure_x2 - _figure_x1
										/// Criando num lugar aléatorio dentro do input
										_x_cre = _figure_x1 + (_figure_x2 - _figure_x1) / 2
										_y_cre = _figure_y1 + (_figure_y2 - _figure_y1) / 2
										_x_cre = irandom_range(_figure_x1 + _figure_le * .1, _figure_x2 - _figure_le * .1)
										_y_cre = irandom_range(_figure_y1 + _figure_le * .1, _figure_y2 - _figure_le * .1)
									}
									
									/// Tentando criar a materia e passando suas caracteristicas
									var _mat = instance_create_layer(_x_cre, _y_cre, "Materia", obj_mole_materia)
									_mat.tipo = _equal[i][1]
									_mat.sprite_index = ma_spr[? _equal[i][1]]
									// Usando o image_angle = 45 como trigger para saber quais materias então sendo criadas por causa do processo atual
									_mat.image_angle = 45
								
									/// Dentro da materia criada
									with (_mat) {
										// Se ele foi criado tocando em outra materia
										if place_meeting(x, y, obj_mole_materia) {
											// Destruindo a materia criada
											instance_destroy(id)
										}
									}
								
									// Se a materia atual foi criada com sucesso
									if instance_exists(_mat) {
										// Quebro o while true para passar para a proxima materia
										break
									}
								}
							}
							// Se não posso continuar o processo por causa que deu algum problema
							else {
								// Quebro o repeat
								break
							}
						}
					}
					
					/// Destruindo quem tem o trigger ou tirando o trigger
					with (obj_mole_materia) {
						// Se ocorreu um erro na criação
						if _confirme {
							// Se sou uma materia que foi criada no meio da separação de outra mateira (image_angle = 45 usado como trigger)
							if image_angle == 45 {
								instance_destroy(id)
							}
						}
						// Se não teve nenhum problema no meio da criação
						else {
							// Reseto o trigger colocado
							image_angle = 0
						}
						
						/// Destruindo os obj materia ainda marcados
						if death {
							instance_destroy(id)
						}
					}
					
					// Se todo processo ocorreu sem erro
					if !_confirme {
						// Se foi o processo de run
						if _cont == 0 {
							// Pegando o nome da materia formada
							var _name = _equal[0][1]
							// Sabendo se é da grid dos elementos ou moleculas
							var _grid = ma_grid[? _name][0]
							/// Pegando suas coordenadas na grid
							var _xpos = ma_grid[? _name][1]
							var _ypos = ma_grid[? _name][2]
							
							// Se o player nunca tinha feito essa materia antes
							if _grid[# _xpos, _ypos][0] == false {
								/// Passando as informações correspondentes da materia criada para a o grid com suas coordenadas
								ds_grid_set(_grid, _xpos, _ypos, [true, ma_spr[? _name], ma_grid[? _name][3]])
								
								//
								ma_next_guide = next_guide()
							}
						}
					}
				}
				// Se o botão foi assionado, mas não foi criado nada
				else {
					/// Toco o som de erro e paro o do borão apertado
					if audio_is_playing(snd_mole_run) {
						audio_stop_sound(snd_mole_run)
					}
					if audio_is_playing(snd_mole_back) {
						audio_stop_sound(snd_mole_back)
					}
					if audio_is_playing(snd_mole_dupli) {
						audio_stop_sound(snd_mole_dupli)
					}
					
					/// Feedback error
					play_sound_geral(snd_mole_erro)
					screenshake(2)
				}
				
				/// Resetando o map do contador
				var _keys_cont = ds_map_keys_to_array(ma_cont)
				for (var _i = 0; _i < array_length(_keys_cont); _i++) {
					ma_cont[? _keys_cont[_i]] = 0
				}
			}
		}
		
		// Desenhando a spr
		draw_sprite_stretched(_spr_botao, _selecionado, _x1, _y1, _botao_w, _botao_w)
		
		/// Desenhando o icone
		var _icon_w = _botao_w * .5
		draw_sprite_stretched(_spr_icones[_cont], _selecionado, _x1 + _icon_w / 2, _y1 + _icon_w / 2, _icon_w, _icon_w)
		
		// Aumentando o contador
		_cont ++
	}
	
	// Reseto o contador de materias dentro da area testada
	cont_get = 0
	
	/// Depois de todo proceso, reseto o marcador das materias dentro da area testada, mas não precisaram ser destruidas
	if instance_exists(obj_mole_materia) {
		with(obj_mole_materia) {
			death = false
		}
	}
	#endregion
	
	// Definindo a cor do output
	_color = make_color_rgb(180, 140, 164)
	
	/// Desenhando o output (circulo)
	draw_circle_color(_figure2_x, _figure2_y, _figure2_r, c_black, c_black, false)
	draw_circle_color(_figure2_x, _figure2_y, _figure2_r-2, _color, _color, false)
	#endregion
	
	//// DEBUG do espaçamento
	//draw_rectangle_color(0, 0, _draw_w, _draw_h, c_red, c_red, c_red, c_red, true)	
}

// Metodo dos elementos visuais da gui
elements_gui  = function() {
	#region Elementos e Moleculas
	#region Definição de Variaveis
	/// Tamanho do espaço que será usado para a tabela de elementos e moleculas
	static _div    = display_get_gui_width() * div_tela		   // Posição x de onde começa o espaço para 
	static _gui_w  = display_get_gui_width() * (1 - div_tela) // Largura dessa tabela
	static _gui_h  = display_get_gui_height()			   // Altura da tela inteira
	
	/// Margem entre os elementos e a borda
	static _marg_x = _gui_w * .01
	static _marg_y = _gui_h * .01										// 0 - 1 = 99% restante
	
	draw_set_font(fnt_mole_desc)
	
	// Cor de fundo da tabela elementos
	var _color = c_blue
	
	/// Quant de colunas e linhas da grid de elementos
	static _element_cols  = ds_grid_width(grid_element)
	static _element_lins  = ds_grid_height(grid_element)
	
	/// Quant de colunas e linhas da grid de moleculas
	static _molecule_cols = ds_grid_width(grid_molecule)
	static _molecule_lins = ds_grid_height(grid_molecule)
	
	/// Itens margens
	static _grid_marg_x = (_gui_w - _marg_x) * .02
	static _grid_marg_y = (_gui_h - _marg_y * 2) * .02
	
	/// Itens elementos
	static _element_height = _marg_y + _gui_h * .40						// 1 - 40 = 60% restante
	static _element_text_y = _marg_y + string_height("I") / 1.5
	static _element_grid_w = ((_gui_w - _marg_x * 2) - _element_cols * _grid_marg_x) div _element_cols									  // Determinando o tamanho de cada quadrado, com as margens
	static _element_grid_h = ((_element_height - _element_text_y * 2.2 - _marg_y * 2) - (_element_lins * _grid_marg_y)) div _element_lins // Determinando o tamanho de cada quadrado, com as margens
	
	/// Itens moleculas
	static _div_molecule	= _element_height + _gui_h * .02			// 40 - 42 = 58% restante
	
	static _molecule_height = _div_molecule + _gui_h * .40				// 42 - 82 = 18% restante
	static _molecule_text_y = _div_molecule + string_height("I") / 1.5
	static _molecule_grid_w = ((_gui_w - _marg_x * 2) - _molecule_cols * _grid_marg_x) div _molecule_cols									  // Determinando o tamanho de cada quadrado, com as margens
	static _molecule_grid_h = ((_molecule_height - _molecule_text_y * 1.1 - _marg_y * 2) - (_molecule_lins * _grid_marg_y)) div _molecule_lins // Determinando o tamanho de cada quadrado, com as margens
	
	//
	static _grid_icon_w = _element_grid_w / 1.5
	#endregion
	
	#region Desenho dos espaços onde vai está as duas listas
	// Definindo o alinhamento do texto para o meio
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	
	/// Fundo do espaço dos elementos
	draw_set_alpha(.75)
	draw_roundrect_color(_div + _marg_x, _marg_y, _div + _gui_w - _marg_x, _element_height, _color, _color, false)
	
	// Se nesse frame o jogador já clicou em alguma caixa
	var _click_this_frame = false
	
	/// Desenhando todos os elementos
	for (var _l = 0; _l < _element_lins; _l ++) {
		for (var _c = 0; _c < _element_cols; _c ++) {
			// Pegando o sprite da caixa atual
			var _grid_icon = grid_element[# _c, _l][1]
			
			/// Posição do desenho dos itens (o centro sempre vai ser superior esquerdo)
			var _x1 = _div + _grid_marg_x / 2 + _element_grid_w * _c + (_grid_marg_x * _c) + _grid_marg_x
			var _y1 = _element_text_y + (_grid_marg_y / 2) + _element_grid_h * _l + (_grid_marg_y * _l) + _grid_marg_y
			
			// Usada para indicar se o mouse está nesse item especifico
			var _selecionado = mouse_in_item(_x1, _y1, _element_grid_w, _element_grid_h) and !(global.pause or instance_exists(obj_tutorial))
			
			// Caso o jogador ainda não clicou em ninguem e o mouse não está no botão dupli
			if !_click_this_frame and !button_dupli_sel and !(global.pause or instance_exists(obj_tutorial)) {
				if mouse_check_button_pressed(mb_left) {
					// Se o mouse está por cima dessa caixa
					if _selecionado {
						// Indicando que nesse frame o player já clicou em alguém
						_click_this_frame = true
						
						/// Passando as informações para salvar em quem eu cliquei
						grid_posxy_click[0] = _c
						grid_posxy_click[1] = _l
						grid_posxy_click[2] = grid_element
						
						// Feedback sonoro
						play_sound_geral(snd_menu_click)
					}
					// Se o mouse NÃO está por cima dessa caixa
					else {
						/// Indicando que não tem nenhuma caixa selecionada
						grid_posxy_click[0] = -1
						grid_posxy_click[1] = -1
					}
				}
			}
			
			// Se as coordenadas atuais são iguais as salvas na variavel que guarda em quem foi clicado por ultimo e se é do grid dos elementos
			var _click = grid_posxy_click[0] == _c and grid_posxy_click[1] == _l and grid_posxy_click[2] == grid_element
			
			// Desenhando as caixas dos itens e indicando se está selecionada pelo "_selecionado"
			draw_set_alpha(1 - 0.1 * _selecionado)
			draw_sprite_stretched(spr_mole_caixinha, _click, _x1, _y1, _element_grid_w, _element_grid_h)
			
			// Desenhando o icone dentro da caixa
			draw_sprite_stretched(_grid_icon, 0, _x1 + _element_grid_w / 2 - _grid_icon_w / 2, _y1 + _element_grid_h / 2 - _grid_icon_w / 2, _grid_icon_w, _grid_icon_w)
			draw_set_alpha(1)
		}
	}
	
	
	/// Fundo do espaço das moleculas
	draw_set_alpha(.75)
	draw_roundrect_color(_div + _marg_x, _div_molecule, _div + _gui_w - _marg_x, _molecule_height, _color, _color, false)
	
	/// Desenhando todos as moleculas
	for (var _l = 0; _l < _molecule_lins; _l ++) {
		for (var _c = 0; _c < _molecule_cols; _c ++) {
			// Pegando o sprite da caixa atual
			var _grid_icon = grid_molecule[# _c, _l][1]
			
			/// Posição do desenho dos itens (o centro sempre vai ser superior esquerdo)
			var _x1 = _div + _grid_marg_x / 2 + _molecule_grid_w * _c + (_grid_marg_x * _c) + _grid_marg_x
			var _y1 = _molecule_text_y + (_grid_marg_y / 2) + _molecule_grid_h * _l + (_grid_marg_y * _l) + _grid_marg_y
			
			// Usada para indicar se o mouse está nesse item especifico
			var _selecionado = mouse_in_item(_x1, _y1, _molecule_grid_w, _molecule_grid_h) and !(global.pause or instance_exists(obj_tutorial))
			
			// Caso o jogador ainda não clicou em ninguem e o mouse não está no botão dupli
			if !_click_this_frame and !button_dupli_sel and !(global.pause or instance_exists(obj_tutorial)) {
				if mouse_check_button_pressed(mb_left) {
					// Se o mouse está por cima dessa caixa
					if _selecionado {
						// Indicando que nesse frame o player já clicou em alguém
						_click_this_frame = true
						
						/// Passando as informações para salvar em quem eu cliquei
						grid_posxy_click[0] = _c
						grid_posxy_click[1] = _l
						grid_posxy_click[2] = grid_molecule
						
						// Feedback sonoro
						play_sound_geral(snd_menu_click)
					}
					// Se o mouse NÃO está por cima dessa caixa
					else {
						/// Indicando que não tem nenhuma caixa selecionada
						grid_posxy_click[0] = -1
						grid_posxy_click[1] = -1
					}
				}
			}
			
			// Se as coordenadas atuais são iguais as salvas na variavel que guarda em quem foi clicado por ultimo e se é do grid dos elementos
			var _click = grid_posxy_click[0] == _c and grid_posxy_click[1] == _l and grid_posxy_click[2] == grid_molecule
			
			// Desenhando as caixas dos itens e indicando se está selecionada pelo "_selecionado"
			draw_set_alpha(1 - 0.1 * _selecionado)
			draw_sprite_stretched(spr_mole_caixinha, _click, _x1, _y1, _molecule_grid_w, _molecule_grid_h)
			
			// Desenhando o icone dentro da caixa
			draw_sprite_stretched(_grid_icon, 0, _x1 + _molecule_grid_w / 2 - _grid_icon_w / 2, _y1 + _molecule_grid_h / 2 - _grid_icon_w / 2, _grid_icon_w, _grid_icon_w)
			draw_set_alpha(1)
		}
	}
	
	/// Títulos dos registros (Elementos e Moléculas)
	draw_set_alpha(1)
	
	///
	draw_set_color(c_black)
	draw_text_transformed(_div + _gui_w / 2+2, _element_text_y+2, "Elementos", .6, .6, 0)
	draw_text_transformed(_div + _gui_w / 2+2, _molecule_text_y+2, "Moleculas", .6, .6, 0)
	
	draw_set_color(c_white)
	// Título dos elementos
	draw_text_transformed(_div + _gui_w / 2, _element_text_y, "Elementos", .6, .6, 0)
	// Título dos Moléculas
	draw_text_transformed(_div + _gui_w / 2, _molecule_text_y, "Moleculas", .6, .6, 0)
	
	
	// Resetando o alinhamento do texto
	draw_set_halign(-1)
	draw_set_valign(-1)
	#endregion
	
	draw_set_font(-1)
	draw_set_color(-1)
	
	//// DEBUG do espaçamento
	//draw_rectangle(_div, 0, room_width, _gui_h, true)
	#endregion

	#region Botão de RESET das materias
	#region Definição de Variaveis
	// Sprite do botão de reset
	static _spr_reset = spr_mole_retorno
	/// Posições do botão
	static _x_reset = _gui_w * .2
	static _y_reset = _gui_h * .88
	// Tamanho do desenho
	static _size_reset = _gui_w * .18
	#endregion
	
	// Sabendo se o mouse está por cima do botão
	var _sel_reset = mouse_in_item(_x_reset, _y_reset, _size_reset, _size_reset) and !(global.pause or instance_exists(obj_tutorial))
	
	#region Ação ao acionar o botão
	// Se cliquei no botão
	if _sel_reset and mouse_check_button_released(mb_left) {
		// Feedback sonoro
		play_sound_geral(snd_mole_back)
		
		// Destruindo todas as materias
		instance_destroy(obj_mole_materia)
		
		/// Criando as materias dos recipientes
		with (obj_mole_recipiente) {
			cria_materia()
		}
	}
	#endregion
	
	/// Desenhando o botão com o efeito de transparencia ao passar o mouse por cima
	draw_set_alpha(1 - 0.2 * _sel_reset)
	draw_sprite_stretched(_spr_reset, 0, _x_reset, _y_reset, _size_reset, _size_reset)
	draw_set_alpha(1)
	
	#endregion

	#region Role of description
	if (grid_posxy_click[0] != -1) {

	    // --- configurações / margens (mantive suas variáveis) ---
		static _spr_desc = spr_mole_paper_1
		static _desc_w   = sprite_get_width(_spr_desc)
		static _desc_h   = sprite_get_height(_spr_desc)

		static _desc_font = fnt_mole_desc

		static _desc_y = _gui_h * 0.21

		static _margin_x = 34
		static _margin_y = 49

		// Tamanho desejado da fonte em px
		static _desc_size_font = 14
		// Tamanho original (intrínseco) da fonte em px
		static _size_font = font_get_size(_desc_font)
		// escala aplicada ao desenhar
		static _desc_scale = _desc_size_font / _size_font

		// largura disponível real (em pixels *após* aplicar escala)
		// Quando usar draw_text_ext_transformed, o argumento "w" é baseado em scale=1,
		// então devemos passar a largura dividida pela escala para compensar
		var _available_w_unscaled = (_desc_w - (_margin_x * 2)) / _desc_scale

		// pega o texto
		var _grid = grid_posxy_click[2]
		var _text = ""
		if (!is_undefined(_grid)) {
		    _text = _grid[# grid_posxy_click[0], grid_posxy_click[1]][2]
		}

		// altura final do background (começa com o tamanho padrão do sprite)
		var _final_bg_h = _desc_h

		if string_length(_text) > 0 {
		    // _IMPORTANTE_: string_height_ext usa a fonte atual (draw_set_font),
		    // e seus argumentos são: string, sep, w
		    // Definimos a fonte atual para a que vamos usar (intrínseca)
		    draw_set_font(_desc_font)

		    // medimos a altura *sem escala* usando a largura compensada (unscaled)
		    var _raw_height = string_height_ext(_text, -1, _available_w_unscaled)

		    // agora aplicamos a escala para obter a altura real que será desenhada
		    var _text_height = _raw_height * _desc_scale

		    // ajusta altura do fundo incluindo margens
		    _final_bg_h = max(_desc_h, _text_height + (_margin_y * 2))

		    // --- desenha fundo (com nova altura) ---
		    draw_sprite_stretched(_spr_desc, 0, 0, _desc_y, _desc_w, _final_bg_h)

		    // --- desenha o texto com a escala aplicada ---
		    // draw_text_ext_transformed(x, y, string, sep, w, xscale, yscale, angle)
		    // note que aqui passamos w = _available_w_unscaled (compensado), e xscale/yscale = _desc_scale
		    draw_set_color(c_black)
		    draw_text_ext_transformed(_margin_x, _desc_y + _margin_y, _text, -1, _available_w_unscaled, _desc_scale, _desc_scale, 0)

		    // restaura estado visual
		    draw_set_color(c_white)
		    draw_set_font(-1)
		}
		else {
		    // desenha fundo (sem texto)
		    draw_sprite_stretched(_spr_desc, 0, 0, _desc_y, _desc_w, _final_bg_h)

		    // desenha interrogação centralizada no fundo
		    static _spr_q = spr_mole_interogation
		    var _q_x = _desc_w * 0.30
		    var _q_size = _desc_w - _q_x * 2
		    var _q_y = _desc_y + (_final_bg_h / 2) - (_q_size / 2)
		    draw_sprite_stretched(_spr_q, 0, _q_x, _q_y, _q_size, _q_size)
		}

	}
	#endregion


	#region Guia
	/// Posição inicial onde vai ter o guia
	static _guide_x = _gui_w * 0.08
	static _guide_y = _gui_h * 0.08
	
	// Spr do icone da lâmpada
	static _lamp_spr = spr_mole_lamp
	
	// Tamanho que o icone vai ser desenhado
	static _lamp_size = _gui_h * .09
	
	// Saber se o texto do guia deve ser mostrado
	static _lamp_on = false
	
	// Saber se o mouse está por cima do icone
	var _lamp_sel = false
	
	// CONDIÇÃO DE VITORIA
	// Se foi indicado que todas as materias já foram criadas
	if ma_next_guide == "complete" {
		// Deixando o icone da lâmpada sempre desligada
		_lamp_on = false
		
		//
		if !alarm_call {
			alarm_call = true
			
			//
			alarm[0] = 500
		}
	}
	// Se ainda tem alguma materia para ser descoberta
	else {
		// Saber se o mouse está por cima do icone
		_lamp_sel = mouse_in_item(_guide_x, _guide_y - _lamp_size / 2.3, _lamp_size, _lamp_size) and !(global.pause or instance_exists(obj_tutorial))
		/// Se clikei no icone, inverto o switch do guia
		if _lamp_sel and mouse_check_button_released(mb_left) {
			if _lamp_on {
				_lamp_on = false
			}
			else {
				_lamp_on = true
			}
		}
		
		// Se o guia está ligado
		if _lamp_on {
			// Pegando a lista com a receita da próxima criação
			var _receita = ma_receitas[? ma_next_guide];

			// Definir um deslocamento inicial para o primeiro ingrediente
			var _space = 0;

			// Espaçamento mínimo entre ingredientes
			var _spacing_extra = 20;
			
			// Andando por cada parte da receita (quantidade - nome)
			for (var i = 0; i < array_length(_receita); ++i) {
			    // Quantidade do ingrediente
			    var _quant = _receita[i][0];
    
			    // Nome do ingrediente
			    var _name = _receita[i][1];
    
			    // Criando a string do texto
			    var _text = string(_quant) + "x - " + _name;
    
			    // Calculando a largura do texto para definir o espaçamento correto
			    var _text_width = string_width(_text);
    
			    // Escrever a receita na tela
			    draw_text(_guide_x + _lamp_size*1.5 + _space, _guide_y, _text);
    
			    // Ajustar o espaço para o próximo ingrediente
			    _space += _text_width + _spacing_extra;
			}
		}
	}
	
	/// Desenhando o icone da lâmpada com o efeito para saber se o mouse está por cima
	draw_set_alpha(1 - .2 * _lamp_sel)
	draw_sprite_stretched(_lamp_spr, _lamp_on, _guide_x, _guide_y - _lamp_size / 2.3, _lamp_size, _lamp_size)
	draw_set_alpha(1)
	
	#endregion
}


/// Metodos usados no gui
// Saber se o mouse está em cima de um espaço de item
mouse_in_item = function(_x1, _y1, _width, _height) {
	return point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _x1, _y1, _x1 + _width, _y1 + _height)
}

// Retorna a proxima etapa mostrada no guia
next_guide = function() {
	// Lista com todas as chaves do map da receita na ordem para ser seguida
	var _keys = ["hidrogenio", "helio", "litio", "berilio", "boro", "carbono", "nitrogenio", "oxigenio", "h2", "h2o", "ch4", "nh3", "nh4", "li2", "lih", "beh2"]
	
	// Andando por cada chave da lista
	for (var i = 0; i < array_length(_keys); ++i) {
		/// Sabendo qual é a grid e sua coordenada
		var _grid = ma_grid[? _keys[i]][0]
		var _gridx = ma_grid[? _keys[i]][1]
		var _gridy = ma_grid[? _keys[i]][2]
		
		// Se esse elemento da grid não tinha sido criado até então
	    if !_grid[# _gridx, _gridy][0] {
			// Retorna o nome da proxima materia que é dada a receita no guia
			return _keys[i]
		}
	}
	
	/// Caso todas as materias já tenham sido descobertas, retorna um texto indicando que toda lista foi completa
	play_sound_geral(snd_mole_complete)
	return "complete"
}


// Para saber se o mouse está segurando uma materia
mouse_seg = false

// Iniciando o primeiro texto do guia
ma_next_guide = next_guide()

// Se o alarm da condição de vitoria fui chamado
alarm_call = false
