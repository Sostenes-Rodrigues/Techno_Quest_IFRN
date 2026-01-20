if (global.pause or instance_exists(obj_tutorial)) exit;

//Enquanto o objeto estiver sendo carregado, ele segue o mouse
if (carregando) {
    x = mouse_x;  //Atualiza a posição X do objeto para o mouse
    y = mouse_y;  //Atualiza a posição Y do objeto para o mouse
}

//Verifica se o obj está ou não encaixado em algo
if place_meeting(x, y, obj_mapc_slot) {
	encaixa = true
	
	if item >= 20 and place_meeting(x+40, y, obj_mapc_botao_cooler) {
		obj_mapc_botao_cooler.can_pressed = false
	}
}
else {
	encaixa = false
	
	obj_mapc_botao_cooler.can_pressed = true
}
