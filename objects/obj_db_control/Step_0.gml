/*
// Verifica se a tecla "D" foi pressionada e liberada, se 'data' é válido e se contém ao menos um item.
if keyboard_check_released(ord("L")) and data != -1 and array_length(data) > 0 {
	// Obtém a referência da primeira instancia na lista de dados carregados.
    var _doc = FirebaseFirestore(root).Child(data[0].id) //																	ID
	//show_debug_message(_doc): { _orderBy_direction : undefined, _orderBy_field : undefined, _path : "/highscores/pZuHX7z7FFFo07SEu26f/", _start : undefined, _end : undefined, _limit : undefined, _action : "", _value : undefined, _operations : undefined, _isDocument : 1, _isCollection : 0 }
	
	// Exclui o documento do Firebase.
    _doc.Delete()
}

