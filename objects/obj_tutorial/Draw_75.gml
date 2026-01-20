draw_set_color(c_black)
draw_set_alpha(.4)
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false)
draw_set_color(c_white)
draw_set_alpha(1)

/// Rodando a UI do tutorial
if (global.seq_run) exit;
tu_alp_acel = lerp(tu_alp_acel, .6, .02)
tu_alp = lerp(tu_alp, 1, tu_alp_acel)
draw_set_alpha(tu_alp)
tutorial_ui()
draw_set_font(-1)
draw_set_alpha(1)
