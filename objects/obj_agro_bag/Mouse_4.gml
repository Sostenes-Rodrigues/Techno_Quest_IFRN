if (global.pause or instance_exists(obj_tutorial)) exit;


if irrigacao = false {
	if sementes > 0 {
		instance_create_layer(mouse_x,mouse_y,"Instances",obj_agro_seed)
		sementes -= 1
	}
}
