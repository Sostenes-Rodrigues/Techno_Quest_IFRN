/// @description O minigame ta acontecendo?
//Se algo acontecer, minigame inicia
if !instance_exists(obj_prog_objetivo) {
	minigame = false
}


///
if (global.pause or instance_exists(obj_tutorial)) {
	if alarm[0] != -1 {
		alarm[0] ++
	}
	if alarm[1] != -1 {
		alarm[1] ++
	}
	if alarm[2] != -1 {
		alarm[2] ++
	}
}
