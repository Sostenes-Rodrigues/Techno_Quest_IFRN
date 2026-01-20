draw_self()

if obj_pecu_vaca_stats.doente = true{
	image_index = 1
}
if obj_pecu_vaca_stats.suja = true{
	image_index = 3
}
if obj_pecu_vaca_stats.casco = true{
	image_index = 2
}

if obj_pecu_vaca_stats.doente = false and obj_pecu_vaca_stats.suja = false and obj_pecu_vaca_stats.casco = false{
	image_index = 0
}