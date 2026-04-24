(
SynthDef(\reverb, { |in=0, out=0, room=0.7, damp=0.5, amp=1.0|
    var sig, wet;
    sig = In.ar(in, 2);
    wet = FreeVerb2.ar(sig[0], sig[1], mix: 1.0, room: room, damp: damp);
    Out.ar(out, wet * amp);
}).add;

SynthDef(\delay, { |in=0, out=0, time=0.375, fb=0.6, amp=1.0|
    var sig, wet;
    sig = In.ar(in, 2);
    wet = CombL.ar(sig, 2.0, time, fb * 4);
    Out.ar(out, wet * amp);
}).add;

SynthDef(\master, { |in=0, out=0, amp=1.0|
    var sig = In.ar(in, 2);
    sig = Limiter.ar(sig, 0.95);
    Out.ar(out, sig * amp);
}).add;

// Slot de voix : mixe deux bus stéréo (A/B) avec des amp lissés,
// écrit le mix sur out (master) et envoie vers reverb/delay.
SynthDef(\voixSlot, { |inA=0, inB=0, ampA=1, ampB=0, out=0,
                      reverbSend=0, delaySend=0,
                      sendReverb=0, sendDelay=0|
    var sigA, sigB, aA, aB, mix;
    sigA = In.ar(inA, 2);
    sigB = In.ar(inB, 2);
    aA = Lag.kr(ampA, 0.05);
    aB = Lag.kr(ampB, 0.05);
    mix = (sigA * aA) + (sigB * aB);
    Out.ar(out, mix);
    Out.ar(reverbSend, mix * sendReverb);
    Out.ar(delaySend,  mix * sendDelay);
}).add;

"Effects loaded".postln;
)
