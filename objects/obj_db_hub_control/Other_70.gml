/// @description Listeners e Queries disparam o evento quando dados são alterados ou carregados.
#region Oque aciona o evento "Async Social"?
/*
O evento Async - Social é acionado sempre que ocorre uma interação assíncrona entre o jogo e
um serviço externo (como Extensões de Terceiros, Serviços de Login ou APIs de Redes Sociais,
quando uma operação de rede termina, funções sociais específicas e funções UWP Xbox Live e
Este evento também pode ser acionado pela Reprodução de Vídeo).
*/
#endregion

// Sempre que quiser ver o tipo do evento async social recebido
//show_debug_message(async_load[? "type"])

// Se for o retorno de um set ao Firebase. (acionado ao o executar .Set)
if async_load[? "type"] == "FirebaseFirestore_Collection_Add" { // OK
    // Verifica se a solicitação assíncrona foi concluída com sucesso (código de status 200).
	if async_load[? "status"] == 200 {
		// Mostrando a mensagem de sucesso
        show_debug_message("Set() function call succeeded!")
		
		// Chamando uma nova consulta para pegar a versão mais recente
		FirebaseFirestore(root).Query()
    }
	// Se a conexão não foi estabelecida
    else
    {
        /// Mostrando a mensagem de erro
		var _error_message = async_load[? "errorMessage"]
		show_message(_error_message)
    }
}

// // Se for o retorno de um update ao Firebase. (acionado ao o executar .Update)
if (async_load[? "type"] == "FirebaseFirestore_Document_Update") {
    // Verifica se a solicitação assíncrona foi concluída com sucesso (código de status 200).
	if async_load[? "status"] == 200 {
		// Mostrando a mensagem de sucesso
        show_message(".Update() function call succeeded!")
    }
    // Se a conexão não foi estabelecida
    else
    {
        /// Mostrando a mensagem de erro
		var _error_message = async_load[? "errorMessage"]
		show_message(_error_message)
    }
}

// Se for o retorno de uma consulta ao Firebase. (acionado ao o executar o evento de cima (Query) e pelo Listener no create)
if async_load[? "type"] == "FirebaseFirestore_Collection_Query" { // OK
	// Verifica se a solicitação assíncrona foi concluída com sucesso (código de status 200).
	if async_load[? "status"] == 200 {
		// Mostrando a mensagem de sucesso
        show_debug_message(".Query() function call succeeded!")
		
	    // Inicializa o array 'data' para armazenar os documentos recebidos.
		data = []
            
		// Obtém os dados brutos retornados pela consulta.
	    var _doc = async_load[? "value"]
		//show_debug_message(_doc): {"kGrXDT0JBIwRjP1NghPf":{"score":654.0,"name":"rodrigo"},"s86Lgk8T4NPiMvrFLaza":{"score":43.0,"name":"Astolfo"}}
			
		// Converte os dados JSON em uma estrutura struct.
	    var _data = json_parse(_doc)
			
		// Obtém as chaves (IDs) dos documentos na estrutura de dados.
	    var _names = variable_struct_get_names(_data)
            
		// Itera sobre os nomes dos documentos.
	    for (var _i = 0; _i < array_length(_names); _i ++) {
			// Pega a struct com todos os atributos de cada instancial armazenada em "_data"
	        var _doc_atri = variable_struct_get(_data, _names[_i])
			//show_message(_doc): { score : 654, name : "rodrigo" } --> { score : 43, name : "Astolfo" }

			// Adiciona o ID como um elemento da struct, que vai ser salva no array com todas as instancias
	        _doc_atri.id = _names[_i]
				
			// Adiciona a struct de cada instancia na lista para salvar todas
	        array_push(data, _doc_atri)
	    }
		//show_message(data)
	}
	// Se a conexão não foi estabelecida
    else
    {
        /// Mostrando a mensagem de erro
		var _error_message = async_load[? "errorMessage"]
		show_message(_error_message)
    }
}
		
// Se for o retorno de um delete ao Firebase. (acionado ao o executar .Delete)
if async_load[? "type"] == "FirebaseFirestore_Document_Delete" {  // OK
	// Verifica se a solicitação assíncrona foi concluída com sucesso (código de status 200).
	if async_load[? "status"] == 200 {
		// Chamando uma nova consulta para pegar a versão mais recente
		FirebaseFirestore(root).Query()
		
		// Mostrando a mensagem de sucesso
		show_debug_message("Document was deleted successfully.")
	}
	// Se a conexão não foi estabelecida
    else
    {
        /// Mostrando a mensagem de erro
		var _error_message = async_load[? "errorMessage"]
		show_message(_error_message)
    }
}

// Se for o retorno de uma leitura ao Firebase. (acionado ao o executar .Read)
if (async_load[? "type"] == "FirebaseFirestore_Collection_Read") {
    // Verifica se a solicitação assíncrona foi concluída com sucesso (código de status 200).
	if async_load[? "status"] == 200 {
		// Mostrando a mensagem de sucesso
        show_message("Document data is: " + async_load[? "value"])
    }
    // Se a conexão não foi estabelecida
    else
    {
        /// Mostrando a mensagem de erro
		var _error_message = async_load[? "errorMessage"]
		show_message(_error_message)
    }
}
