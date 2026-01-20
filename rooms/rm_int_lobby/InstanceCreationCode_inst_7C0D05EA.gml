var _prof = sprite_index
var _player = obj_int_player.sprite_index

if global.per_com == 1 {
	dialogo =
	{
		texto  : ["Parabéns por ter passado de todos os desafios preparados para você!",
		"Valeu, foi até divertido, mas como faço para sair daqui?",
		"Verdade, você está com um pouco de pressa, é só passar pelo portão que está bem em cima de mim.",
		"Ok, a gente se vê por aí, tchau.",
		"Até."],
		retrato: [_prof, _player, _prof, _player, _prof],
		txt_vel: .4
	};
}
else {
dialogo =
	{
		texto  : ["CARA, O QUE É ISSO? QUE LUGAR É ESSE E O QUE ACONTECEU COM O MEU CORPO?", 
		"Se acalme, tudo aqui faz parte do simulador, seu corpo está em segurança na sala (ou não).",
		"Certo... mas e agora?",
		"Seguinte, em 3 cantos desse espaço, digamos que tem \"acionadores\" que o levarão cada um para uma experiência diferente, após terminar todos venha falar comigo para sair daqui.",
		"Beleza, mas e se eu demorar e tocar meu horário de aula?",
		"Então eu sugiro que não enrole para evitar isso."],
		retrato: [_player, _prof, _player, _prof, _player, _prof],
		txt_vel: .4
	};
}
