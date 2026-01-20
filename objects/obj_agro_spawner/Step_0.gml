if (global.pause or instance_exists(obj_tutorial)) {
	alarm[0] += 1;
}
else {
	if obj_agro_bag.irrigacao = true{
		if tick = true{
			alarm[0] = irandom_range(180,330)
			tick = false
		}
	}
}
