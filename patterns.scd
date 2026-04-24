(

~rebuild = {
    Pdef(\voix1, Pbind(
        \instrument, \negSaw,
        \out, ~busses.master,
        \reverbSend, ~busses.reverb,
        \delaySend, ~busses.delay,
        \sendReverb, Pfunc({ ~sendReverb1 }),
        \sendDelay, Pfunc({ ~sendDelay1 }),
        \freq, Pseq([150], inf),
        \dur, Pneu(morph: Pfunc({ ~morph }), sub: true, word: ~word),
        \envDur, Pkey(\dur) * 0.9,
        \sustain, inf,
    )).quant_(2);

    Pdef(\voix2, Pbind(
        \instrument, \negSaw,
        \out, ~busses.master,
        \reverbSend, ~busses.reverb,
        \delaySend, ~busses.delay,
        \sendReverb, Pfunc({ ~sendReverb2 }),
        \sendDelay, Pfunc({ ~sendDelay2 }),
        \freq, Pseq([100], inf),
        \dur, Pneu(morph: Pfunc({ ~morph }), sub: false, word: ~word),
        \envDur, Pkey(\dur) * 0.9,
        \sustain, inf,
    )).quant_(2);
};
~rebuild.();
)



