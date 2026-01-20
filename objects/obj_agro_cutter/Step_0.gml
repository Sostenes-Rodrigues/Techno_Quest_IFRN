depth = obj_agro_tractor.depth

if obj_agro_tractor.dir = 0{
	//x = obj_agro_tractor.x 
	y = obj_agro_tractor.y
}

if obj_agro_tractor.dir = 1 {
	x = obj_agro_tractor.x -64
	y = obj_agro_tractor.y
}

if obj_agro_tractor.dir = 2{
	x = obj_agro_tractor.x -64
	y = obj_agro_tractor.y 
}

if obj_agro_tractor.dir = 3{
	x = obj_agro_tractor.x -64
	y = obj_agro_tractor.y
}

if obj_agro_tractor.dir = 4{
	//x = obj_agro_tractor.x
	y = obj_agro_tractor.y
}

if obj_agro_tractor.dir = 5{
	x = obj_agro_tractor.x +64
	y = obj_agro_tractor.y
}

if obj_agro_tractor.dir = 6{
	x = obj_agro_tractor.x +64
	y = obj_agro_tractor.y 
}

if obj_agro_tractor.dir = 7{
	x = obj_agro_tractor.x +64
	y = obj_agro_tractor.y
}
x = clamp(x, 48, 1230)
