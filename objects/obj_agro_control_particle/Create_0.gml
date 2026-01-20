/// Create ///
/* Um sistema de particulas consiste em 3 elementos
1 - Sistema de particulas (part system) - Cuida de tudo
2 - Emissor de particulas (part emitter) - Cria as particulas
3 - A particula (part) - É a particula
*/

// Criando o meu sistema de particulas
part_sys = part_system_create()
part_system_depth(part_sys, -500)

// Criando o meu emissor de particulas
part_em = part_emitter_create(part_sys)

part_emitter_region(part_sys, part_em, 0, 0, 0, 0, ps_shape_ellipse, ps_distr_invgaussian)

#region Particula "COOL"
// Criando a minha particula
particle_cool = part_type_create()

/// Definindo as caracteristicas da part
// Sprite
part_type_shape(particle_cool, pt_shape_flare);

/// Cor e alpha, inicio, meio e fim
var _color1 = make_color_rgb(255, 255, 255)
var _color2 = make_color_rgb(255, 255, 255)
var _color3 = make_color_rgb(255, 255, 255)
var _alpha1 = 1
var _alpha2 = .85
var _alpha3 = .59
part_type_colour3(particle_cool, _color1, _color2, _color3);
part_type_alpha3(particle_cool, _alpha1, _alpha2, _alpha3)
part_type_blend(particle_cool, true)

// Frames de duração
part_type_life(particle_cool, 15, 25);

// Escala X e Y da sprite
part_type_scale(particle_cool, 1, 1)

// Mudanças do tamanho da part
part_type_size(particle_cool, 0.5, 0.6, -0.03, .3);

// Mudanças da velocidade da part
part_type_speed(particle_cool, 5, 6, 0, 0);

// Força da gravidade e direção
part_type_gravity(particle_cool, 0, 270);

// Mudanças da direção da part
part_type_direction(particle_cool, 30, 150, 0, .2);

// Mudanças da orientação da part
part_type_orientation(particle_cool, 275, 280, 0, .3, true);
#endregion

#region Particula "PERFECT"
// Criando a minha particula
particle_perfect = part_type_create()

/// Definindo as caracteristicas da part
// Sprite
part_type_shape(particle_perfect, pt_shape_star);

/// Cor e alpha, inicio, meio e fim
_color1 = make_color_rgb(250, 255, 10)
_color2 = make_color_rgb(243, 255, 28)
_color3 = make_color_rgb(255, 251, 33)
_alpha1 = 1
_alpha2 = .85
_alpha3 = .59
part_type_colour3(particle_perfect, _color1, _color2, _color3);
part_type_alpha3(particle_perfect, _alpha1, _alpha2, _alpha3)
part_type_blend(particle_perfect, true)

// Frames de duração
part_type_life(particle_perfect, 15, 25);

// Escala X e Y da sprite
part_type_scale(particle_perfect, 1, 1)

// Mudanças do tamanho da part
part_type_size(particle_perfect, 0.5, 0.6, -0.03, .3);

// Mudanças da velocidade da part
part_type_speed(particle_perfect, 5, 6, 0, 0);

// Força da gravidade e direção
part_type_gravity(particle_perfect, 0, 270);

// Mudanças da direção da part
part_type_direction(particle_perfect, 30, 150, 0, .2);

// Mudanças da orientação da part
part_type_orientation(particle_perfect, 275, 280, 0, .3, true);
#endregion

/* Outras funções "part_type"
part_type_death()
part_type_exists()
part_type_size_x()
part_type_size_y()
part_type_sprite()
part_type_step()
part_type_subimage()
part_type_clear()


