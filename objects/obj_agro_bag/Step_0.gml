if temp <= 0{
	instance_destroy(obj_agro_bug)
	instance_destroy(obj_agro_spawner)
	obj_agro_seed.germinar = true
	instance_create_layer(x,y,"Instances",obj_agro_check)
	instance_destroy(self)
}

if veneno >= 100 {
	window_set_cursor(cr_default)
	cursor_sprite = -1
	
	room_restart()
}
