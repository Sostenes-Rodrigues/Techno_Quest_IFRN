/// Limpando o sistema de particulas, NESSA ORDEM
part_type_destroy(particle_cool)
part_type_destroy(particle_perfect)
part_emitter_destroy(part_sys, part_em)
part_system_destroy(part_sys)
