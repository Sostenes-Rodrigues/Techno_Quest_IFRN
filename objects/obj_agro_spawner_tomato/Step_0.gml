if (global.pause or instance_exists(obj_tutorial)) {
	obj_agro_tomato.speed = 0
	alarm[0] += 1
}
else {
	if instance_exists(obj_agro_tomato) {
		obj_agro_tomato.speed = 5 * last_spd
	}
}
