/// @description Actions

// Se não é para desenhar o menu ou se é outra parte do menu sem ser o inicial, pulo o resto do código
if (!can_menu or is_string(now_menu)) exit;

// Change menu item selected
var _change = keyboard_check_pressed(menu_down_buttom) - keyboard_check_pressed(menu_up_buttom)
// Salvo o botão anteriomente selecionado
previous_selected = selected;

// If there is change...
if _change != 0 {
	/// Impedir que ultrapasse o limite
	selected = (selected + _change - _change * menu_control_mouse) % ds_list_size(now_menu)
	if (selected <= -1) selected = ds_list_size(now_menu) - 1;
	
	
	/// Se diferente do ultimo, som do passe
	if selected != previous_selected {
		play_sound_geral(snd_int_menu_select)
	}
}

// Reseto o controle pelo mouse
menu_control_mouse = false

// when enter pressed, do what need to do based on the selected menu item
// IMPORTANT: in the step event, in the "cases" of "switch(selected)", you must enter the code of what the menu will do.
if keyboard_check_pressed(menu_confirmation_buttom) {
	// Limpa os inputs
	io_clear()
	// Função do botão acionado
	action_buttons()
}

// Se o grupo de música carregou
if audio_group_is_loaded(audiogroup_music) {
    // Tocando a música da introdução
	play_sound_music(snd_int_menu_music_theme)
}
