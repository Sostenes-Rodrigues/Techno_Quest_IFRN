if draw = true{
	var _x = obj_agro_tomato.x
	var _y = obj_agro_tomato.y
	with(obj_agro_control_particle) {
		// Setando a posição do emitter
		part_emitter_region(part_sys, part_em, _x,  _x, _y, _y, ps_shape_ellipse, ps_distr_invgaussian)
	
		// Fazendo o emitter criar uma particula
		part_emitter_burst(part_sys, part_em, particle_cool, 20)
		
		// Feedback sonoro
		play_sound_geral(snd_agro_rit_good)
	}
	
	draw = false
}

//draw_self()