(
// Libération idempotente : si on recharge ce fichier, on libère
// les anciens synths d'effets avant d'en créer de nouveaux.
[~reverbSynth, ~delaySynth, ~masterSynth].do { |syn|
    if(syn.notNil) { syn.free };
};

s.bind {
    // Master en queue : il s'exécute APRÈS tout le reste
    ~masterSynth = Synth(\master, [
        \in, ~busses.master,
        \out, 0,
        \amp, 1.0,
    ], target: s, addAction: \addToTail);

    // Reverb : lit ~busses.reverb, écrit sur ~busses.master, avant le master
    ~reverbSynth = Synth.before(~masterSynth, \reverb, [
        \in, ~busses.reverb,
        \out, ~busses.master,
        \room, 0.8,
        \damp, 0.4,
    ]);

    // Delay : lit ~busses.delay, écrit sur ~busses.master, avant le master
    ~delaySynth = Synth.before(~masterSynth, \delay, [
        \in, ~busses.delay,
        \out, ~busses.master,
        \time, 0.375,
        \fb, 0.6,
    ]);
};

// Les synths générés par Pdef(\rhythm) se placent en tête du root group,
// donc avant reverb/delay/master dans l'ordre d'exécution audio.
"Routing actif : master + reverb + delay".postln;
)