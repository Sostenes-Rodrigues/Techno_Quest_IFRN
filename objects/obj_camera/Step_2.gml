/// @description camera moving

// Window_center(); delete if not needed, lets the window always stick to the middle
camera_set_view_size(view_camera[0], camera_Show_Width, camera_Show_Height   )  // Zoom, change width and height of camera


// Moving of the camera according to the target set and the level border
if (instance_exists(target)) and !global.seq_run_out { 
	
	/// Get x and y position of target and don't show anything outside of room
	var cameraX =  clamp(target.x - camera_Show_Width/2,  0, room_width  - camera_Show_Width)
	var cameraY =  clamp(target.y - camera_Show_Height/2, 0, room_height - camera_Show_Height - view_y_menu_effect)
	
	
	/// Get current value of camera to get smooth value between old position and target position
	var current_x = camera_get_view_x(view_camera[0])
	var current_y = camera_get_view_y(view_camera[0])
	
	//
	var SmoothScrollSpeed = 0.1
	
	var _x_set = (room == rm_int_ifrn_class) ? -64 : lerp(current_x, cameraX, SmoothScrollSpeed)
	
	// Smooth scrollspeed and set new positon of camera
	camera_set_view_pos(view_camera[0], _x_set, lerp(current_y, cameraY, SmoothScrollSpeed))
}



//show_debug_message(camera_get_view_x(view_camera[0]))
//show_debug_message(camera_get_view_y(view_camera[0]))

/// ATTENTION ///
if window_has_focus() {
	if surface_get_width(application_surface) != display_get_width() {
		surface_resize(application_surface, display_get_width(), display_get_height())
	}
}
