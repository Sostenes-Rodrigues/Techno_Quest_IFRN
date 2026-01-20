// Verifica se o jogador ainda tem vidas restantes
/*
if global.vida <= 0 {
    // Se não houver mais vidas, recomeça
	quiz_lista = global.quiz_lista
	obj_timer_quiz.timer = obj_timer_quiz.timer_save
    room_restart()
	//instance_destroy(other)
	
	// Não faz mais nada
	//exit
}
*/

// Se Começou a primeira pergunta ou tem que mudar a pergunta
if troca {
	// Reinicia as respostas dos botões
	obj_quiz_button1.correct = false
	obj_quiz_button2.correct = false
	obj_quiz_button3.correct = false
	obj_quiz_button4.correct = false
	// Verificando se ainda tem perguntas na lista
	if array_length(quiz_lista) > 0 {
		//
		respondida = false
		
		// Pegando a posição de uma pergunta aléatoria
		var _location = irandom_range(1, array_length(quiz_lista)) - 1
		
		#region Definindo e setando as variaveis usadas no controller e nos bottuons
		obj_quiz_button_pai_quiz.color = c_black
		
		texto = quiz_lista[_location][0]
		var _resposta = quiz_lista[_location][1]
		var _texto_button1 = quiz_lista[_location][2][0]
		var _texto_button2 = quiz_lista[_location][2][1]
		var _texto_button3 = quiz_lista[_location][2][2]
		var _texto_button4 = quiz_lista[_location][2][3]
		
		obj_quiz_button1.texto = _texto_button1
		obj_quiz_button2.texto = _texto_button2
		obj_quiz_button3.texto = _texto_button3
		obj_quiz_button4.texto = _texto_button4
		
		if _resposta == 0 {
			obj_quiz_button1.correct = true
			obj_quiz_button1.position = _location
		}
		else if _resposta == 1 {
			obj_quiz_button2.correct = true
			obj_quiz_button2.position = _location
		}
		else if _resposta == 2 {
			obj_quiz_button3.correct = true
			obj_quiz_button3.position = _location
		}
		else if _resposta == 3 {
			obj_quiz_button4.correct = true
			obj_quiz_button4.position = _location
		}
		#endregion
		
		
	}
	else {
		/// CONDIÇÃO DE VITORIA
		if vida > 0 and respondida {
			//
			if !instance_exists(obj_control_transition_rooms) {
				///
				obj_quiz_timer.game_win = true
				obj_quiz_button_pai_quiz.game_win = true
				
				// Se ainda não tinha completado no save atual
				if !get_data("c_quiz") {
					/// Salvando no save atual que esse minigame foi concluido
					save_data("c_quiz", 1)
			
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
	}
	
	// Depois de setar tudo, espera o player acertar a resposta
	troca = false
}
else {
	if respondida {
		
	}
}
