if veneno >50 and veneno<80{
	cor = c_orange
}
if veneno >80{
	cor = c_red
}

if irrigacao {
	draw_sprite_ext(spr_agro_bar_poison,0,10,10,2,1,0,c_white,1)
	draw_sprite_ext(spr_agro_bar_poison,0,10,10,veneno/50,1,0,cor,1)
	
	draw_set_color(c_black)
	draw_set_halign(fa_center)
	draw_set_font(fnt_dialogue)
	draw_text(room_width/2 - 30, 20, temp)
	draw_set_color(c_white)
	
	if !(global.pause or instance_exists(obj_tutorial)) temp -= 0.02;
}
if !irrigacao and !instance_exists(obj_agro_sprinkler) {
	draw_self()
	
	draw_set_color(c_black)
	draw_set_halign(fa_center)
	draw_set_font(fnt_dialogue)
	draw_text(x, y + 5, sementes)
	draw_set_color(c_white)
	draw_set_halign(-1)
}
