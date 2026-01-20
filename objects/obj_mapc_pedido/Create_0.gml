//Escala do sprite
escala_y = 1.7
escala_x = 1.7

//Cordenadas para os sprites dos obj em relação ao pedido
comeco_x = -11
comeco_y = 30


slots_h = 8
slots_v = 3
total_slots = slots_h * slots_v
tamanho_slot = 64 * escala_y
buffer = 25* escala_y

grid_l = sprite_get_width(spr_mapc_pedido) * escala_x
grid_a = sprite_get_height(spr_mapc_pedido) * escala_y




pedidos = ds_grid_create(INFOS_MAPC.ALTURA,total_slots)
ds_grid_set_region(pedidos,0,0,1, total_slots-1,-1)


for (var _i = 0; _i < obj_mapc_controle.tamanho; _i++ ){
	pedidos[# INFOS_MAPC.ITEM, _i] = obj_mapc_controle.items[_i]
	pedidos[# INFOS_MAPC.QUANTIDADE, _i] = obj_mapc_controle.quantidade[_i]
	pedidos[# INFOS_MAPC.MODELO, _i] = obj_mapc_controle.modelo[_i]

}




