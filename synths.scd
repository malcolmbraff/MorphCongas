(
SynthDef(\negSaw, { |out=0, freq=440, amp=0.3, envDur=1, attack=0.03|
    var env, sig, stereoSig;
    env = EnvGen.kr(
        Env([0, 1, 0], [attack, envDur], \lin),
        doneAction: 2
    );
    sig = Saw.ar(freq) * env * amp;
    stereoSig = sig ! 2;
    Out.ar(out, stereoSig);
}).add;
)
