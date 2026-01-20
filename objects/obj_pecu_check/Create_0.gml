/// Criando o tutorial
if !global.tu_pass_pecu {
	global.tu_pass_pecu = true
	
	var _tu = instance_create_layer(0, 0, "Instances", obj_tutorial)
	with (_tu) {
		tutorial_imgs = [spr_pecu_tutorial1, spr_pecu_tutorial2, spr_pecu_tutorial3, spr_pecu_tutorial4]
		tutorial_string = ["Leve o gado para o currau enquanto desvia dos obstáculos usando as setinhas de cima e baixo ou W e S.",
		"Der diagnósticos para as vacas com algum problema, escolha entre \"pé dilúvio\" (um método para desinfectar os cascos), \"anti carrapato\" (dar banho com um produto que livra o animal dos carrapatos) e \"vacinação\" (se o animal apresentar manchas, aplique a vacina contra Dermatofilose).",
		"Tire o leite das vacas pressionando as tetas com o mouse, alterne entre elas para não sobrecarregar uma.",
		"Depois vá para a fábrica e processe os gados marcados para abate apertando \"espaço\" ou \"enter\" quando eles estiverem no meio de uma máquina."]
		
		tutorial_length = array_length(tutorial_imgs) - 1
	}
}



//
vacas_recohlidas = 0
