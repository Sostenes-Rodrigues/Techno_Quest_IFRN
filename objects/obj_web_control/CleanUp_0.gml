// Garantindo a destruição do obj que faz o panel do Color Picker
instance_destroy(curt.cp)

/// Limpando e destruindo a ds grid das ferramentas
ds_grid_clear(grid_feramentas, 0)
ds_grid_destroy(grid_feramentas)

/// Libera a memória da surface
surface_free(surf_painting)
surface_free(surf_overlay)

/// Garantindo que as sprites de save estão deletadas
if sprite_exists(sprite_painting_backup) {
	sprite_delete(sprite_painting_backup)
}
if sprite_exists(sprite_overlay_backup) {
	sprite_delete(sprite_overlay_backup)
}