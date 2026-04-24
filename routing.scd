(
// Libérer les anciens synths d'effets s'ils existent
[~reverbSynth, ~delaySynth, ~masterSynth].do { |syn| if(syn.notNil) { syn.free } };

s.bind {
    // Master en premier sur le serveur, mais en queue : il s'exécute APRÈS tout le reste
    ~masterSynth = Synth(\master, [
        \in, ~busses.master,
        \out, 0,
        \amp, 1.0,
    ], target: s, addAction: \addToTail);

    // Reverb : lit reverb bus, écrit sur master bus
    ~reverbSynth = Synth.before(~masterSynth, \reverb, [
        \in, ~busses.reverb,
        \out, ~busses.master,
        \room, 0.8,
        \damp, 0.4,
    ]);

    // Delay : lit delay bus, écrit sur master bus, AVANT le master
    ~delaySynth = Synth.before(~masterSynth, \delay, [
        \in, ~busses.delay,
        \out, ~busses.master,
        \time, 0.375,
        \fb, 0.6,
    ]);
};

"Routing actif".postln;
)

