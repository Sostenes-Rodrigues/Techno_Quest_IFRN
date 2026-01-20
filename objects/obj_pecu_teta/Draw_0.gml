image_blend = make_colour_rgb(255,esforco,esforco)

image_yscale = 6 - esforco/255

draw_self()

if (global.pause or instance_exists(obj_tutorial)) exit;

if esforco + 1 <=255{
	esforco +=	1
}

if draw {
	draw_sprite(spr_pecu_leite,0,x,y + 38 * image_yscale)
}
