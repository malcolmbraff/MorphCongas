(
~actions = (
    // --- Navigation dans ~words ---
    // Ne déclenchent AUCUN swap : modifient seulement ~word / ~wordIndex.
    // Le nouveau mot prendra effet au prochain swapSlot.
    nextWord: {
        ~wordIndex = (~wordIndex + 1) % ~words.size;
        ~word = ~words[~wordIndex];
        ("word: " ++ ~word).postln;
    },

    prevWord: {
        ~wordIndex = (~wordIndex - 1).mod(~words.size);
        ~word = ~words[~wordIndex];
        ("word: " ++ ~word).postln;
    },

    resetMorph: {
        ~morph = 0.5;
        "morph reset".postln;
    },

    // --- Gestion des slots ---
    initSlots: {
        4.do { |i|
            var name = ("voix" ++ i ++ "A").asSymbol;
            ~makePdef.(i, \a, ~defaultFreq[i], ~word, ~defaultSub[i]);
            Pdef(name).play;
            ~slotActiveBus[i] = \a;
            ~slotSynths[i].set(\ampA, 1, \ampB, 0);
        };
        "slots initialised (all on bus A)".postln;
    },

    stopAllSlots: {
        4.do { |i|
            [\a, \b].do { |b|
                Pdef(("voix" ++ i ++ b.asString.toUpper).asSymbol).stop;
            };
        };
        "all slots stopped".postln;
    },

    // swapSlot : prépare un nouveau Pdef sur le bus libre du slot,
    // le démarre sur la prochaine grille quant, puis exécute un
    // crossfade equal-power (sin/cos) sur fadeTime secondes à 30 Hz.
    // NB : éviter d'enchaîner deux swaps sur le même slot à moins
    // de fadeTime d'écart (la closure capture les noms de l'instant t).
    swapSlot: { |slot, freq, word, sub, fadeTime=4, quant=4|
        var active    = ~slotActiveBus[slot];
        var target    = if(active == \a, { \b }, { \a });
        var oldName   = ("voix" ++ slot ++ active.asString.toUpper).asSymbol;
        var newName   = ("voix" ++ slot ++ target.asString.toUpper).asSymbol;
        var newAmpKey = ("amp" ++ target.asString.toUpper).asSymbol;
        var oldAmpKey = ("amp" ++ active.asString.toUpper).asSymbol;

        ~makePdef.(slot, target, freq, word, sub);
        Pdef(newName).quant_(quant).play;

        TempoClock.default.schedAbs(
            TempoClock.default.nextTimeOnGrid(quant),
            {
                var slotSynth = ~slotSynths[slot];
                var steps = (fadeTime * 30).asInteger.max(1);
                Routine({
                    steps.do { |k|
                        var t    = (k + 1) / steps;
                        var aNew = (t * 0.5pi).sin;
                        var aOld = (t * 0.5pi).cos;
                        slotSynth.set(
                            newAmpKey, aNew,
                            oldAmpKey, aOld,
                        );
                        (1/30).wait;
                    };
                    Pdef(oldName).stop;
                    ~slotActiveBus[slot] = target;
                    "slot % swapped: % → %".format(slot, active, target).postln;
                }).play;
                nil  // ne pas reprogrammer
            }
        );
        "slot %: swap scheduled on next % beat(s), fade % s".format(
            slot, quant, fadeTime
        ).postln;
    },
);
)
