// =======================================================
// COPIAR LISTA ORIGINAL
// =======================================================
var _len = array_length(quiz_lista_data);
array_copy(quiz_lista, 0, quiz_lista_data, 0, _len);

// =======================================================
// EMBARALHAR ORDEM DAS PERGUNTAS
// =======================================================
array_shuffle_ext(quiz_lista, 0, _len);

// =======================================================
// FUNÇÃO INTERNA: embaralha alternativas mantendo índice correto
// =======================================================
var _shuffle_question_options = function(_q) {
    var _correct_old = _q[1];
    var _opts = _q[2];
    var _n = array_length(_opts);

    if (_n <= 1) return;

    // criar lista de índices
    var _indices = [];
    for (var i = 0; i < _n; ++i) _indices[i] = i;

    // embaralhar índices
    _indices = array_shuffle(_indices);

    // reconstruir lista e recalcular índice correto
    var _new_opts = array_create(_n);
    var _new_correct = -1;

    for (var j = 0; j < _n; ++j) {
        var src = _indices[j];
        _new_opts[j] = _opts[src];
        if (src == _correct_old) _new_correct = j;
    }

    _q[2] = _new_opts;
    _q[1] = _new_correct;
}

// =======================================================
// EMBARALHAR ALTERNATIVAS DE TODAS AS PERGUNTAS
// =======================================================
for (var i = 0; i < _len; ++i) {
    _shuffle_question_options(quiz_lista[i]);
}

// =======================================================
// SE VOCÊ QUISER MANTER O DELETE (remover últimas 3 perguntas):
// =======================================================
array_delete(quiz_lista, -1, -20);
