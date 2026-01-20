view_xport[0] = random_range(-shake, shake)
view_yport[0] = random_range(-shake, shake)

// Suavizando
shake *= 0.95

if shake < 0.2 {
	instance_destroy()
	
	view_xport[0] = 0
	view_yport[0] = 0
}
