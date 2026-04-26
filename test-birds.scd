// test-birds.scd — phrases réalistes par espèce.
// Évaluer chaque bloc indépendamment.
// Chirp seul, pour entendre l'effet du tract
Synth(\bird, [\freq, 3500, \freqEnd, 2200, \rel, 0.12, \glideFrac, 0.5,
    \sourceWidth, 0.5,
    \f1, 2700, \f1End, 2400, \f2, 5000, \f2End, 4500, \f3, 8000,
    \drive, 2.5]);

// Pour comparer : même chirp avec formants à fréquences extrêmes (= pas d'effet)
Synth(\bird, [\freq, 3500, \freqEnd, 2200, \rel, 0.12, \glideFrac, 0.5,
    \sourceWidth, 0.5,
    \f1, 100, \f1End, 100, \f2, 100, \f2End, 100, \f3, 100,
    \f1Amp, 0, \f2Amp, 0, \f3Amp, 0,    // désactive les formants
    \drive, 2.5]);

/* =================================================================
   MERLE — phrase typique : motif court, pause, variation, pause.
   Le merle joue une "strophe" puis se tait, puis recommence ailleurs.
   ================================================================= */

// Phrase descendante typique avec respiration
(
Pbindf(~birds[\merle],
    \dur,  Pseq([0.18, 0.22, 0.35, 0.6, 1.2,   0.20, 0.18, 0.45, 1.5], inf),
    \freq, Pseq([2700, 2400, 2100, 1900, Rest(),  2600, 2500, 2200, Rest()], inf)
        + Pwhite(-30, 30),
).play;
)

// Strophe plus longue, contour mélodique caractéristique
(
Pbindf(~birds[\merle],
    \dur,  Pseq([0.15, 0.15, 0.30, 0.20, 0.45, 0.8, 1.8], inf),
    \freq, Pseq([2500, 2700, 2300, 2400, 2000, 1800, Rest()], inf)
        + Pwhite(-40, 40),
    \rel, Pseq([0.12, 0.12, 0.18, 0.14, 0.22, 0.28, 0.1], inf),
).play;
)


/* =================================================================
   ROUGEGORGE — phrases nerveuses, hautes, cascade descendante,
   trilles intercalés. Très court entre cellules.
   ================================================================= */

// Cascade rapide + trille + silence
(
Pbindf(~birds[\rougegorge],
    \dur,  Pseq([0.05, 0.05, 0.05, 0.06, 0.08, 0.12,   0.04, 0.04, 0.04, 0.04, 0.04, 0.04,   0.6,   1.0], inf),
    \freq, Pseq([5400, 5000, 4600, 4200, 3800, 3500,   4800, 5200, 4800, 5200, 4800, 5200,   4000,  Rest()], inf)
        + Pwhite(-50, 50),
).play;
)

// Phrase avec deux strophes contrastées
(
Pbindf(~birds[\rougegorge],
    \dur,  Pseq([
        0.08, 0.06, 0.05, 0.05, 0.05, 0.3,
        1.5,
        0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.04, 0.5,
        2.0
    ], inf),
    \freq, Pseq([
        4500, 5000, 4800, 4400, 4000, 3700,
        Rest(),
        5200, 4800, 5200, 4800, 5200, 4800, 5200, 4500,
        Rest()
    ], inf) + Pwhite(-60, 60),
).play;
)


/* =================================================================
   GRIVE MUSICIENNE — signature : motif court répété 2 à 4 fois,
   puis nouveau motif. C'est la marque de l'espèce.
   ================================================================= */

// Trois motifs différents, chacun répété 3 fois
(
Pbindf(~birds[\grive],
    \dur,  Pseq([
        0.18, 0.18, 0.5,   0.18, 0.18, 0.5,   0.18, 0.18, 0.8,
        1.0,
        0.12, 0.12, 0.12, 0.4,   0.12, 0.12, 0.12, 0.4,   0.12, 0.12, 0.12, 0.8,
        1.2,
        0.25, 0.4,   0.25, 0.4,   0.25, 0.7,
        1.5
    ], inf),
    \freq, Pseq([
        2400, 2700, 2200,  2400, 2700, 2200,  2400, 2700, 2200,
        Rest(),
        3000, 2800, 2600, 2400,  3000, 2800, 2600, 2400,  3000, 2800, 2600, 2400,
        Rest(),
        2200, 2600,  2200, 2600,  2200, 2600,
        Rest()
    ], inf) + Pwhite(-30, 30),
).play;
)

// Variante : motifs plus courts, plus typés "grive"
(
Pbindf(~birds[\grive],
    \dur,  Pseq([
        0.15, 0.15, 0.6,   0.15, 0.15, 0.6,   1.5,
        0.10, 0.10, 0.10, 0.5,  0.10, 0.10, 0.10, 0.5,  0.10, 0.10, 0.10, 1.0,
        2.0
    ], inf),
    \freq, Pseq([
        2800, 2400, Rest(),  2800, 2400, Rest(),  Rest(),
        2200, 2400, 2600, Rest(),  2200, 2400, 2600, Rest(),  2200, 2400, 2600, Rest(),
        Rest()
    ], inf) + Pwhite(-25, 25),
).play;
)


/* =================================================================
   LORIOT — motif emblématique "didelio" / "tio-lui-lio".
   Phrase rare, espacée. Messiaen le note "flûté" en La majeur.
   ================================================================= */

// Le motif classique en trois notes liées, espacé
(
Pbindf(~birds[\loriot],
    \dur,  Pseq([0.18, 0.22, 0.45, 2.5,   0.20, 0.50, 3.0], inf),
    \freq, Pseq([1500, 1750, 1500, Rest(),  1500, 1700, Rest()], inf)
        + Pwhite(-20, 20),
    // Pour la première note, glissando court ; pour la longue, plein
    \glideFrac, Pseq([0.5, 0.5, 0.85, 0.5,   0.5, 0.85, 0.5], inf),
).play;
)

// Variante : appel court répété (le loriot fait ça parfois en alarme)
(
Pbindf(~birds[\loriot],
    \dur,  Pseq([0.4, 0.6, 1.0, 0.4, 0.6, 2.5], inf),
    \freq, Pseq([1500, 1750, Rest(), 1500, 1750, Rest()], inf)
        + Pwhite(-15, 15),
).play;
)


/* =================================================================
   CORNEILLE — cris isolés, très espacés. Les corvidés ne chantent
   pas, ils crient par séries de 2 à 5.
   ================================================================= */

// Série de trois cris + silence long
(
Pbindf(~birds[\corneille],
    \dur,  Pseq([0.35, 0.40, 0.45, 3.5,   0.40, 0.45, 4.0], inf),
    \freq, Pseq([550, 520, 490, Rest(),   530, 500, Rest()], inf)
        + Pwhite(-30, 30),
).play;
)

// Cris solitaires irréguliers
(
Pbindf(~birds[\corneille],
    \dur,  Pseq([0.45, 5.0, 0.50, 0.40, 6.0, 0.45, 4.5], inf),
    \freq, Pseq([520, Rest(), 540, 500, Rest(), 530, Rest()], inf)
        + Pwhite(-40, 40),
).play;
)


/* =================================================================
   MIX — plusieurs oiseaux simultanés, façon aube
   À évaluer après les blocs ci-dessus pour entendre la coexistence.
   ================================================================= */

(
Ppar([
    Pbindf(~birds[\merle],
        \dur,  Pseq([0.18, 0.22, 0.35, 0.6, 1.2,   0.20, 0.18, 0.45, 1.5], inf),
        \freq, Pseq([2700, 2400, 2100, 1900, Rest(),  2600, 2500, 2200, Rest()], inf)
            + Pwhite(-30, 30),
    ),
    Pbindf(~birds[\rougegorge],
        \dur,  Pseq([0.05, 0.05, 0.05, 0.06, 0.3,   1.5], inf),
        \freq, Pseq([5400, 5000, 4600, 4200, 3700,   Rest()], inf)
            + Pwhite(-50, 50),
    ),
    Pbindf(~birds[\loriot],
        \dur,  Pseq([0.18, 0.22, 0.45, 4.0], inf),
        \freq, Pseq([1500, 1750, 1500, Rest()], inf)
            + Pwhite(-20, 20),
    ),
]).play;
)


CmdPeriod.run;