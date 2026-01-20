last_spd = random_range(.85, 1.05)
var _inst = instance_create_layer(x,y,"Instances_1",obj_agro_tomato)
_inst.speed = 5 * last_spd
tmts += 1
alarm[0] = 240 / last_spd
