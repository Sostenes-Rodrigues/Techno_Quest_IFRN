if carregando {
	draw_self()
}

if germinar = false{
	if obj_agro_bag.irrigacao = true{
		cor = c_maroon
	}
	if carregando = false {
		//draw_sprite(spr_agro_earth,0,x,y)
		//draw_sprite_ext(spr_agro_earth, 0 ,x ,y + 4 , 2 ,2 ,0 ,cor ,1 )
		sprite_index = spr_agro_earth
		image_xscale = 2
		image_yscale = 2
		draw_self()
		image_xscale = 1
		image_yscale = 1
	}
}

draw_set_color(c_red)
draw_set_alpha(.2)
draw_circle(x, y, 32, false)
draw_set_color(c_white)
draw_set_alpha(1)
