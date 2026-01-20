if (global.pause or instance_exists(obj_tutorial)) exit;


if obj_mapc_pc.ponto = 0{

	//Começa a carregar o objeto quando o botão do mouse for pressionado
	if (!carregando) and (!obj_mapc_controle.segurando) {
	    carregando = true;   //Define que o objeto está sendo carregado
		obj_mapc_controle.segurando = true;//Define que o player está carregando um obj
		x = mouse_x;   //Armazena a posição inicial do mouse
	    y = mouse_y;
		
		play_sound_geral(snd_mapc_unplug)
	}

}