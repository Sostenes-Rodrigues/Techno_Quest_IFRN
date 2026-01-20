/// @description


///
if keyboard_check(vk_anykey) or mouse_check_button(mb_any) {
	cre_txt_spd = 6
}
else {
	cre_txt_spd = 1.5
}


draw_set_halign(fa_center)
draw_set_valign(fa_middle)

draw_set_color(c_black);
draw_set_alpha(0.75);
draw_rectangle(0, 0, 1920, 1080, 0);
draw_set_alpha(1);
credits_txt_y -= cre_txt_spd;



spacing = 0;
draw_set_font(font_credits_01);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + 2, string(credits_title[0]));
draw_set_color(c_white);
draw_text(1920/2, credits_txt_y, string(credits_title[0]));

spacing += 50
draw_set_font(font_credits_02);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_name[0]));
draw_set_color($5ed2ef);
draw_text(1920/2, credits_txt_y + spacing, string(credits_name[0]));



spacing += 120
draw_set_font(font_credits_01);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_title[1]));
draw_set_color(c_white);
draw_text(1920/2, credits_txt_y + spacing, string(credits_title[1]));

spacing += 50
draw_set_font(font_credits_02);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_name[1]));
draw_set_color($5ed2ef);
draw_text(1920/2, credits_txt_y + spacing, string(credits_name[1]));



spacing += 120
draw_set_font(font_credits_01);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_title[2]));
draw_set_color(c_white);
draw_text(1920/2, credits_txt_y + spacing, string(credits_title[2]));

spacing += 50
draw_set_font(font_credits_02);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_name[2]));
draw_set_color($5ed2ef);
draw_text(1920/2, credits_txt_y + spacing, string(credits_name[2]));



spacing += 120
draw_set_font(font_credits_01);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_title[3]));
draw_set_color(c_white);
draw_text(1920/2, credits_txt_y + spacing, string(credits_title[3]));

spacing += 50
draw_set_font(font_credits_02);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_name[3]));
draw_set_color($5ed2ef);
draw_text(1920/2, credits_txt_y + spacing, string(credits_name[3]));



spacing += 120
draw_set_font(font_credits_01);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_title[4]));
draw_set_color(c_white);
draw_text(1920/2, credits_txt_y + spacing, string(credits_title[4]));

spacing += 50
draw_set_font(font_credits_02);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_name[4]));
draw_set_color($5ed2ef);
draw_text(1920/2, credits_txt_y + spacing, string(credits_name[4]));



spacing += 120
draw_set_font(font_credits_01);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_title[5]));
draw_set_color(c_white);
draw_text(1920/2, credits_txt_y + spacing, string(credits_title[5]));

spacing += 50
draw_set_font(font_credits_02);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_name[5]));
draw_set_color($5ed2ef);
draw_text(1920/2, credits_txt_y + spacing, string(credits_name[5]));



spacing += 120
draw_set_font(font_credits_01);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_title[6]));
draw_set_color(c_white);
draw_text(1920/2, credits_txt_y + spacing, string(credits_title[6]));

spacing += 50
draw_set_font(font_credits_02);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_name[6]));
draw_set_color($5ed2ef);
draw_text(1920/2, credits_txt_y + spacing, string(credits_name[6]));



spacing += 120
draw_set_font(font_credits_01);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_title[7]));
draw_set_color(c_white);
draw_text(1920/2, credits_txt_y + spacing, string(credits_title[7]));

spacing += 50
draw_set_font(font_credits_02);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_name[7]));
draw_set_color($5ed2ef);
draw_text(1920/2, credits_txt_y + spacing, string(credits_name[7]));



spacing += 120
draw_set_font(font_credits_01);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_title[8]))
draw_set_color(c_white);
draw_text(1920/2, credits_txt_y + spacing, string(credits_title[8]))

spacing += 50
draw_set_font(font_credits_02);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_name[8]))
draw_set_color($5ed2ef);
draw_text(1920/2, credits_txt_y + spacing, string(credits_name[8]))



spacing += 120
draw_set_font(font_credits_01);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_title[9]))
draw_set_color(c_white);
draw_text(1920/2, credits_txt_y + spacing, string(credits_title[9]))

spacing += 50
draw_set_font(font_credits_02);
draw_set_color(c_black);
draw_text(1920/2 + 2, credits_txt_y + spacing + 2, string(credits_name[9]))
draw_set_color($5ed2ef);
draw_text(1920/2, credits_txt_y + spacing, string(credits_name[9]))




spacing += 350


txt_thanks = credits_txt_y + spacing;
txt_thanks = clamp(txt_thanks, 1080/2, 5000);
draw_set_font(font_credits_01);
draw_set_color(c_black);
draw_text(1920/2 + 2, txt_thanks + 2, string(credits_title[10]));
draw_set_color(c_white);
draw_text(1920/2, txt_thanks, string(credits_title[10]));


/// Condição de finalização
if txt_thanks == 1080/2 {
	if !alarm_call {
		alarm_call = true
		
		alarm[0] = 220
	}
}
