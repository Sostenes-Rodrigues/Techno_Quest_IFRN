// verificacao de pause
if (global.pause or instance_exists(obj_tutorial)) exit;

#region Animação da interração do botão

if position_meeting(mouse_x,mouse_y,self) {
	if !mouse {
		mouse = true

		scale = 2.4
		scale_txt = 2.2

		image_xscale = scale
		image_yscale = scale

		mudanca_angle = mudanca_angle_save
	}
}
else {
	if mouse {
		mouse = false

		scale = 2.2
		scale_txt = 2

		image_xscale = scale
		image_yscale = scale
	}
}

if mouse {
	image_angle += mudanca_angle
	if image_angle >= 6 {
		mudanca_angle = -mudanca_angle
	}
	if image_angle <= -6 {
		mudanca_angle = -mudanca_angle
	}
}
else {
	/*
	if image_angle != 0 {
		if mudanca_angle == mudanca_angle_save and image_angle > 0 {
			image_angle -= mudanca_angle
		}
		if mudanca_angle == -mudanca_angle_save and image_angle < 0 {
			image_angle += mudanca_angle
		}
	}
	*/
	image_angle = 0
}

#endregion
