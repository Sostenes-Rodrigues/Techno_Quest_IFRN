var _name_cource = ""
if global.sel_course == "info" {
	_name_cource = "informática"	
}
else if global.sel_course == "agro" {
	_name_cource = "agropecuária"	
}
else if global.sel_course == "manu" {
	_name_cource = "manutenção"	
}
else if global.sel_course == "quimic" {
	_name_cource = "química"	
}

var _prof = sprite_index
var _player = obj_int_player.sprite_index
dialogo =
{
	texto  : ["Oi, bom dia, você saberia onde fica a sala do 1° ano de " + _name_cource + "?", 
	"Ah, bom dia, é logo atrás de mim, 2ª porta virando à direita. Você é dessa turma?",
	"Sim sim, começo hoje.",
	"Mas você sabe que seu horário de aula só começa daqui a meia hora, né?",
	"Tô ligado, é que hoje peguei carona e acabei chegando mais cedo.",
	"Entendo, e como está sua expectativa em aprender por aqui?",
	"Sinceramente, não sei direito, principalmente referente às matérias do curso que escolhi.",
	"Por que diz isso?",
	"Por que acabei não dando muita importância para isso e acabei escolhendo só pelo nome.",
	"Sabe, atualmente um grupo está desenvolvendo um programa de simulador imersivo justamente sobre isso, se quiser posso configurar para demonstrar sobre o curso que escolheu.",
	"Que massa! Pode ser, não tenho o que fazer mesmo.",
	"Ótimo, é só entrar na sala à sua direita e iniciar o computador que está ligado."],
	retrato: [_player, _prof, _player, _prof, _player, _prof, _player, _prof, _player, _prof, _player, _prof],
	txt_vel: .4
};
