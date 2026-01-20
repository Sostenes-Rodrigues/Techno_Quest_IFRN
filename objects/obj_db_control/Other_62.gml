/// @description Verifica a conecção a internet (Tentando acessar o google.com)
// Se existe o elemento "id" dentro do ds map do async
if (ds_map_exists(async_load, "id")) {
	// Pegando o estado da ultima conexão http chamada
    var _status = async_load[? "status"]
    
	// Se a conexão foi estabelecida com sucesso
    if (_status == 0) {
        internet_connected = true  // Conectado à internet
		
		// 
		cont_erro = 0
    }
	
	// Se a conexão NÃO foi estabelecida com sucesso
	else {
		// 
		cont_erro++
		//show_message(cont_erro)
		show_debug_message(cont_erro)
		
		if cont_erro > 3 {
			// Fazer um contador de erros para não contar quando for só pelo servidor reconfigurando //
	        internet_connected = false // Sem conexão
			cont_erro = -2
		}
    }
}
