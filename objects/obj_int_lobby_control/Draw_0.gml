/// Trigger do 100% método usado no draw
if global.per_com == 1 {
	tri_delay--
	
	if tri_delay <= 0 {
		tri_delay = tri_delay_restart
		
		color_door_tri[0] = irandom_range(0, 255)
		color_door_tri[1] = irandom_range(150, 255)
		color_door_tri[2] = irandom_range(150, 255)
	}
	
	draw_set_color(make_colour_hsv(color_door_tri[0], color_door_tri[1], color_door_tri[2]))
	draw_rectangle(320, 432, 352, 479, false)
	draw_set_color(c_white)
}
