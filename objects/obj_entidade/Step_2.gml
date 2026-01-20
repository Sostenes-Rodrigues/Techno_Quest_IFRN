// --- COLISÃO HORIZONTAL ---
if (hspd != 0)
{
    // Testa se haverá colisão no próximo movimento
    if (place_meeting(x + hspd, y, obj_colisao))
    {
        // Move um pixel de cada vez até colidir
        while (!place_meeting(x + sign(hspd), y, obj_colisao))
        {
            x += sign(hspd);
        }
        // Quando colidir, zera a velocidade
        hspd = 0;
    }
    else
    {
        // Se não colidir, move normalmente
        x += hspd;
    }
}

// --- COLISÃO VERTICAL ---
if (vspd != 0)
{
    if (place_meeting(x, y + vspd, obj_colisao))
    {
        while (!place_meeting(x, y + sign(vspd), obj_colisao))
        {
            y += sign(vspd);
        }
        vspd = 0;
    }
    else
    {
        y += vspd;
    }
}
