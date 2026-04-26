(
~birds = ();

// --- Merle noir ---
~birds[\merle] = Pbind(
    \instrument, \bird,
    \freq,          Pwhite(2000, 2800),
    \freqEnd,       Pkey(\freq) * Pwhite(0.55, 0.85),
    \freqCurve,     Pwhite(-3.0, -5.0),
    \glideFrac,     Pwhite(0.3, 0.5),
    \freq2,         Pkey(\freq) * 1.005,
    \freq2End,      Pkey(\freqEnd) * 1.005,
    \freq2Curve,    Pkey(\freqCurve),
    \syrinxBalance, 0.15,
    \sourceWidth,   0.35,                // tonalité flûtée mais pas pure
    \vibRate, 0, \vibDepth, 0,
    \flutterRate,   Pwhite(40, 80),
    \flutterDepth,  Pwhite(0.2, 0.4),
    \jitter,        0.004,
    // Tract : médium-aigu, formants relativement bas pour merle
    \f1,            Pwhite(2400, 2800),
    \f1End,         Pkey(\f1) * Pwhite(0.85, 1.0),
    \f2,            Pwhite(4800, 5400),
    \f2End,         Pkey(\f2) * Pwhite(0.9, 1.05),
    \f3,            Pwhite(7500, 8500),
    \f3End,         Pkey(\f3),
    \f1Q, 14, \f2Q, 10, \f3Q, 7,
    \f1Amp, 1.0, \f2Amp, 0.5, \f3Amp, 0.2,
    \formantGlideFrac, 0.7,
    \drive,         2.0,
    \noise, 0,
    \clickAmp,      0.15,
    \clickDur,      0.005,
    \atk,           0.003,
    \rel,           Pwhite(0.10, 0.22),
    \curve,         -4,
    \amp,           0.3,
    \pan,           Pwhite(-0.3, 0.3),
);

// --- Rouge-gorge ---
~birds[\rougegorge] = Pbind(
    \instrument, \bird,
    \freq,          Pwhite(3500, 5500),
    \freqEnd,       Pkey(\freq) * Pwhite(0.4, 2.2),
    \freqCurve,     Pwhite(-4.0, 4.0),
    \glideFrac,     Pwhite(0.4, 0.7),
    \freq2,         Pkey(\freq) * Pwhite(1.005, 1.02),
    \freq2End,      Pkey(\freqEnd) * Pwhite(1.005, 1.02),
    \freq2Curve,    Pkey(\freqCurve),
    \syrinxBalance, 0.3,
    \sourceWidth,   0.55,                // assez riche, son métallique
    \vibRate,       Pwhite(50, 90),
    \vibDepth,      Pwhite(80, 200),
    \flutterRate,   Pwhite(80, 160),
    \flutterDepth,  Pwhite(0.4, 0.7),
    \jitter,        0.008,
    // Petit tract → formants très aigus
    \f1,            Pwhite(4500, 5200),
    \f1End,         Pkey(\f1) * Pwhite(0.85, 1.15),
    \f2,            Pwhite(7500, 9000),
    \f2End,         Pkey(\f2) * Pwhite(0.9, 1.1),
    \f3,            Pwhite(11000, 13000),
    \f3End,         Pkey(\f3),
    \f1Q, 16, \f2Q, 12, \f3Q, 10,
    \f1Amp, 1.0, \f2Amp, 0.7, \f3Amp, 0.4,
    \formantGlideFrac, 0.6,
    \drive,         2.5,
    \noise, 0,
    \clickAmp,      0.2,
    \clickDur,      0.004,
    \atk,           0.002,
    \rel,           Pwhite(0.03, 0.08),
    \curve,         -6,
    \amp,           0.25,
    \pan,           Pwhite(-0.5, 0.5),
);

// --- Grive musicienne ---
~birds[\grive] = Pbind(
    \instrument, \bird,
    \freq,          Pwhite(1800, 3200),
    \freqEnd,       Pkey(\freq) * Pwhite(0.6, 1.6),
    \freqCurve,     Pwhite(-3.0, 3.0),
    \glideFrac,     Pwhite(0.3, 0.6),
    \freq2,         Pkey(\freq) * Pwhite(1.32, 1.68),
    \freq2End,      Pkey(\freq2) * Pwhite(0.7, 1.3),
    \freq2Curve,    Pwhite(-3.0, 3.0),
    \syrinxBalance, 0.65,
    \sourceWidth,   0.5,
    \vibRate, 0, \vibDepth, 0,
    \flutterRate,   Pwhite(60, 110),
    \flutterDepth,  Pwhite(0.3, 0.5),
    \jitter,        0.006,
    // Tract turdidé : intermédiaire
    \f1,            Pwhite(2200, 2700),
    \f1End,         Pkey(\f1) * Pwhite(0.85, 1.1),
    \f2,            Pwhite(4500, 5500),
    \f2End,         Pkey(\f2) * Pwhite(0.9, 1.1),
    \f3,            Pwhite(7500, 9000),
    \f3End,         Pkey(\f3),
    \f1Q, 12, \f2Q, 10, \f3Q, 8,
    \f1Amp, 1.0, \f2Amp, 0.6, \f3Amp, 0.3,
    \formantGlideFrac, 0.65,
    \drive,         2.5,
    \noise, 0,
    \clickAmp,      0.25,
    \clickDur,      0.006,
    \atk,           0.002,
    \rel,           Pwhite(0.06, 0.14),
    \curve,         -5,
    \amp,           0.28,
    \pan,           Pwhite(-0.4, 0.4),
);

// --- Loriot ---
// Cas particulier : son très flûté → sourceWidth bas + un seul formant fort
// proche de la fondamentale (renforcement de la fondamentale, atténuation
// des harmoniques supérieures = effet flûte).
~birds[\loriot] = Pbind(
    \instrument, \bird,
    \freq,          Pwhite(1400, 1800),
    \freqEnd,       Pkey(\freq) * Pwhite(1.4, 1.7),
    \freqCurve,     -1,
    \glideFrac,     0.85,
    \freq2,         Pkey(\freq),
    \freq2End,      Pkey(\freqEnd),
    \freq2Curve,    -1,
    \syrinxBalance, 0,
    \sourceWidth,   0.15,                // quasi-sinus
    \vibRate, 0, \vibDepth, 0,
    \flutterRate,   Pwhite(30, 50),
    \flutterDepth,  0.15,
    \jitter,        0.003,
    // F1 colle à la fondamentale → renforce l'effet "flûte pure"
    \f1,            Pkey(\freq),
    \f1End,         Pkey(\freqEnd),
    \f2,            Pkey(\freq) * 3,     // renforce la 3e harmonique faiblement
    \f2End,         Pkey(\freqEnd) * 3,
    \f3,            8000,                // formant haut quasi inaudible
    \f3End,         8000,
    \f1Q, 10, \f2Q, 18, \f3Q, 6,
    \f1Amp, 1.0, \f2Amp, 0.15, \f3Amp, 0.05,
    \formantGlideFrac, 0.85,
    \drive,         1.3,
    \noise, 0,
    \clickAmp,      0.08,
    \clickDur,      0.012,
    \atk,           0.015,
    \rel,           Pwhite(0.20, 0.35),
    \curve,         -2,
    \amp,           0.35,
    \pan,           Pwhite(-0.2, 0.2),
);

// --- Corneille ---
~birds[\corneille] = Pbind(
    \instrument, \bird,
    \freq,          Pwhite(400, 700),
    \freqEnd,       Pkey(\freq) * Pwhite(0.7, 0.9),
    \freqCurve,     Pwhite(-2.0, 0),
    \glideFrac,     0.3,
    \freq2,         Pkey(\freq) * 1.0,
    \freq2End,      Pkey(\freqEnd) * 1.0,
    \freq2Curve,    Pkey(\freqCurve),
    \syrinxBalance, 0,
    \sourceWidth,   0.85,                // source très riche → texture rauque
    \vibRate, 0, \vibDepth, 0,
    \flutterRate,   Pwhite(20, 40),
    \flutterDepth,  Pwhite(0.5, 0.8),
    \jitter,        0.02,
    // Tract long → formants graves
    \f1,            Pwhite(900, 1300),
    \f1End,         Pkey(\f1) * Pwhite(0.7, 1.0),    // le bec se ferme un peu
    \f2,            Pwhite(2200, 2800),
    \f2End,         Pkey(\f2) * Pwhite(0.8, 1.0),
    \f3,            Pwhite(4000, 5000),
    \f3End,         Pkey(\f3),
    \f1Q, 8, \f2Q, 7, \f3Q, 6,            // moins résonant = plus bruité
    \f1Amp, 1.0, \f2Amp, 0.7, \f3Amp, 0.4,
    \formantGlideFrac, 0.5,
    \drive,         5.0,
    \noise,         0.5,
    \rq,            0.2,
    \clickAmp,      0.4,
    \clickDur,      0.015,
    \atk,           0.005,
    \rel,           Pwhite(0.12, 0.25),
    \curve,         -3,
    \amp,           0.3,
    \pan,           Pwhite(-0.4, 0.4),
);

"Profils v4 (avec tract vocal) chargés : %".format(~birds.keys.asArray).postln;
)