// test.scd — déclencheurs manuels pour tester sans MIDI Fighter.
// Ne PAS charger depuis Morph Congas.scd : ce fichier est destiné à
// être évalué bloc par bloc dans l'IDE (Cmd/Ctrl+Enter dans SC).
// Pré-requis : avoir évalué Morph Congas.scd au moins une fois.


/* -----------------------------------------------------------------
   1. Démarrage
   ----------------------------------------------------------------- */

// Lancer les 4 slots (tous sur bus A, amplitude pleine)
~actions.initSlots.();


/* -----------------------------------------------------------------
   2. Morph (équivalent knob 0)
   ----------------------------------------------------------------- */

~morph = 0.0;   // straight
~morph = 0.5;
~morph = 1.0;   // tempering maximal (ratio = 2 pour Pneu)


/* -----------------------------------------------------------------
   3. Navigation dans ~words (n'affecte PAS les Pdef actifs —
   le nouveau mot prend effet au prochain swapSlot)
   ----------------------------------------------------------------- */

~actions.nextWord.();
~actions.prevWord.();

// État courant
"wordIndex=% | word=%".format(~wordIndex, ~word).postln;


/* -----------------------------------------------------------------
   4. swapSlot — crossfade vers une nouvelle version
   Signature : swapSlot.(slot, freq, word, sub, fadeTime, quant)
   ----------------------------------------------------------------- */

// Swap slot 0 avec les defaults et le mot courant
~actions.swapSlot.(0, ~defaultFreq[0], ~word, ~defaultSub[0], 4, 4);

// Swap slot 1 avec une freq custom et un mot choisi, fade court
~actions.swapSlot.(1, 120, ~words[3], false, 2, 2);

// Swap des 4 slots en cascade (même mot, defaults)
(
4.do { |i|
    ~actions.swapSlot.(i, ~defaultFreq[i], ~words[2], ~defaultSub[i], 3, 4);
};
)


/* -----------------------------------------------------------------
   5. Sends par slot (équivalent knobs 4-7 reverb, 8-11 delay)
   Agissent directement sur le slot synth (pas de Pdef reconstruit)
   ----------------------------------------------------------------- */

~slotSynths[0].set(\sendReverb, 0.8);
~slotSynths[0].set(\sendDelay,  0.3);
~slotSynths[1].set(\sendReverb, 0.2);
~slotSynths[2].set(\sendReverb, 0.5);
~slotSynths[3].set(\sendDelay,  0.6);


/* -----------------------------------------------------------------
   6. Simulation directe des hooks MIDI
   (pour tester les mappings sans contrôleur)
   ----------------------------------------------------------------- */

// Knobs : num, val (0..1), chan
~onKnobChange.(0, 0.7, 0);   // morph
~onKnobChange.(4, 0.9, 0);   // slot 0 sendReverb
~onKnobChange.(5, 0.4, 0);   // slot 1 sendReverb
~onKnobChange.(8, 0.6, 0);   // slot 0 sendDelay

// Pushes : num, state (1=down), chan
~onButtonChange.(0,  1, 1);   // push 0 → initSlots
~onButtonChange.(4,  1, 1);   // push 4 → swapSlot 0 (defaults)
~onButtonChange.(13, 1, 1);   // push 13 → nextWord


/* -----------------------------------------------------------------
   7. Arrêts
   ----------------------------------------------------------------- */

// Arrêt propre (stoppe les 8 Pdef possibles — A et B pour chaque slot)
~actions.stopAllSlots.();

// Arrêt d'urgence : tue tous les synths (inclut les effets et slotSynths —
// il faudra recharger Morph Congas.scd ensuite)
CmdPeriod.run;


/* -----------------------------------------------------------------
   8. Diagnostics
   ----------------------------------------------------------------- */

(
"--- État ---".postln;
"morph          = %".format(~morph).postln;
"wordIndex      = %".format(~wordIndex).postln;
"word           = %".format(~word).postln;
"slotActiveBus  = %".format(~slotActiveBus).postln;
"slotSendReverb = %".format(~slotSendReverb).postln;
"slotSendDelay  = %".format(~slotSendDelay).postln;
"slotSynths     = %".format(~slotSynths).postln;
)

// Voir l'arbre serveur (ordre head→tail : slots, reverb, delay, master)
s.queryAllNodes;

// Lister les Pdef actuellement définis pour le projet
(
4.do { |slot|
    [\a, \b].do { |bus|
        var name = ("voix" ++ slot ++ bus.asString.toUpper).asSymbol;
        var pdef = Pdef.all[name];
        "% : %".format(name, if(pdef.isNil, "(absent)", pdef)).postln;
    };
};
)
