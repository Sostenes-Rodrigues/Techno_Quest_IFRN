if (global.pause or instance_exists(obj_tutorial)) exit;

obj_agro_bag.irrigacao = true

window_set_cursor(cr_none)
cursor_sprite = spr_agro_spray

instance_destroy(self)