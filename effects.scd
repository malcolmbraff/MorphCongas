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

"Effects loaded".postln;
)

