///
if global.win_f {
	if window_has_focus() {
		window_set_fullscreen(true)
	}
	else {
		window_set_fullscreen(false)
	}
}
