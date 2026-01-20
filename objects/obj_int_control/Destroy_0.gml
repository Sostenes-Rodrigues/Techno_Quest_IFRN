/// Destroy the list for the menu
ds_list_clear(menu)
ds_list_destroy(menu)
ds_list_clear(sub_menu_option)
ds_list_destroy(sub_menu_option)

//
if (room == rm_int_ifrn_outside or room == rm_int_lobby) save_data("last_rm", room_get_name(room));

// Para a música da indrodução e depois em um momento toca a música do lobby
audio_stop_sound(snd_int_menu_music_theme)
