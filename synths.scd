
// –––––––––––––––––––––––––––––negSaw––––––––––––––––––––––––––––––

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

// –––––––––––––––––––––––––––––fm––––––––––––––––––––––––––––––

(
SynthDef(\fm,{
	|carHz=500,modHz=100,modAmp=200,atk=0.01,rel=1,amp=0.2|
	var car, mod,env;
	env=EnvGen.kr(Env.perc(atk,rel),doneAction:2);
	mod=SinOsc.ar(modHz,mul:modAmp);
	car=SinOsc.ar(carHz+mod)*env*amp!2;

    stereoSig = car ! 2;
    Out.ar(out, stereoSig);
}).add;

)


// –––––––––––––––––––––––––––––SynthName––––––––––––––––––––––––––––––