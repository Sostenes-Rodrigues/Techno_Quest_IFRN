//draw_set_color(c_black)
//draw_text(150,100,"Vacas Recolhidas " +  string(vacas_recohlidas))
//draw_set_color(c_white)

/// CONDICAO PARA PROXIMA ETAPA
if vacas_recohlidas >= 5 {
	room_goto(rm_pecu2)
	
	//
	audio_stop_sound(snd_pecu_walk_grass)
}
