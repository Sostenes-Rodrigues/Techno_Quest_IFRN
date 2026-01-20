if can_pressed {


	if (global.pause or instance_exists(obj_tutorial)) exit;

	if processador = true{

		var _xc = inst_processador.x+1
		var _yc = inst_processador.y
	
		inst_processador.x = 10000
		inst_processador.y = 10000

		inst_cooler.x = _xc
		inst_cooler.y = _yc

		ponto = inst_processador.ponto
		processador = false
	}else{

	if processador = false{
		var _xp = inst_cooler.x-1
		var _yp = inst_cooler.y

		inst_cooler.x = 10000
		inst_cooler.y = 10000


		inst_processador.x = _xp
		inst_processador.y = _yp

		ponto = 0
		processador = true
	}}
}