// test.scd — déclencheurs manuels pour tester sans MIDI Fighter.
// Ne PAS charger depuis Morph Congas.scd : ce fichier est destiné à
// être évalué bloc par bloc dans l'IDE (Cmd/Ctrl+Enter dans SC).
// Pré-requis : avoir évalué Morph Congas.scd au moins une fois.


/* -----------------------------------------------------------------
   1. Play / stop / toggle d'une voix
   ----------------------------------------------------------------- */

// Démarre \saw1 avec fade-in 2s
~actions.play.(\saw1, 2);

// Stop \saw1 avec fade-out 4s
~actions.stop.(\saw1, 4);

// Toggle \fm1 (joue ou stoppe selon l'état)
~actions.toggle.(\fm1);

// Toggle avec fadeTime custom
~actions.toggle.(\fm1, 6);

// Stop tout en cours
~actions.stopAll.(3);


/* -----------------------------------------------------------------
   2. Morph (équivalent knob 0)
   ----------------------------------------------------------------- */

~morph = 0.0;   // straight
~morph = 0.5;
~morph = 1.0;   // tempering maximal


/* -----------------------------------------------------------------
   3. Navigation dans ~words
   Les Pbind lisent ~word via Pfunc → changement entendu à
   l'événement suivant, sans relancer les voix.
   ----------------------------------------------------------------- */

~actions.nextWord.();
~actions.prevWord.();
"wordIndex=% | word=%".format(~wordIndex, ~word).postln;


/* -----------------------------------------------------------------
   4. Sends par voix
   ----------------------------------------------------------------- */

~actions.setSendReverb.(\saw1, 0.8);
~actions.setSendDelay.(\saw1, 0.3);
~actions.setSendReverb.(\fm1, 0.5);
~actions.setSendDelay.(\fm1, 0.6);

// Équivalent direct via Ndef :
Ndef(\saw1).set(\sendReverb, 0.8, \sendDelay, 0.3);


/* -----------------------------------------------------------------
   5. Définir / remplacer une voix à chaud
   ----------------------------------------------------------------- */

// Ajoute une 3e voix sur le push 3
~makeVoice.(\saw2, 3, Pbind(
    \instrument, \negSaw,
    \freq, 75,
    \dur, Pneu(morph: Pfunc({ ~morph }), sub: false, word: Pfunc({ ~word })),
    \envDur, Pkey(\dur) * 0.9,
    \sustain, inf,
));
~actions.play.(\saw2, 1);

// Remplace \saw1 (ancien Ndef cleared, nouveau enregistré sur push 1)
~makeVoice.(\saw1, 1, Pbind(
    \instrument, \negSaw,
    \freq, 220,
    \dur, Pneu(morph: Pfunc({ ~morph }), sub: true, word: Pfunc({ ~word })),
    \envDur, Pkey(\dur) * 0.9,
    \sustain, inf,
));


/* -----------------------------------------------------------------
   6. Simulation directe des hooks MIDI (sans contrôleur)
   ----------------------------------------------------------------- */

~onKnobChange.(0, 0.7, 0);          // morph
~onKnobChange.(1, 0.9, 0);          // sendReverb voix midi 1 (\saw1)
~onKnobChange.(2, 0.4, 0);          // sendReverb voix midi 2 (\fm1)
~onKnobShiftChange.(1, 0.6, 4);     // sendDelay voix midi 1

~onButtonChange.(1, 1, 1);          // toggle \saw1
~onButtonChange.(2, 1, 1);          // toggle \fm1
~onButtonChange.(0, 1, 1);          // stopAll
~onButtonChange.(13, 1, 1);         // nextWord


/* -----------------------------------------------------------------
   7. Diagnostics
   ----------------------------------------------------------------- */

(
"--- État ---".postln;
"morph        = %".format(~morph).postln;
"wordIndex    = %".format(~wordIndex).postln;
"word         = %".format(~word).postln;
"voices       = %".format(~voices.keys.asArray).postln;
"voiceByMidi  = %".format(~voiceByMidi).postln;
~voices.keysDo { |name|
    "  % : midi=%, playing=%, fadeTime=%".format(
        name,
        ~voices[name].midi,
        Ndef(name).isPlaying,
        Ndef(name).fadeTime
    ).postln;
};
)

// Arbre serveur
s.queryAllNodes;

// Dump d'un Ndef en particulier (slots, paramètres)
Ndef(\saw1).gui;       // ouvre une GUI proxy
Ndef(\fm1).getKeysValues;

// Arrêt d'urgence
CmdPeriod.run;
