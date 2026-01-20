if pass = true {
	image_speed = 1
	banho += 10
}
else{
	image_speed = 0
}

if banho >= 300{
	obj_pecu_vaca_stats.doente = false
	obj_pecu_vaca_stats.pdativa = true
	instance_destroy(self)}