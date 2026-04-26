(
// ---- Words rythmiques ----
~words = [
    [2, 1, 1, 2, 2, 1, 2],
    [1, 2, 1, 1, 2, 1, 2, 1],
    [1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 1, 2, 1, 1, 2, 1, 1],
    [2, 1, 2, 2, 1, 2, 2, 1, 2],
    [1, 2, 1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 1, 2, 1, 2, 1, 1, 2, 1]
];

// ---- État initial ----
~wordIndex = 0;
~word = ~words[0];
~morph = 0.0;

// ---- Mix et effets ----
~amp1 = 1.0;
~amp2 = 1.0;
~sendReverb = 0.3;
~reverbAmp = 1.0;

// ---- Tempo (déplacé depuis Morph_Congas.scd si tu veux centraliser ici) ----
TempoClock.default.tempo = 0.5;
)