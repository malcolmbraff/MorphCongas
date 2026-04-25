(
// Cleanup idempotent : libère les NodeProxy existants au rechargement.
if(~voices.notNil) {
    ~voices.keysDo { |name| Ndef(name).clear };
};
~voices = ();
~voiceByMidi = ();

// ~makeVoice : enregistre une voix sous forme d'Ndef.
//   - name      : symbole unique (clé Ndef)
//   - midiIdx   : index MIDI (push N → toggle ; knob N → sendReverb ;
//                 shift knob N → sendDelay)
//   - source    : Pbind (ou autre source NodeProxy) — NE PAS y mettre
//                 \out, c'est Ndef qui gère le routage.
//
// Slot 0 = source. Slot 1 = filter qui pousse les sends vers
// ~busses.reverb / ~busses.delay et laisse passer le signal vers
// la sortie principale (passée à .play).
~makeVoice = { |name, midiIdx, source|
    var prev = ~voices[name];
    if(prev.notNil) {
        Ndef(name).clear;
        if(prev.midi.notNil) { ~voiceByMidi[prev.midi] = nil };
    };

    Ndef(name, source);
    Ndef(name).fadeTime = 2;
    Ndef(name)[1] = \filter -> { |in|
        Out.ar(~busses.reverb.index, in * \sendReverb.kr(0.3));
        Out.ar(~busses.delay.index,  in * \sendDelay.kr(0.0));
        in
    };

    ~voices[name] = (midi: midiIdx);
    ~voiceByMidi[midiIdx] = name;
    "voice % registered (midi %)".format(name, midiIdx).postln;
};

// --- Voix par défaut (matière de départ — à remplacer / étendre) ---

// Conga-like \negSaw piloté par Pneu. sub=true.
~makeVoice.(\saw1, 1, Pbind(
    \instrument, \negSaw,
    \freq, 150,
    \dur, Pneu(morph: Pfunc({ ~morph }), sub: true, word: Pfunc({ ~word })),
    \envDur, Pkey(\dur) * 0.9,
    \sustain, inf,
));

// FM aléatoire piloté par Pneu. sub=false.
~makeVoice.(\fm1, 2, Pbind(
    \instrument, \fm,
    \carHz, Pexprand(20, 10000),
    \modHz, Pexprand(20, 10000),
    \modAmp, Pwhite(0, 10000),
    \amp, Pseq([0.5, 0.1, 0.2], inf),
    \atk, Pexprand(0.001, 0.05),
    \rel, Pexprand(0.05, 1.2),
    \dur, Pneu(morph: Pfunc({ ~morph }), sub: false, word: Pfunc({ ~word })),
));
)
