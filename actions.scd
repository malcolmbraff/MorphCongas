(
~actions = (
    nextWord: {
        ~wordIndex = (~wordIndex + 1) % ~words.size;
        ~word = ~words[~wordIndex];
        ~rebuild.();
        ("word: " ++ ~word).postln;
    },

    prevWord: {
        ~wordIndex = (~wordIndex - 1) % ~words.size;
        ~word = ~words[~wordIndex];
        ~rebuild.();
        ("word: " ++ ~word).postln;
    },

    startAll: {
        Pdef(\voix1).play;
        Pdef(\voix2).play;
        "all started".postln;
    },

    stopAll: {
        Pdef(\voix1).stop;
        Pdef(\voix2).stop;
        "all stopped".postln;
    },

    resetMorph: {
        ~morph = 0.5;
        "morph reset".postln;
    },

);


)