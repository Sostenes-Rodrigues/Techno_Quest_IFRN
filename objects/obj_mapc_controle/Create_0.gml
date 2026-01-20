/// Criando o tutorial
if !global.tu_pass_pcma {
	global.tu_pass_pcma = true
	
	var _tu = instance_create_layer(0, 0, "Instances", obj_tutorial)
	with (_tu) {
		tutorial_imgs = [spr_mapc_tutorial1, spr_mapc_tutorial2, spr_mapc_tutorial3]
		tutorial_string = ["Monte computadores, clientes irão fazer pedidos de peças específicas, verifique as peças pedidas no painel abaixo.",
		"Pegue as peças requeridas nas gavetas à esquerda e as encaixe na placa-mãe. As peças trabalhadas serão das seguintes categorias: memória RAM [1], placa de rede [2], placa de vídeo [3], armazenamento [4], processador [5] e cooler [6].",
		"Após colocar o processador, feche sua trava (acionada por um botanzinho a sua direta) e encaixe o cooler em cima. Após completar tudo aperte o botão no canto inferior direito para entregar o pedido."]
		
		tutorial_length = array_length(tutorial_imgs) - 1
	}
}


///
if !audio_is_playing(snd_mapc_music) {
	play_sound_music(snd_mapc_music)
}


//Verifica se o player está segurando algo
segurando = false

//Pontuação do player (ainda nao emplementado)
pontuacao = 0
var a,b,c,d,e,f
a = irandom_range(0,3)
b = irandom_range(4,7)
c = irandom_range(8,11)
d = irandom_range(12,15)
e = irandom_range(16,19)
f = irandom_range(20,23)




//Pedido do player
items = [a,b,c,d,e,f] //sprite
quantidade = [2,1,1,1,1,1] // quantidade
modelo = [a,b,c,d,e,f] // texto

tamanho = array_length(items) //ve o tamanho da lista

/*
ITEMS:
0 == MEMORIA RAM
1 == PROCESSADOR
2 == COOLER
*/

lista = [
    // RAM
    "2 GB de RAM",            // == 0
    "4 GB de RAM",            // == 1
    "8 GB de RAM",            // == 2
    "16 GB de RAM",           // == 3

    // Placa de rede
    "Placa de rede 1 Gbps",   // == 4
    "Placa de rede 2.5 Gbps", // == 5
    "Placa de rede 5 Gbps",   // == 6
    "Placa de rede 10 Gbps",  // == 7

    // Placa de vídeo
    "Placa de vídeo NVIDIA GT",   // == 8
    "Placa de vídeo NVIDIA GTX",  // == 9
    "Placa de vídeo NVIDIA RTX",  // == 10
    "Placa de vídeo AMD Radeon",  // == 11

    // SSD
    "SSD Kingston 240 GB",    // == 12
    "SSD Kingston 480 GB",    // == 13
    "SSD ADATA 240 GB",       // == 14
    "SSD 2 TB (2048 GB)",     // == 15

    // Processador
    "Intel Core i5",          // == 16
    "Intel Core i7",          // == 17
    "AMD Ryzen 5",            // == 18
    "AMD Ryzen 7",            // == 19

    // Refrigeração
    "Cooler a ar padrão",     // == 16
    "Cooler a ar premium",    // == 17
    "Cooler torre",           // == 18
    "Water Cooler"            // == 19
]



teste = "ABABA"

