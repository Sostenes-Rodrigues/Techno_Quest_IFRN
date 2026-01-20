speed = 5

image_xscale = .8
image_yscale = .8

pdclica = true
draw = false


/// Testa se objeto A está totalmente dentro de B
is_inside = function(a, b) {
    // Pega limites do objeto A
    var left   = a.bbox_left;
    var right  = a.bbox_right;
    var top    = a.bbox_top;
    var bottom = a.bbox_bottom;

    // Testa 4 pontos extremos da máscara de A
    var corners_inside = (
        collision_point(left, top, b, false, true) and
        collision_point(right, top, b, false, true) and
        collision_point(left, bottom, b, false, true) and
        collision_point(right, bottom, b, false, true)
    );

    // Se todos os cantos de A estão dentro de B
    return corners_inside;
}

///
spr_ind = sprite_index
spr_proc = spr_agro_tomato_process
if room == rm_pecu4 {
	spr_ind = spr_pecu_meat
	spr_proc = spr_pecu_meat_process
}

spr_sub = 0
cont_proc = 0

control_sprite = function() {
	spr_ind = spr_proc
	spr_sub = cont_proc
	
	cont_proc ++
}


//
control_touch_machine = false
control_inter_this_time = false
