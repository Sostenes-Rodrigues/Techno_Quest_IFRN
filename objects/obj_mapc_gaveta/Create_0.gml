draw = false

cria_memoria = function() {
	// Criando o obj memoria
	if tipo_definido > 19{
		var _memoria = instance_create_layer(0,0, "Cooler", obj_mapc_memoria) 
	
		/// Colocando as caracteristicas desse objeto
		 _memoria.item  = tipo_definido
		 _memoria.image_index  = tipo_definido
		 _memoria.carregando = true
	}
	else{
		var _memoria = instance_create_layer(0,0, "Memoria", obj_mapc_memoria) 
		// Criar variaveis para os parametros

		/// Colocando as caracteristicas desse objeto
		 _memoria.item  = tipo_definido
		 _memoria.image_index  = tipo_definido
		 _memoria.carregando = true
	}
}

