// verificacao de pause
if(instance_exists(obj_tutorial) or game_win) exit;

// criando uma condicao pra quando o tempo for maio que zero
if instance_exists(obj_quiz_control) {
	if timer > 0 and !obj_quiz_control.troca {
	    timer -= 1; 
		// Reduz o tempo restante
		// no caso ele tá diminuindo um 1 segundo
	}
	else { // caso o tempo seja menor ou igual a zero 
		/// Exibe uma messagem de que o tempo acabou
		
		// reinicia
		if !global.pause {
			room_restart()
		}
	}
}
