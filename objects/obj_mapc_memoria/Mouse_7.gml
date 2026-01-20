if (global.pause or instance_exists(obj_tutorial)) exit;

// Solta o objeto quando o botão do mouse for solto

//Caso o obj não seja o processador
if item < 16{
	//Caso player esteja carregando um item e esse item possa ser encaixado, e caso não seja o encaixe do processador
	if (encaixa) and instance_nearest(x,y,obj_mapc_slot).encaixado = false and instance_nearest(x,y,obj_mapc_slot).tipo_definido <4{
		carregando = false;//O obj não esta mais carregando pelo player 
		obj_mapc_controle.segurando = false;//O player não está mais carregando o obj
	
		//Move o obj para o encaixe mais próximo
		x = instance_nearest(x,y,obj_mapc_slot).x
		y = instance_nearest(x,y,obj_mapc_slot).y
		
		
	}
	else{
		if carregando = true {
			obj_mapc_controle.segurando = false
			instance_destroy(self)
		}
	}
}



//Caso o obj seja o processador e possa encaixar
if item >= 16 and item < 20{
if (encaixa) and instance_nearest(x,y,obj_mapc_slot).encaixado = false and instance_nearest(x,y,obj_mapc_slot).tipo_definido = 4{
	carregando = false;//O obj não esta mais carregando pelo player 
	obj_mapc_controle.segurando = false;//O player não está mais carregando o obj
	
	//Move o obj para o encaixe mais próximo
	x = instance_nearest(x,y,obj_mapc_slot).x
	y = instance_nearest(x,y,obj_mapc_slot).y

}
else{//Caso o obj não possa ser encaixado
	if carregando = true{
	obj_mapc_controle.segurando = false
	instance_destroy(self)
	}
}}


if item >= 20{
if (encaixa) and instance_nearest(x,y,obj_mapc_slot).encaixado = false and instance_nearest(x,y,obj_mapc_slot).tipo_definido = 5{

	carregando = false;//O obj não esta mais carregando pelo player 
	obj_mapc_controle.segurando = false;//O player não está mais carregando o obj

	//Move o obj para o encaixe mais próximo
	x = instance_nearest(x,y,obj_mapc_slot).x
	y = instance_nearest(x,y,obj_mapc_slot).y

}
else{//Caso o obj não possa ser encaixado
	if carregando = true{
	obj_mapc_controle.segurando = false
	instance_destroy(self)
	}
}}

  
