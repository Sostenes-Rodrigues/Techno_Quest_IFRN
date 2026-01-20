//movimento
if time > 0{
	x += vh
	y += vv
	
	time --;
}
else{
	vh = 0
	vv = 0
}


// direção
if dir == 0 {//cima
	v = -64 
	h = 0   
	sprite_index = spr_prog_robo_cima
}		    
if dir == 1 {//esquerda
	v = 0   
	h = -64 
	sprite_index = spr_prog_robo_esquerda
}		    
if dir == 2 {//baixo
	v = 64  
	h = 0   
	sprite_index = spr_prog_robo_baixo
}		    
if dir == 3 {//direita
	v = 0
	h = 64
	sprite_index = spr_prog_robo_direita
}
