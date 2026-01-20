if draw = true{
	draw_set_font(fnt_mapc);
    draw_set_color(c_white);
    draw_set_halign(-1);
    draw_set_valign(-1);
	draw_text(x,y+sprite_height,obj_mapc_controle.lista[tipo_definido])
}
draw_self()