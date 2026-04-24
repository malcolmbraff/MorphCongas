(
// Nettoyage ciblé des 8 Pdef du projet — idempotence au rechargement.
// Appel sans second arg : renvoie le Pdef existant ou en crée un vide.
// .clear stoppe et vide le Pdef en sécurité.
4.do { |slot|
    [\a, \b].do { |bus|
        var name = ("voix" ++ slot ++ bus.asString.toUpper).asSymbol;
        Pdef(name).clear;
    };
};

// Factory : crée/remplace un Pdef nommé voix<slot><BUS> routé vers
// ~busses.voix[slot].<bus>. La source est \negSaw (sec, sans sends :
// les sends sont assurés par le slot synth \voixSlot en aval).
~makePdef = { |slot, bus, freq, word, sub|
    var name = ("voix" ++ slot ++ bus.asString.toUpper).asSymbol;
    Pdef(name, Pbind(
        \instrument, \negSaw,
        \out, ~busses.voix[slot].perform(bus),
        \freq, Pseq([freq], inf),
        \dur, Pneu(morph: Pfunc({ ~morph }), sub: sub, word: word),
        \envDur, Pkey(\dur) * 0.9,
        \sustain, inf,
    )).quant_(2);
};
)
