// Pegando o lixo que está em contato com ele
var _lixo = instance_place(x, y, obj_desc_lixo)

// Se um lixo tocou nele
if _lixo {
	// Se ele estiver no estado solto
	if _lixo.estado_txt == "solto" {
		/// Se o obj controle existe
		var _control = obj_desc_controle
		if instance_exists(_control) {
			// Se os dois tiverem o tipo diferente
			if tipo != _lixo.tipo {
				// Aumenta a polução pelo erro
				_control.poluicao += _control.poluicao_erro
				
				/// Ativando o Screen Shake
				_control.shake_amount = shake_amount
				_control.shake_duration = shake_duration
				
				// Som do erro
				audio_play_sound(snd_desc_smoke, 10, false, 1, 0.17)
				
				/// Partículas de poluição
				// Setando a posição do emitter
				var _x = x + sprite_width / 2
				var _y = y + 10
				part_emitter_region(_control.part_sys, _control.part_em, _x - 20,  _x + 20, _y - 5, _y + 5, ps_shape_rectangle, ps_distr_gaussian)
	
				// Fazendo o emitter criar uma particula
				part_emitter_burst(_control.part_sys, _control.part_em, _control.particle, 20)
				
			}
			else {
				// Som do acerto
				audio_play_sound(snd_desc_correct, 10, false, 0.4, 0, 2.2)
			}
			
			// Descarta o lixo, sem ativar o evento destroy
			instance_destroy(_lixo, false)	
		}	
	}
}
