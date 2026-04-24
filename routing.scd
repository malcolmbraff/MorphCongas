(
// Libération idempotente des effets et des slots
[~reverbSynth, ~delaySynth, ~masterSynth].do { |syn|
    if(syn.notNil) { syn.free };
};
if(~slotSynths.notNil) {
    ~slotSynths.do { |syn| if(syn.notNil) { syn.free } };
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

    // 4 slots placés avant les effets dans la chaîne
    ~slotSynths = Array.fill(4, { |i|
        Synth.before(~reverbSynth, \voixSlot, [
            \inA, ~busses.voix[i].a,
            \inB, ~busses.voix[i].b,
            \out, ~busses.master,
            \reverbSend, ~busses.reverb,
            \delaySend,  ~busses.delay,
            \ampA, 1, \ampB, 0,
            \sendReverb, 0.3, \sendDelay, 0.0,
        ]);
    });
};

"Routing actif (4 slots + reverb/delay/master)".postln;
)
