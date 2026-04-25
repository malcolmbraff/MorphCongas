(
// Libération idempotente des effets. Les Ndef de voix gèrent leur
// propre cycle de vie ; on stoppe juste celles qui tournaient pour
// éviter d'avoir des nodes pointant vers d'anciens bus de FX.
[~reverbSynth, ~delaySynth, ~masterSynth].do { |syn|
    if(syn.notNil) { syn.free };
};
if(~voices.notNil) {
    ~voices.keysDo { |name|
        if(Ndef(name).isPlaying) { Ndef(name).stop(0) };
    };
};

s.bind {
    // Master en queue : il s'exécute APRÈS tout le reste
    ~masterSynth = Synth(\master, [
        \in, ~busses.master,
        \out, 0,
        \amp, 1.0,
    ], target: s, addAction: \addToTail);

    // Reverb : lit reverb bus, écrit sur master bus, avant le master
    ~reverbSynth = Synth.before(~masterSynth, \reverb, [
        \in, ~busses.reverb,
        \out, ~busses.master,
        \room, 0.8,
        \damp, 0.4,
    ]);

    // Delay : lit delay bus, écrit sur master bus, avant le master
    ~delaySynth = Synth.before(~masterSynth, \delay, [
        \in, ~busses.delay,
        \out, ~busses.master,
        \time, 0.375,
        \fb, 0.6,
    ]);
};

// Les Ndef se placent en tête de root group (par défaut), donc avant
// reverb/delay/master dans l'ordre d'exécution.
"Routing actif (master/reverb/delay) — voix gérées par Ndef".postln;
)
