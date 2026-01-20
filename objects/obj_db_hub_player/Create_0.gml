pauta = noone

count = 0

player =
{ id : "", 
email	: "",
senha	: "",

nome	 : "",
idade	 : "",
cidade	 : "",

c_info	 : 0,
c_manu	 : 0,
c_agro	 : 0,
c_quimic	 : 0,

spr_hair : "",
ha_r	 : 0,
ha_g	 : 0,
ha_b	 : 0,

spr_head : "",
he_r	 : 0,
he_g	 : 0,
he_b	 : 0,

spr_body : "",
bo_r	 : 0,
bo_g	 : 0,
bo_b	 : 0,

spr_leg	 : "",
le_r	 : 0,
le_g	 : 0,
le_b	 : 0}


xescala = 2
yescala = 2

parado = true

movimento = false
decision = true

tempo = irandom_range(1,4) * game_get_speed(gamespeed_fps)

st = 15* game_get_speed(gamespeed_fps)

decisao = function(){
	var _label = irandom_range(0,360)
	direction = _label
	}

segurando = false

saudacao = false

otherx = 0

direcao = 2

distancia = 100

decidir = true
 
desenha = false


/*
/// export_avatar_png(_filename, _frame, _xscale, _yscale)
/// Salva um PNG do avatar montado
function export_avatar_png(_filename, _frame, _xscale, _yscale)
{
    // --- Sprites usados ---
    var _perna  = asset_get_index(player.spr_leg)
    var _corpo  = asset_get_index(player.spr_body)
    var _cabeca = asset_get_index(player.spr_head)
    var _cabelo = asset_get_index(player.spr_hair)

    // --- Tamanho base (usa o maior sprite como referência) ---
    var _w = sprite_get_width(_corpo)  * _xscale;
    var _h = sprite_get_height(_corpo) * _yscale;

    // --- Criar surface ---
    var _surf = surface_create(ceil(_w), ceil(_h));
    if (!surface_exists(_surf)) return false;

    // --- Desenhar na surface ---
    surface_set_target(_surf);
    draw_clear_alpha(c_black, 0);

    draw_sprite_ext(
        _perna, _frame,
        _w / 2, _h / 2,
        _xscale, _yscale, 0,
        make_color_rgb(player.le_r, player.le_g, player.le_b), 1
    );

    draw_sprite_ext(
        _corpo, _frame,
        _w / 2, _h / 2,
        _xscale, _yscale, 0,
        make_color_rgb(player.bo_r, player.bo_g, player.bo_b), 1
    );

    draw_sprite_ext(
        _cabeca, _frame,
        _w / 2, _h / 2,
        _xscale, _yscale, 0,
        make_color_rgb(player.he_r, player.he_g, player.he_b), 1
    );

    draw_sprite_ext(
        _cabelo, _frame,
        _w / 2, _h / 2,
        _xscale, _yscale, 0,
        make_color_rgb(player.ha_r, player.ha_g, player.ha_b), 1
    );

    surface_reset_target();

    // --- Salvar como PNG ---
    surface_save(_surf, _filename);

    // --- Limpar memória ---
    surface_free(_surf);

    return true;
}

//alarm[0] = 100