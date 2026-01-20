if (global.pause or instance_exists(obj_tutorial)) exit;


var _spd = inputSlow ? 1 : moveSpeed;
moveX = inputX * _spd;
moveY = inputY * _spd;

x += moveX;
y += moveY;
x = clamp(x, 76, room_width - 76)

if moveX =0 and moveY < 0 {
	//image_angle = 0	  
	dir = 0				  
}						  
if moveX >0 and moveY < 0 {
	image_xscale = 2
	//image_angle = -45	  
	dir = 1				  
}						  
if moveX >0 and moveY = 0 {
	image_xscale = 2
	//image_angle = -90	  
	dir = 2				  
}						  
if moveX >0 and moveY > 0 {
	image_xscale = 2
	//image_angle = -135  
	dir = 3				  
}						  
if moveX =0 and moveY > 0 {
	//image_angle = 180	  
	dir = 4				  
}						  
if moveX <0 and moveY > 0 {
	image_xscale = -2
	//image_angle = 135	  
	dir = 5				  
}						  
if moveX <0 and moveY = 0 {
	image_xscale = -2
	//image_angle = 90	  
	dir = 6				  
}						  
if moveX <0 and moveY < 0 {
	image_xscale = -2
	//image_angle = 45
	dir = 7
}
