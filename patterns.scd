(
Pdef(\rhythm,
    Ppar([
        Pbind(
            \instrument, \bufplay,
            \out, ~busses.master,
            \reverbSend, ~busses.reverb,
            \buf, Pxrand(d[\clacks], inf),
            \dur, Pneu(morph: Pfunc({ ~morph }), sub: false, word: Pfunc({ ~word })),
            \rate, 0.5,
            \amp, Pfunc({ 0.5 * ~amp1 }),
            \sendReverb, Pfunc({ ~sendReverb }),
        ),
        Pbind(
            \instrument, \bufplay,
            \out, ~busses.master,
            \reverbSend, ~busses.reverb,
            \buf, Pxrand(d[\clacks], inf),
            \dur, Pneu(morph: Pfunc({ ~morph }), sub: true, word: Pfunc({ ~word })),
            \rate, 1.5,
            \amp, Pfunc({ 0.5 * ~amp2 }),
            \sendReverb, Pfunc({ ~sendReverb }),
        ),
    ])
).quant_(2);
)