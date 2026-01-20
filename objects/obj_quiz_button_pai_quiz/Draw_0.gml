draw_self()

draw_set_color(color)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)
var _txt_w = sprite_get_width(spr_quiz_button) * 2

draw_text_ext_transformed(x, y, texto, -1, _txt_w, scale_txt / 2, scale_txt / 2, image_angle)
//draw_line_width(x - _txt_w / 2, y, x + _txt_w / 2, y, 4)
