if (global.pause or instance_exists(obj_tutorial)) exit;

if carregando = true{
	x = mouse_x
	y = mouse_y
}
colisao = false


if germinar = true{
	instance_create_layer(x,y,"Instances",obj_agro_plant)
	instance_destroy(self)
}

depth = -y
