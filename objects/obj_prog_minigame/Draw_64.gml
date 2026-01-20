
//Tamanho da tela
var _guil = display_get_gui_width()
var _guia = display_get_gui_height()

//Onde está o mouse
var _mx = device_mouse_x_to_gui(0)
var _my = device_mouse_y_to_gui(0)

var _invx = _guil - minigame_l


if  minigame == true {

#region //barra lateral

	//Posições dos slots
	
	
	//Sprite dos slots
	if !(global.seq_run) draw_sprite_ext(spr_prog_minigame,0,_invx,invy, scale, scale *(total_slots-1)+0.5,0,c_white,1);
	
	//"Id" dos slots, basicamente cada slot é representado por um valor diferente dessa variavel ai
	var _ix = 0
	var _iy = 0
	
	//Variaveis para saber se algo está dentro de uma repetição
	var _sp = 0
	var _si = 0
	
	for (var i = 0; i < total_slots; i++){
		var _slotsx = _invx -40  + comeco_x + ((tamanho_slot + buffer)*_ix)
		var _slotsy = invy  + comeco_y + ((tamanho_slot + buffer)*_iy)
		
		
		
		//Se o slot não estiver vazio
		if grid_items[# INFOS_PROG.ITEMS,i] != -1{
			//Se for uma estrutura de repetição
			if grid_items[# INFOS_PROG.ITEMS,i] >7{
				if !(global.seq_run) draw_sprite_ext(spr_prog_itens, grid_items[# INFOS_PROG.ITEMS,i], _slotsx-40 ,_slotsy, scale,scale,0,c_white,1)
				if _si < grid_items[# INFOS_PROG.REP,i]{
				_si = grid_items[# INFOS_PROG.REP,i]
				_sp = i}

				//Caso a Bola fique num lugar que não deveria
				if i > grid_items[# INFOS_PROG.REP,i]{
					grid_items[# INFOS_PROG.REP,i] = i
				}
				if grid_items[# INFOS_PROG.REP,i] >= ds_grid_check(){
				 grid_items[# INFOS_PROG.REP,i] -=1
				}
			}else{
			//Se for as outras ações
				//Se estiver dentro de uma repetição
				if  i > _sp and i < _si+1{
					_slotsx +=40
					if !(global.seq_run) draw_sprite_ext(spr_prog_itens, grid_items[# INFOS_PROG.ITEMS,i], _slotsx ,_slotsy, scale,scale,0,c_white,1)

			}else{
				//Se não estiver
				if !(global.seq_run) draw_sprite_ext(spr_prog_itens, grid_items[# INFOS_PROG.ITEMS,i], _slotsx ,_slotsy, scale,scale,0,c_white,1)
				}
			}

		}

		//Se o slot da bola não estiver vazio
		if grid_items[# INFOS_PROG.REP,i] != -1{
			if !(global.seq_run) draw_sprite_ext(spr_prog_bola,0, _slotsx -24 ,invy  + 16 + ((tamanho_slot + buffer)* grid_items[# INFOS_PROG.REP,i]), scale,scale,0,c_white,1)
		}

		//Se o slot tiver uma estrutura de repetição
		if grid_items[# INFOS_PROG.ITEMS,i] >7{
				_slotsx -=40
			}
		//Se o mouse passar pelos slots
		if point_in_rectangle(_mx,_my,_slotsx, _slotsy, _slotsx + tamanho_slot, _slotsy + tamanho_slot) and play = false and !(global.pause or instance_exists(obj_tutorial)) and _iy< total_slots-1{
			if !(global.seq_run) draw_sprite_ext(spr_prog_coisa,0,_slotsx,_slotsy,scale,scale,0,c_white,1)
			
			//Se for clicado com botão esquerdo
			if mouse_check_button_pressed(mb_left){
				//Caso nao tenha nenhum item selecionado
				if item_selecionado == -1{
					item_selecionado = grid_items[# INFOS_PROG.ITEMS, i]
					qtd_selecionada = grid_items[# INFOS_PROG.QTD, i]
					rep_selecionada = grid_items[# INFOS_PROG.REP, i]
					pos_selecionada = i
					categ_draw = false	
				}
				//Caso ja tenha um item selecionado
				else{
					//Caso nao tenha nada onde selecionar
					if grid_items[# INFOS_PROG.ITEMS,i] == -1{
						ds_grid_add_item(item_selecionado)
						grid_items[# INFOS_PROG.ITEMS, pos_selecionada] = -1
						grid_items[# INFOS_PROG.QTD, pos_selecionada] = -1
						grid_items[# INFOS_PROG.REP, pos_selecionada] = -1
						qtd_selecionada = -1
						rep_selecionada = -1
						item_selecionado = -1
						pos_selecionada = -1
						
					}else{
						//Caso tenha
						var _item = grid_items[# INFOS_PROG.ITEMS,i]		
						var _qtd = grid_items[# INFOS_PROG.QTD, i]
						var _rep = grid_items[# INFOS_PROG.REP, i]
						grid_items[# INFOS_PROG.ITEMS,i] = grid_items[# INFOS_PROG.ITEMS, pos_selecionada]
						grid_items[# INFOS_PROG.QTD,i] = grid_items[# INFOS_PROG.QTD, pos_selecionada]
						grid_items[# INFOS_PROG.REP,i] = grid_items[# INFOS_PROG.REP, pos_selecionada]
						grid_items[# INFOS_PROG.ITEMS, pos_selecionada] = _item
						grid_items[# INFOS_PROG.QTD, pos_selecionada] = _qtd
						grid_items[# INFOS_PROG.REP, pos_selecionada] = _rep
						item_selecionado = -1
						pos_selecionada = -1
						qtd_selecionada = -1
						rep_selecionada = -1
						categ_draw = false	
						}
					}
			
			}
			//Se for clicado com botão direito
			if mouse_check_button_pressed(mb_right){
				
				if grid_items[# INFOS_PROG.ITEMS,i] >7{
					if grid_items[# INFOS_PROG.REP,i]+1 < ds_grid_check(){
					grid_items[# INFOS_PROG.REP,i]+= 1
					}else{
						grid_items[# INFOS_PROG.REP,i] =  i
					}
				}
			}
		}
		
		//Checa se tem um espaço vaizio entre os itens
		var _slot = ds_grid_check()
		//Caso tenha
		if _slot < total_slots-1 and grid_items[# INFOS_PROG.ITEMS,_slot+1] != -1 {
			grid_items[# INFOS_PROG.ITEMS,_slot] = grid_items[# INFOS_PROG.ITEMS,_slot+1]
			grid_items[# INFOS_PROG.REP,_slot] = grid_items[# INFOS_PROG.REP,_slot+1]
			grid_items[# INFOS_PROG.REP,_slot+1] = -1
			grid_items[# INFOS_PROG.ITEMS,_slot+1] = -1
		}
		
		//passa para a criação do próximo slot
		if _iy < total_slots-1{
		_iy++}
		
	}
	
	
#endregion
#region //categorias
	//"Id" dos slots, basicamente cada slot é representado por um valor diferente dessa variavel ai
	var _ix2 = 0
	var _iy2 = 0
	
	//Posições dos slots
	var _invx1 = _guil/2 - categ_l/2	
	var _invy1 = _guia - categ_y
	
	//Sprite das categorias
	if !(global.seq_run) draw_sprite_ext(spr_prog_categorias,0,_invx1,_invy1,scale,scale,0,c_white,1)

	for (var i2 = 0; i2 < 4; i2++){
		var _slotsx2 = _invx1  + comeco_x1 +((tamanho_slot + buffer)*_ix2)
		var _slotsy2 = _invy1  + comeco_y1 +((tamanho_slot + buffer)*_iy2)
			
			//Se o mouse passar pelos slots
			if point_in_rectangle(_mx,_my,_slotsx2, _slotsy2, _slotsx2 + tamanho_slot, _slotsy2 + tamanho_slot) and play == false and !(global.pause or instance_exists(obj_tutorial)){
				if !(global.seq_run) draw_sprite_ext(spr_prog_coisa,0,_slotsx2,_slotsy2,scale,scale,0,c_white,1)
				
					//Se for clicado com botão esquerdo e não for a lixeira
					if mouse_check_button_pressed(mb_left) and i2 != 3 and play == false and i2>=0{
						if categ_draw = true and categ == i2{
							categ_draw = false
						}
						else{
							categ_draw = true
							categ = i2
						}
					}
					else{
						//Se for clicado com botão esquerdo na lixeira
						if mouse_check_button_pressed(mb_left) {
						grid_items[# INFOS_PROG.ITEMS, pos_selecionada] = -1
						grid_items[# INFOS_PROG.REP, pos_selecionada] = -1
						grid_items[# INFOS_PROG.QTD, pos_selecionada] = -1
						item_selecionado = -1
						pos_selecionada = -1
						rep_selecionada = -1
						qtd_selecionada = -1

						}
					} 
					
			}
		_ix2++				
	}

		//Categoria selecionada = true
		 
		if categ_draw = true{
			var _ix1 = 0
			var _iy1 = 0
			var _categc = 4
			var _saco = 0
			if categ = 1{
				_categc = 2
				_ix1 = 1
				_saco = 17*scale
			}
			
			//Desenha o sprite da categoria
			if !(global.seq_run) draw_sprite_ext(spr_prog_categorias,categ+1,_invx1 + _saco,_invy1-categ_y,scale,scale,0,c_white,1)
			
			for (var i1 = 0; i1 < _categc; i1++){
				var _slotsx1 = _invx1  + comeco_x1 +((tamanho_slot + buffer)*_ix1)
				var _slotsy1 = _invy1 - categ_y  + comeco_y1 +((tamanho_slot + buffer)*_iy1)
	
				//Se o mouse passar pelos slots
				
				if point_in_rectangle(_mx,_my,_slotsx1, _slotsy1, _slotsx1 + tamanho_slot, _slotsy1 + tamanho_slot) and play == false and !(global.pause or instance_exists(obj_tutorial)) {
				if !(global.seq_run) draw_sprite_ext(spr_prog_coisa,0,_slotsx1,_slotsy1,scale,scale,0,c_white,1)
				
					//Se for clicado com botão esquerdo
					if mouse_check_button_pressed(mb_left) and grid_items[# INFOS_PROG.ITEMS, total_slots-2] == -1{
						ds_grid_add_item(i1 + (4 * categ))
				}
			}	
			_ix1++
		}
		
	}
	
#endregion		
#region //botão play
	var _sprite = 0
	//Posição do botão play
	var _px = _guil - minigame_l - play_l
	var _py = _guia - play_a
	//Variavel feita pra poder variar o sprite do botão play que n deu certo mas vou deixar aqui 
	if !(global.seq_run) draw_sprite_ext(spr_prog_play,2,_px,_py,scale,scale,0,c_white,1)
	
	if play = false{
		//Desenha o botão play
		if !(global.seq_run) draw_sprite_ext(spr_prog_play,_sprite,_px,_py,scale,scale,0,c_white,1)
	}
	
	//Se o mouse passar pelo botão play
	if !(global.pause or instance_exists(obj_tutorial)) {
		if point_in_rectangle(_mx,_my,_px, _py, _px + tamanho_slot*2, _py + tamanho_slot) and play = false{
			if !(global.seq_run) draw_sprite_ext(spr_prog_play,_sprite,_px,_py,scale,scale,0,c_gray,0.6)
		
			//Se for clicado com o botão esquerdo
			if mouse_check_button_pressed(mb_left){
			
				check = ds_grid_check()
				z = 0
				if z < check {
					play = true
					alarm[0] = 1
					
					categ_draw = false
				} 
				
			}
		}else{ 
		if point_in_rectangle(_mx,_my,_px, _py, _px + tamanho_slot*2, _py + tamanho_slot) and play = true{
		if !(global.seq_run) draw_sprite_ext(spr_prog_play,2,_px,_py,scale,scale,0,c_gray,0.6)
		if mouse_check_button_pressed(mb_left){
			room_restart()
			} 
	}
	}
}
#endregion


#region //tentativa de tela de morte
if mouse_check_button_pressed(mb_right) {
	item_selecionado = -1
	pos_selecionada = -1
}

if item_selecionado != -1{
	draw_sprite_ext(spr_prog_itens,item_selecionado,_mx,_my,scale,scale,0,c_white,0.5)
}
		
if clear = true{
	ds_grid_limpar()
	clear = false
}
}
	
	
var _buff = 22* (scale+1)
var _bufy = 18* (scale+1)

	
if draw = true {

	instance_create_layer(_guil/2,_guia/2,"Instances",obj_prog_restart)
	minigame = false
}

#endregion

if z <check+1 {
	if z != 0{
		draw_sprite_ext(spr_prog_coisa_clara,0,1280-minigame_l+1*scale,((buffer+ tamanho_slot)*(z-1))+1*scale,scale*3,scale+0,0,c_white,1)
	}
}
