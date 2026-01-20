image_index = ponto

///
if !play_sound_win {
	play_sound_win = true
	if image_index == image_number - 1 {
		play_sound_geral(snd_mapc_windows_xp_startup)
	}
}
