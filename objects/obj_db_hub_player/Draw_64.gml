var _agro = player.c_agro
var _info = player.c_info
var _qui = player.c_quimic
var _manu = player.c_manu

if _agro == 1{
	_agro = "Completo"
}
else{
	_agro = "Incompleto"
}

if _info == 1{
	_info = "Completo"
}
else{
	_info = "Incompleto"
}

if _qui == 1{
	_qui = "Completo"
}
else{
	_qui = "Incompleto"
}

if _manu == 1{
	_manu = "Completo"
}
else{
	_manu = "Incompleto"
}


if desenha and !global.seq_run {
	draw_set_color(c_black)
	draw_set_halign(-1)
	draw_set_valign(-1)
	draw_set_alpha(1)
	draw_text(room_width -180, 20, 
	player.nome + "\n" + 
	
	string(player.idade) + " anos" + "\n"+
	
	player.cidade + "\n" +
	
	"Cursos completos:" + "\n" +
	"Agro" + " " + _agro + "\n" +
	"Info" + " " + _info + "\n" +
	"Quimc" + " " + _qui + "\n" +
	"Manu" + " " + _manu + "\n" 
	)
	
	draw_set_color(-1)
	draw_set_alpha(0.4)
	draw_rectangle(display_get_gui_width() -180,20,display_get_gui_width()-5,200,false)
	draw_set_alpha(1)
}
