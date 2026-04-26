(
~actions = (

    // --- Navigation dans ~words ---
    // Les Pbind lisent ~word via Pfunc (Pneu modifié) → changement
    // entendu au prochain cycle Pneu, sans relancer les voix.
    nextWord: {
        ~wordIndex = (~wordIndex + 1) % ~words.size;
        ~word = ~words[~wordIndex];
        if(~uiNextImage.notNil) { ~uiNextImage.() };
        ("word [" ++ ~wordIndex ++ "]: " ++ ~word).postln;
    },

    prevWord: {
        ~wordIndex = (~wordIndex - 1).mod(~words.size);
        ~word = ~words[~wordIndex];
        if(~uiPrevImage.notNil) { ~uiPrevImage.() };
        ("word [" ++ ~wordIndex ++ "]: " ++ ~word).postln;
    },

    // --- Reset des paramètres ---
    resetMorph: {
        ~morph = 0.5;
        "morph reset".postln;
    },

    resetWord: {
        ~wordIndex = 0;
        ~word = ~words[0];
        if(~uiSetImage.notNil) { ~uiSetImage.(0) };
        "word reset".postln;
    },

    // --- Lecture / arrêt ---
    togglePlay: {
        if(Pdef(\rhythm).isPlaying) {
            ~actions.stopRoutines.();
            Pdef(\rhythm).stop;
            "rhythm stopped".postln;
        } {
            ~actions.stopRoutines.();
            Pdef(\rhythm).play;
            "rhythm started (manual)".postln;
        };
    },

    toggleAuto: {
        if(Pdef(\rhythm).isPlaying) {
            ~actions.stopRoutines.();
            Pdef(\rhythm).stop;
            "auto stopped".postln;
        } {
            ~actions.resetMorph.();
            ~actions.resetWord.();
            Pdef(\rhythm).play;

            ~wordCyclerRoutine = Routine({
                loop {
                    ~wordIndex = (~wordIndex + 1) % ~words.size;
                    ~word = ~words[~wordIndex];
                    if(~uiNextImage.notNil) { ~uiNextImage.() };
                    ("[wordCycler] word[%]: %".format(~wordIndex, ~word)).postln;
                    16.wait;
                };
            }).play(TempoClock.default, quant: 4);

            ~morphRoutine = Routine({
                var seq = Pseq(((0..16) ++ (15..1)) / 16, inf).asStream;
                loop {
                    ~morph = seq.next;
                    1.wait;
                };
            }).play(TempoClock.default, quant: 1);

            "auto started".postln;
        };
    },

    // --- Helper ---
    stopRoutines: {
        if(~wordCyclerRoutine.notNil) { ~wordCyclerRoutine.stop };
        if(~morphRoutine.notNil) { ~morphRoutine.stop };
    },
);
)