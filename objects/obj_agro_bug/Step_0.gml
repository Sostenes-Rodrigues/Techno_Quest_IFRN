if (global.pause or instance_exists(obj_tutorial)) {
	speed = 0
	image_speed = 0
}
else {
	speed = 2
	image_speed = 1
	
	///
	if instance_exists(obj_agro_seed){
		direction = point_direction(x,y,instance_nearest(x,y,obj_agro_seed).x,instance_nearest(x,y,obj_agro_seed).y)
		image_angle = direction
	}
	else{
		room_restart()
	}
}
