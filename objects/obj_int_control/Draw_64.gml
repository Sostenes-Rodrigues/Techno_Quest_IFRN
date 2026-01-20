/// @description Draw menu items
if (can_menu) draw_menu(now_menu);


/// Mostrando od controles ao inicial o jogo
if !global.pause and !global.seq_run {
	if (is_string(show_controls)) draw_show_controls(show_controls);
}
