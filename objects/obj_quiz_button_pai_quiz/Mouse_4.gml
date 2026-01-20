// verificacao de pause
if (global.pause or instance_exists(obj_tutorial) or game_win) exit;

if correct {
	color = c_green
	
	/// Efeito de acero
	play_sound_geral(snd_quiz_correct)
	
	obj_quiz_control.respondida = true
	obj_quiz_control.troca = true
	
	// Apagando a pergunta já feita
	if position != -1 {
		array_delete(obj_quiz_control.quiz_lista, position, 1)
		
		position = -1
	}
}
else {
	color = c_red
	
	/// Efeito de erro
	screenshake(10)
	play_sound_geral(snd_nets_error)
	play_sound_geral(snd_nets_error)
    
	// Diminui uma vida da minha
	with (obj_quiz_control) {
		vida -= 1;
	
		if vida <= 0 {
		    // Se não houver mais vidas, recomeça
		    room_restart()
			//instance_destroy()
		
			// Não faz mais nada
			//exit
		}
	}
}
