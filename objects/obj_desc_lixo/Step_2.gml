// Rodando o estado atual
if (global.seq_run_out) exit;
estado()

/// Voltando a escala original (parte do efeito de splash)
image_xscale = lerp(image_xscale, 1, splash_amt)
image_yscale = lerp(image_yscale, 1, splash_amt)
