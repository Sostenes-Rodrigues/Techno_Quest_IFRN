#region Sistema de Pause

// Obtendo a largura da área de GUI
var _largura_da_gui = display_get_gui_width();

// Obtendo a altura da área de GUI
var _altura_da_gui = display_get_gui_height();

/* Definindo a coordenada x central do botão */
var _posicao_x_botao = _largura_da_gui / 2;

/* Definindo a coordenada y inicial do botão */
var _posicao_y_inicial_botao = _altura_da_gui / 3;

// Função para despausar o jogo


/* Verificando se o jogo está pausado para desenhar uma tela com texto */
if global.pause {
    /* Definindo a opacidade da tela criada */
    draw_set_alpha(.7);
	
    /* Desenhando uma tela para colocar os botões */
	draw_set_color(c_black)
    draw_rectangle(0, 0, _largura_da_gui, _altura_da_gui, false);
    
    /* Array para armazenar os textos dos botões */
    var _textos_dos_botoes = ["RESUME", "VOLTAR AO MENU", "SAIR DO JOGO"];
	var _button_functions = [funcao_resume, funcao_voltar, funcao_sair];
	
    /* Chamando a função para desenhar os botões na tela */
	// AJEITAR
    desenha_botoes(_posicao_x_botao, _posicao_y_inicial_botao, _textos_dos_botoes, _button_functions);
}
#endregion
