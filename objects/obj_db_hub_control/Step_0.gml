//
if timer_query >= timer_query_max {
	/// Recarregar
	if keyboard_check_released(ord("R")) and data == -1 {
		// Chama o Query
		FirebaseFirestore(root).Query()
		
		//
		timer_query = 0
	}
}
else {
	timer_query++
}

//
if data != -1 {
	// 
	create_npcs()
}
