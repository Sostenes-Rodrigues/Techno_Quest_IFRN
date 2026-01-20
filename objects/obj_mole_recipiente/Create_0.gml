/// Criando 8 materias correspondentes ao meu tipo
/// Ds_map com o sprite correspondente ao tipo
ma_spr = obj_mole_control.ma_spr

// Metodo para criar as materias na posição do recipiente
cria_materia = function() {
	// Conta quantas materias já foram criadas
	var _quant_m = 0
	
	/// Usando o tamanho da materia como margem, para eles não ficarem fora do recipiente
	static _marg_x = sprite_get_width(spr_mole_proton)
	static _marg_y = sprite_get_height(spr_mole_proton)
	
	var _cont_debug = 0
	// Enquanto não foram criados 8 materias com sucesso
	while(_quant_m < 12) {
		_cont_debug++
		/// Tamanho maximo que ele pode criar até a borda
		static _w = (sprite_width - _marg_x) / 2
		static _h = (sprite_height - _marg_y)/ 2
		
		/// Escolhendo de 0 a 100% da distancia maxima
		var _spc_w = _w * random(1)
		var _spc_h = (_h * random(1)) * .8
		
		// Deixando aléatorio a direção
		var _dir = irandom(359)
		
		/// Posição de criação
		var _spc_x = x + lengthdir_x(_spc_w, _dir)
		var _spc_y = y + lengthdir_y(_spc_h, _dir) - _h - sprite_height * 0.2 // "0.2" corresponde a distancia do espaço da sprite, tem que ser o mesmo no debug do draw
		
		// Criando a instancia
		var _ma = instance_create_layer(_spc_x, _spc_y, "Materia", obj_mole_materia)
		
		/// Dentro da materia criada
		with (_ma) {
			// Se ele foi criado tocando em outra materia
			if place_meeting(x, y, obj_mole_materia) {
				// Destruindo a materia criada
				instance_destroy(id)
			}
			else {
				// Aumentando o contador de materias criadas
				_quant_m ++
				
				// Passando o tipo da materia criada
				tipo = other.tipo
				
				// Passando o sprite da materia criada
				sprite_index = other.ma_spr[? tipo]
			}
		}
		//\
	}
	//show_message(_cont_debug)
}

/// Chamando o metodo para criar as materias na posição do recipiente
cria_materia()
