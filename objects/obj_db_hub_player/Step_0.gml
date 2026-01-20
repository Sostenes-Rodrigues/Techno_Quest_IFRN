depth = -y

if segurando{
	x = mouse_x
	y = mouse_y
	//sprite_index = spr_personagem
	exit 
}

///////////////////////////////////////////////////
if saudacao = true{

		
	st-= 1
	if st<0{
	st = 15* game_get_speed(gamespeed_fps)
	saudacao = false
	}
}
////////////////////////////////////////////////////

if direcao!= 2{// caso ocorra do personagem interagir com outro um deles vai pegar uma direção que melhor se adequa a situação
	speed = 3
if direcao = 0 and x >= otherx {
			speed = 0
			direcao = 2 
			//sprite_index = sprite3
			// SPRITE DA SAUDAÇÃO
			//instance_nearest(otherx-100,y,obj_db_hub_player).sprite_index = sprite3
			xescala = -2
		}
	if direcao = 1 and x<= otherx{
			speed = 0
			direcao = 2
			//sprite_index = sprite3
			//instance_nearest(otherx+100,y,obj_db_hub_player).sprite_index = sprite3
			xescala = -2
			
	}

}

/////////////////////////////////////////////////////
if tempo>0{
	tempo-=1
}
else{
	decidir = !decidir
	if decidir = true{
		movimento = true
		decision = true
	}
	if decidir = false{
		parado = true
	}
	tempo = irandom_range(1,2) * game_get_speed(gamespeed_fps)
}
////////////////////////////////////////////////////////////////



if movimento = true{
	if decision = true{
		decisao()
}
	decision = false
	movimento = false
	speed = 1
	if direction >270 or direction < 90{
		xescala = 2
	}
	else{
		xescala = -2
	}
}

if parado = true{
	speed = 0
	//sprite_index = spr_personagem
	parado = false
}

//////////////////////////////////////////////////////////////////


/// Inperdindo que ele saia da room
// Horizontal
if x - (sprite_width / 2) <= 0 or x + (sprite_width / 2) >= room_width {
	hspeed *= -1
}
// Vertical
if y - (sprite_height / 2) <= 0 or y + (sprite_height / 2) >= room_height {
	vspeed *= -1
}

if xescala = -2{
	
}
else{
xescala = lerp(xescala, 2,0.4)
yescala = lerp(yescala, 2,0.4)
}


//////////////////////////////////////
