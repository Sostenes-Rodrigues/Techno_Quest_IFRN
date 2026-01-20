/// Criando o tutorial
if !global.tu_pass_quiz {
	global.tu_pass_quiz = true
	
	var _tu = instance_create_layer(0, 0, "Instances", obj_tutorial)
	with (_tu) {
		tutorial_imgs = [spr_quiz_tutorial1, spr_quiz_tutorial2, spr_quiz_tutorial3]
		tutorial_string = ["Escolha usando o click esquerdo do mouse a resposta correta da pergunta entre 4 alternativas.",
		"Erros resultaram em redução do seu número de vidas, se suas vidas acabem o jogo reiniciará.",
		"O jogo também irar reiniciar caso o tempo límite esgote (não adianta pausar o jogo, espertinho)."]
		
		tutorial_length = array_length(tutorial_imgs) - 1
	}
}


/// Música
if !(audio_is_playing(snd_quiz_soundtrack)) play_sound_music(snd_quiz_soundtrack);

/// Lista das perguntas do minigame do quiz
#region Info
var quiz_lista_data_info = [
    ["O que significa a sigla 'CPU'?", 0, ["Unidade Central de Processamento", "Unidade de Controle de Periféricos", "Computador Pessoal Universal", "Central de Programas Úteis"]],
    ["Qual dessas é uma linguagem de programação?", 1, ["HTML", "Python", "Windows", "Google"]],
    ["Qual parte do computador é responsável por armazenar dados permanentemente?", 2, ["Memória RAM", "Placa de vídeo", "HD/SSD", "Fonte de energia"]],
    ["O que é um sistema operacional?", 3, ["Um tipo de hardware", "Um antivírus", "Um aplicativo de música", "Um software que gerencia o computador"]],
	["O que é um computador?", 1, ["Uma TV moderna", "Uma máquina capaz de processar informações", "Um tipo de videogame", "Um aparelho para assistir filmes"]],
    ["O que é um arquivo?", 2, ["Um vírus", "Uma senha", "Um conjunto de dados armazenados", "Um programa de musica"]],
    ["O que é a Internet?", 1, ["Um cabo de energia", "Uma rede mundial de computadores", "Um jogo online", "Um aplicativo de mensagens"]],
    ["Qual destes é um navegador de internet?", 0, ["Google Chrome", "Excel", "Paint", "Discord"]],
    ["O que é programação?", 3, ["Fazer download de jogos", "Editar vídeos", "Formatar o computador", "Dar instruções para o computador executar tarefas"]],
    ["O que é vírus de computador?", 2, ["Um arquivo de música", "Um programa de edição", "Um software malicioso", "Um cabo defeituoso"]],
    ["Qual atitude ajuda a manter a segurança online?", 3, ["Postar senhas em redes sociais", "Clicar em qualquer link", "Instalar programas desconhecidos", "Usar senhas fortes"]],
    ["O que é Wi-Fi?", 0, ["Internet sem fio", "Tipo de vírus", "Programa de edição", "Peça interna do PC"]],
    ["Qual software serve para criar textos?", 2, ["VLC", "Chrome", "Word", "Discord"]],
    ["O que é um backup?", 1, ["Deletar tudo do PC", "Fazer uma cópia dos arquivos", "Formatar a máquina", "Instalar programas novos"]],
    ["O que é um hacker?", 3, ["Alguém que repara computadores", "Um técnico de redes", "Um antivírus avançado", "Alguém que invade sistemas com técnicas avançadas"]],
    ["Qual destes dispositivos armazena arquivos?", 0, ["Pen drive", "Monitor", "Teclado", "Mousepad"]],
    ["O que é lógica de programação?", 1, ["Montar um computador", "Pensar de forma organizada para resolver problemas", "Formatar o HD", "Desenhar no Paint"]],
    ["Qual comando é usado para copiar um arquivo?", 2, ["CTRL + Z", "CTRL + S", "CTRL + C", "CTRL + P"]],
    ["O que é um algoritmo?", 3, ["Um tipo de vírus musical", "Um erro do computador", "Um aplicativo de wifi", "Um conjunto de passos para resolver um problema"]],
    ["Qual destes serve para armazenar vídeos online?", 1, ["Discord", "YouTube", "Excel", "Steam"]],
    ["O que é um cabo HDMI usado para fazer?", 2, ["Dar internet ao PC", "Aumentar a velocidade do processador", "Transmitir imagem e áudio", "Instalar programas"]],
    ["O que é um app?", 1, ["Um cabo especial", "Um aplicativo/programa", "Um vírus desconhecido", "Um tipo de hardware"]],
	["Como identificar se um site é seguro para navegação?", 1, ["Se o site tiver muitas cores chamativas", "Se mostrar um cadeado ao lado da URL e usar HTTPS", "Se pedir sua senha imediatamente", "Se abrir vários pop-ups de ofertas"]],
	["Por que não se deve compartilhar senhas com outras pessoas?", 0, ["Para evitar acesso indevido à sua conta", "Para deixar o PC mais rápido", "Para melhorar sua internet", "Para ativar novos recursos de jogos"]],
	["Qual linguagem é usada para estruturar o conteúdo de páginas web?", 2, ["Python", "C#", "HTML", "Java"]],
	["O que significa 'trabalho em equipe' em projetos de informática?", 3, ["Cada um trabalhar sozinho", "Ignorar opiniões diferentes", "Evitar comunicação", "Colaborar e dividir tarefas com o grupo"]],
	["O que o JavaScript adiciona a uma página web?", 1, ["Armazenamento", "Interatividade", "Proteção contra vírus", "Backup automático"]],
	["Qual destas atitudes aumenta a segurança ao navegar?", 2, ["Usar a mesma senha em todos os sites", "Acessar links desconhecidos", "Ativar verificação em duas etapas", "Instalar programas piratas"]],
	["Qual é a função do CSS em páginas web?", 0, ["Definir visual e estilos da página", "Criar o banco de dados", "Instalar programas no PC", "Controlar o hardware do computador"]],
	["O que é 'compilar' um programa?", 1, ["Criar imagens para o código", "Transformar o código em algo que o computador entende", "Apagar erros automaticamente", "Desenhar a interface do aplicativo"]],
]
#endregion

#region Agro
var quiz_lista_data_agro = [
	["Qual é o processo usado para retirar o leite das vacas?", 1, ["Tosquia", "Ordenha", "Desmame", "Corte"]],
	["Qual o principal nutriente necessário para o crescimento das plantas?", 0, ["Nitrogênio", "Sódio", "Cobre", "Enxofre"]],
	["Qual é o principal objetivo da agropecuária?", 1, ["Produzir energia elétrica", "Produzir alimentos e criar animais", "Construir máquinas agrícolas", "Fabricar roupas"]],
    ["Qual animal é mais comum na pecuária leiteira?", 2, ["Ovelha", "Cabra", "Vaca", "Cavalo"]],
    ["Qual ferramenta é usada para cavar a terra manualmente?", 0, ["Enxada", "Foice", "Ancinho", "Serrote"]],
    ["O que é necessário para as plantas realizarem fotossíntese?", 3, ["Sal", "Fertilizante", "Vento", "Luz do sol"]],
    ["O que é irrigação?", 1, ["Cortar plantas", "Fornecer água às plantações", "Aplicar veneno", "Colher frutas"]],
    ["Qual destes é um animal de criação comum na agropecuária?", 2, ["Gato", "Tartaruga", "Bovino", "Papagaio"]],
    ["Como é chamado o local onde se cria gado bovino?", 2, ["Aviário", "Criadouro", "Curral", "Estábulo"]],
    ["Qual máquina é usada para arar e preparar o solo?", 3, ["Colheitadeira", "Pulverizador", "Grade agrícola", "Trator"]],
    ["Qual parte da planta absorve água e nutrientes?", 1, ["Caule", "Raiz", "Folha", "Fruto"]],
    ["Qual é a função da cerca em uma fazenda?", 2, ["Aumentar o vento", "Enfeitar a área", "Conter e proteger os animais", "Ajudar na irrigação"]],
    ["Qual destes é um exemplo de cultura agrícola?", 0, ["Milho", "Carne", "Sono", "Sal"]],
    ["O que significa 'pastoreio'?", 1, ["Trabalhar no curral", "Levar o gado para se alimentar no pasto", "Cortar capim", "Aplicar vacina"]],
    ["O que o veterinário faz em uma fazenda?", 3, ["Planta árvores", "Dirige trator", "Conserta máquinas", "Cuida da saúde dos animais"]],
    ["Qual destes é um tipo de solo?", 2, ["Gelado", "Metálico", "Arenoso", "Salgado"]],
    ["O que é colheita?", 0, ["Retirar produtos maduros da plantação", "Queimar resíduos", "Arar o solo", "Medir a chuva"]],
    ["O que a adubação fornece às plantas?", 1, ["Vento", "Nutrientes", "Som", "Sombra"]],
    ["O que significa 'gado de corte'?", 3, ["Gado para ordenha", "Gado de estimação", "Gado reprodutor", "Gado criado para produção de carne"]],
    ["O que a cerca elétrica ajuda a fazer?", 0, ["Conter animais", "Aumentar a produção de leite", "Diminuir chuva", "Secar o solo"]],
    ["Qual fruto cresce em cachos?", 1, ["Melancia", "Banana", "Manga", "Laranja"]],
    ["Qual prática ajuda a evitar erosão do solo?", 3, ["Cortar árvores", "Aumentar o pisoteio", "Deixar o solo exposto", "Plantar vegetação"]],
    ["Qual destes animais possui lã?", 1, ["Vaca", "Ovelha", "Porco", "Bode"]],
    ["Qual é a função do pulverizador?", 0, ["Aplicar defensivos nas plantas", "Medir temperatura", "Contar animais", "Selecionar sementes"]],
    ["Qual destes produtos vem da pecuária?", 3, ["Farinha", "Milho", "Feijão", "Carne"]],
    ["O que é um pasto?", 1, ["Uma máquina agrícola", "Área com capim para os animais se alimentarem", "Depósito de ferramentas", "Tipo de solo arenoso"]],
    ["Por que é importante vacinar os animais?", 2, ["Para engordarem mais rápido", "Para beberem mais água", "Para evitar doenças", "Para mudar a cor do pelo"]],
    ["Qual destes é um cereal muito cultivado no Brasil?", 0, ["Arroz", "Couve", "Acerola", "Beterraba"]],
    ["Qual destes animais é usado como força de trabalho em algumas propriedades?", 3, ["Galinha", "Porco", "Cabrito", "Cavalo"]],
    ["Qual equipamento é usado para cortar capim manualmente?", 1, ["Pá", "Foice", "Serrote", "Corda"]]
]
#endregion

#region Quimic
var quiz_lista_data_quimic = [
    ["Qual é a fórmula da água?", 0, ["H2O", "CO2", "NaCl", "O2"]],
    ["O que é um elemento químico?", 1, ["Mistura de substâncias", "Substância formada por átomos iguais", "Reação química", "Composto orgânico"]],
    ["Qual é o estado físico do ferro em temperatura ambiente?", 2, ["Gasoso", "Líquido", "Sólido", "Plasmático"]],
    ["O sal de cozinha é formado por quais elementos?", 3, ["Carbono e Oxigênio", "Hidrogênio e Nitrogênio", "Ferro e Enxofre", "Sódio e Cloro"]],
    ["Qual desses é um gás nobre?", 1, ["Nitrogênio", "Hélio", "Hidrogênio", "Carbono"]],
	["O que é uma mistura?", 3, ["Um metal puro", "Um tipo de gás nobre", "Uma reação química explosiva", "Combinação de duas ou mais substâncias"]],
	["Qual é o pH da água pura?", 1, ["Ácido", "Neutro", "Básico", "Salino"]],
	["O que é uma substância sólida?", 2, ["Aquela que flutua", "Aquela que pega fogo facilmente", "Aquela que tem forma e volume definidos", "Aquela que evapora rapidamente"]],
	["O que acontece com o gelo quando derrete?", 0, ["Ele vira água líquida", "Se transforma em gás imediatamente", "Explode", "Vira metal"]],
	["Qual desses é um exemplo de gás?", 3, ["Sal", "Areia", "Álcool", "Oxigênio"]],
	["Por que não se deve misturar produtos de limpeza sem conhecimento?", 2, ["Porque deixam de limpar", "Porque perdem o cheiro", "Porque podem liberar gases tóxicos", "Porque estragam a embalagem"]],
	["Qual é o principal gás que respiramos?", 1, ["Oxigênio puro", "Mistura com muito nitrogênio", "Hélio", "Gás carbônico"]],
	["A ferrugem é resultado de qual processo?", 0, ["Oxidação do ferro", "Fusão do ferro", "Evaporação", "Solidificação do ar"]],
	["O que é um ácido?", 2, ["Um tipo de metal", "Uma base forte", "Uma substância que pode corroer e tem pH baixo", "Um gás inflamável"]],
	["Qual desses é um exemplo de base?", 3, ["Vinagre", "Suco de limão", "Refrigerante", "Sabão"]],
	["Qual fenômeno ocorre quando o álcool evapora?", 0, ["Mudança de estado físico", "Mistura com ar", "Formação de sal", "Oxidação"]],
	["Qual desses materiais é considerado inflamável?", 1, ["Areia", "Álcool", "Vidro", "Água"]],
	["Qual equipamento é usado para proteger os olhos em laboratório?", 2, ["Luvas térmicas", "Avental de pano", "Óculos de segurança", "Máscara de solda"]],
	["Por que é importante usar jaleco no laboratório?", 3, ["Para ficar mais bonito", "Para não sujar a roupa", "Para trabalhar mais rápido", "Para proteger o corpo contra substâncias químicas"]],
	["O sal (NaCl) é classificado como:", 1, ["Metal puro", "Composto químico", "Gás nobre", "Base forte"]],
	["O que indica o símbolo de caveira em um frasco químico?", 2, ["Inflamável", "Corrosivo", "Tóxico", "Explosivo"]],
	["O que ocorre quando se dissolve açúcar na água?", 0, ["Formação de uma mistura homogênea", "Reação explosiva", "Evaporação instantânea", "Mudança para estado sólido"]],
	["O gás carbônico (CO₂) é muito usado em:", 1, ["Produção de sabão", "Refrigeração e bebidas gaseificadas", "Tintas", "Combustível de motores"]],
	["Qual é o nome da mudança do estado gasoso para o líquido?", 3, ["Fusão", "Sublimação", "Solidificação", "Condensação"]],
	["O que significa o rótulo 'corrosivo' em um produto?", 2, ["É comestível", "É inflamável", "Pode causar danos à pele e materiais", "É seguro para uso infantil"]],
	["Qual desses materiais NÃO é metálico?", 1, ["Ferro", "Plástico", "Alumínio", "Cobre"]],
	["A chama azul do fogão indica:", 0, ["Combustão eficiente", "Combustão incompleta", "Falta de gás", "Explosão iminente"]],
	["Qual é o estado físico do vapor d’água?", 3, ["Sólido", "Líquido", "Gelado", "Gasoso"]],
	["O que é uma reação química?", 1, ["Mistura de líquidos", "Transformação de substâncias em outras", "Evaporação natural", "Mudança de cor momentânea"]],
	["O que acontece quando o sal é misturado na água?", 0, ["Ele se dissolve", "Ele explode", "Ele vira gás", "Ele se transforma em açúcar"]]
]
#endregion

#region Manu
var quiz_lista_data_manu = [
    ["Qual ferramenta é usada para parafusar componentes do PC?", 2, ["Alicate", "Martelo", "Chave Phillips", "Chave inglesa"]],
    ["Qual parte do computador é responsável por fornecer energia aos componentes?", 1, ["Placa-mãe", "Fonte de alimentação", "HD", "Cooler"]],
    ["Antes de tocar nos componentes internos, o que se deve fazer?", 3, ["Nada", "Desligar o monitor", "Ligar o estabilizador", "Descarregar a eletricidade estática"]],
    ["O que indica quando o PC emite bipes ao ligar?", 0, ["Erros de hardware", "Sistema operacional carregando", "Falha na internet", "Atualização de drivers"]],
    ["Qual pasta melhora a condução térmica entre processador e cooler?", 2, ["Pasta condutora", "Pasta metálica", "Pasta térmica", "Pasta isolante"]],
    ["Qual item é usado para apertar e soltar parafusos de computadores?", 3, ["Alicate", "Chave de boca", "Martelo", "Chave Phillips"]],
    ["Para que serve a memória RAM?", 0, ["Armazenar dados temporários", "Armazenar arquivos permanentemente", "Controlar a energia", "Resfriar o sistema"]],
    ["Qual é o principal sinal de superaquecimento?", 2, ["Tela azul", "Ligações automáticas", "Travamentos e desligamentos", "Falta de internet"]],
    ["Qual componente é responsável por manter o computador ligado, fornecendo energia?", 1, ["Placa-mãe", "Fonte de alimentação", "SSD", "Kabos SATA"]],
    ["Qual atitude ajuda a evitar choque elétrico ao mexer no PC?", 0, ["Desligar da tomada", "Ligar o estabilizador", "Usar chinelo", "Mexer rápido"]],
    ["O que faz o cooler do computador?", 2, ["Armazena dados", "Aumenta a velocidade do PC", "Resfria os componentes", "Melhora a internet"]],
    ["Qual cabo é usado para transmitir vídeo para o monitor?", 1, ["USB", "HDMI", "RJ45", "P2"]],
    ["Qual problema é indicado quando o PC faz bipes ao ligar?", 0, ["Erro de hardware", "Erro de internet", "Erro no navegador", "Erro no mouse"]],
    ["Qual componente conecta todas as outras peças internas do computador?", 1, ["SSD", "Placa-mãe", "Fonte", "Cooler"]],
    ["O que um antivírus faz?", 2, ["Aumenta FPS em jogos", "Melhora a internet", "Protege contra arquivos maliciosos", "Diminui o uso da RAM"]],
    ["Qual tipo de armazenamento é mais rápido?", 0, ["SSD", "HD", "DVD", "Pendrive antigo"]],
    ["Antes de instalar peças novas, o que deve ser feito?", 2, ["Desinstalar o Windows", "Aumentar a fonte", "Desligar e desconectar da tomada", "Rodar um teste de RAM"]],
    ["Qual cabo conecta o computador ao modem/roteador?", 1, ["HDMI", "Cabo de rede (RJ45)", "SATA", "P2"]],
    ["Qual sinal indica que o HD pode estar com defeito?", 0, ["Barulhos estranhos (cliques)", "Monitor piscando", "Teclado travando", "Wifi fraco"]],
    ["Qual item NÃO é considerado um periférico?", 1, ["Teclado", "Processador", "Mouse", "Impressora"]],
    ["O que é overclock?", 2, ["Limpeza do PC", "Troca de fonte", "Aumentar a velocidade do processador", "Conectar dois monitores"]],
    ["Para evitar danos ao computador durante quedas de energia, qual equipamento ajuda?", 0, ["Nobreak", "Estabilizador", "Regua comum", "Hub USB"]],
    ["Qual parte ajuda a melhorar gráficos em jogos e programas 3D?", 3, ["Fonte", "Cooler", "SSD", "Placa de vídeo"]],
    ["Qual é um dos sinais de vírus no computador?", 1, ["Temperatura baixa", "Janelas abrindo sozinhas", "Monitor desligando por cabo solto", "Mouse sem mover"]],
    ["O que é uma rede Wi-Fi?", 2, ["Um tipo de HD", "Um cooler especial", "Conexão sem fio à internet", "Um cabo HDMI mais rápido"]],
    ["O que significa “USB” em computadores?", 1, ["Unidade de Sistema Básico", "Padrão universal de conexão", "Sistema de vídeo", "Protocolo de internet"]],
    ["Para que serve o multímetro?", 0, ["Medir tensão e continuidade", "Instalar programas", "Testar Wi-Fi", "Fazer backup"]],
    ["O que pode acontecer se um computador estiver com muita poeira?", 3, ["Aumentar o FPS", "Melhorar a RAM", "O som parar", "Superaquecimento"]],
    ["Qual prática aumenta a vida útil do computador?", 3, ["Usar 24h direto", "Tampar as entradas de ar", "Deixar no sol", "Limpar periodicamente"]],
    ["Qual destes é um sistema operacional?", 0, ["Windows", "SSD", "BIOS", "Ping"]]
]
#endregion

quiz_lista_data = []
if (global.sel_course == "info") quiz_lista_data = quiz_lista_data_info;
else if (global.sel_course == "agro") quiz_lista_data = quiz_lista_data_agro;
else if (global.sel_course == "quimic") quiz_lista_data = quiz_lista_data_quimic;
else if (global.sel_course == "manu") quiz_lista_data = quiz_lista_data_manu;



// Inicializa o número de vidas no caso tres é o numero de 
// vida maximo
vida = 3;

texto = ""

// Lista das perguntas disponiveis
quiz_lista = []

// Variavel para saber se deve trocar de pergunta
troca = true

// Variavel para saber se a pergunta já foi respondida corretamente. AJEITAR ISSO!
respondida = false



/*
ex = ["Qual O Presidente do Brasil Em 2024?", 0, ["Lula", "Bolsonaro", "Dilma", "Valdir"]]

// Pegando a quantidade de elementos de um array
show_message(array_length(global.quiz_lista[0]))
show_message(global.quiz_lista[0])
// Tirando elemento de um array
array_delete(global.quiz_lista[0], 1, 2)

show_message(array_length(global.quiz_lista[0]))
show_message(global.quiz_lista[0])

FAZ A MECANICA NO STEP
*/
