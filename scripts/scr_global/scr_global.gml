#region Variaveis Globais
// Variavel global para saber se o jogo deve mostrar os debugs
global.debug = false

// Qual espaço de save o player está jogando atualmente
global.index_save = -1

// Qual o curso do save atual
global.sel_course = "info"
// Porcentagem de conclusão do save atual
global.per_com = 0

// Variavel global que controla se o jogo está pausado
global.pause = false

// Se o jogador foi para os créditos pelo menu
global.menu_to_cred = true

// Se o jogo já foi terminado pelo menos uma vez
global.com_game = false

#region Sequences
/// Variavel global que indica a proxima sala
global.next_room = rm_int_ifrn_outside
global.next_room_posx = 0
global.next_room_posy = 0
global.next_room_with_player = true

// Se estiver rodando qualquer sequencia
global.seq_run = false

// True enquanto no intervalo de começar a seq de saida e a real troca de room
global.seq_run_out = false
#endregion

#region Conf dos elementos controlados pelos menus
global.sounds_geral_per = .7
global.sounds_music_per = .6

//
global.win_f = true

//global.enable_heavy_effects = true
#endregion

#region Variaveis para não repassar os tutoriais
global.tu_pass_quiz = false
global.tu_pass_prog1 = false
global.tu_pass_prog3 = false
global.tu_pass_prog4 = false
global.tu_pass_html = false
global.tu_pass_agro = false
global.tu_pass_pecu = false
global.tu_pass_reci = false
global.tu_pass_mole = false
global.tu_pass_pcma = false
global.tu_pass_rede = false
#endregion
#endregion
