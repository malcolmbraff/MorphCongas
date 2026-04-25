(
~actions = (
    // --- Navigation dans ~words ---
    // Les Pbind lisent ~word via Pfunc → changement entendu à
    // l'événement suivant, sans relancer les voix.
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

    // --- Voix (Ndef) ---

    // play : règle fadeTime puis .play vers ~busses.master.
    // Le fade-in est fait par NodeProxy. La filter slot continue à
    // écrire vers reverb/delay.
    play: { |name, fadeIn=2|
        if(~voices[name].isNil) {
            "play: voix % inconnue".format(name).warn;
        } {
            Ndef(name).fadeTime = fadeIn;
            Ndef(name).play(out: ~busses.master.index);
            "play %: fade-in % s".format(name, fadeIn).postln;
        };
    },

    // stop : règle fadeTime puis .stop. Le fade-out est fait par NodeProxy.
    stop: { |name, fadeOut=2|
        if(~voices[name].isNil) {
            "stop: voix % inconnue".format(name).warn;
        } {
            Ndef(name).fadeTime = fadeOut;
            Ndef(name).stop;
            "stop %: fade-out % s".format(name, fadeOut).postln;
        };
    },

    toggle: { |name, fadeTime=2|
        if(~voices[name].notNil) {
            if(Ndef(name).isPlaying) {
                ~actions[\stop].(name, fadeTime);
            } {
                ~actions[\play].(name, fadeTime);
            };
        };
    },

    stopAll: { |fadeOut=2|
        ~voices.keysDo { |name|
            if(Ndef(name).isPlaying) {
                ~actions[\stop].(name, fadeOut);
            };
        };
    },

    setSendReverb: { |name, val|
        if(~voices[name].notNil) { Ndef(name).set(\sendReverb, val) };
    },

    setSendDelay: { |name, val|
        if(~voices[name].notNil) { Ndef(name).set(\sendDelay, val) };
    },
);
)
