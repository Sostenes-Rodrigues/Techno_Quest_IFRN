/// @description Explosão radiativo (no descarte esse evento é pulado)
var _control = obj_desc_controle
var _shake_amount = 15
var _shake_duration = 0.3 * game_get_speed(gamespeed_fps)

// Se o obj controle existe
if instance_exists(_control) {
	// Aumenta muito a poluição
	_control.poluicao += quant_polui * 4
	
	/// Ativando o Screen Shake
	_control.shake_amount   = _shake_amount
	_control.shake_duration = _shake_duration
	
	// Som da explosão
	play_sound_geral(snd_desc_smoke_explosion)
	
	#region Criando a particula de poluição
	// Deixando a paricula durar mais tempo
	part_type_life(_control.particle, 22, 38)
	
	// Setando a posição do emitter
	part_emitter_region(_control.part_sys, _control.part_em, x - 20,  x + 20, y - 5, y + 5, ps_shape_rectangle, ps_distr_gaussian)

	// Fazendo o emitter criar uma particula
	part_emitter_burst(_control.part_sys, _control.part_em, _control.particle, 30)
	
	// Voltando a duração normal
	part_type_life(_control.particle, 12, 22)
	
	#endregion
}
