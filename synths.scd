
// –––––––––––––––––––––––––––––bufPlay––––––––––––––––––––––––––––––
(

d = Dictionary.new;

d.add(\clacks->
	PathName("/Users/malcolmbraff/Documents/GitHub/MorphCongas/sounds/Congas/B").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);



SynthDef(\bufplay, { |out=0, reverbSend=0, sendReverb=0,
                      buf=0, rate=1, amp=1|
    var sig, stereoSig;
    sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction: 2);
    stereoSig = sig * amp;
    Out.ar(out, stereoSig);                          // sec → master
    Out.ar(reverbSend, stereoSig * sendReverb);       // envoi → reverb
}).add;
)

// –––––––––––––––––––––––––––––fm––––––––––––––––––––––––––––––
(
SynthDef(\fm, { |out=0, carHz=500, modHz=100, modAmp=200, atk=0.01, rel=1, amp=0.2|
    var car, mod, env;
    env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);
    mod = SinOsc.ar(modHz, mul: modAmp);
    car = SinOsc.ar(carHz + mod) * env * amp;
    Out.ar(out, car ! 2);
}).add;

)



// –––––––––––––––––––––––––––––bird––––––––––––––––––––––––––––––
(
SynthDef(\bird, { |out=0,
    // Source 1
    freq=2000, freqEnd=2000, freqCurve=0,
    // Source 2 (syrinx)
    freq2=2000, freq2End=2000, freq2Curve=0,
    syrinxBalance=0,
    // Richesse harmonique de la source (0 = quasi-sinus, 1 = saw)
    sourceWidth=0.5,
    // Modulation
    vibRate=0, vibDepth=0,
    flutterRate=0, flutterDepth=0,
    jitter=0.005,
    // Tract vocal : 3 formants
    f1=2500, f2=4500, f3=7000,        // fréquences des formants au repos
    f1End=2500, f2End=4500, f3End=7000,  // mouvement des formants pendant le chirp
    f1Q=12, f2Q=10, f3Q=8,            // sélectivité (plus haut = plus résonant)
    f1Amp=1.0, f2Amp=0.6, f3Amp=0.3,  // poids relatifs
    formantGlideFrac=0.6,             // les formants glissent un peu plus lentement que la freq
    // Drive / saturation post-source, pré-formant
    drive=2.0,
    // Noise / click
    noise=0, rq=0.05,
    clickAmp=0.2, clickDur=0.008,
    // Enveloppe
    atk=0.002, rel=0.06, curve=(-4),
    glideFrac=0.4,
    amp=0.3, pan=0|

    var ampEnv, glideEnv, formantEnv;
    var freq1, freq2sig, vib, flutter, jitterSig;
    var src1, src2, source, click, noisy, formants, sig;
    var f1now, f2now, f3now, totalDur, glideDur, formantDur;

    totalDur = atk + rel;
    glideDur = totalDur * glideFrac;
    formantDur = totalDur * formantGlideFrac;

    // Enveloppe d'amplitude
    ampEnv = EnvGen.kr(
        Env([0, 1, 0], [atk, rel], [\sine, curve]),
        doneAction: 2
    );

    // Glissando freq
    glideEnv = EnvGen.kr(Env([0, 1], [glideDur], freqCurve));
    formantEnv = EnvGen.kr(Env([0, 1], [formantDur], freqCurve));

    jitterSig = LFNoise2.kr(80) * jitter;
    vib = SinOsc.kr(vibRate) * vibDepth;

    freq1 = freq + ((freqEnd - freq) * glideEnv);
    freq1 = freq1 * (1 + jitterSig) + vib;

    freq2sig = freq2 + ((freq2End - freq2) * glideEnv);
    freq2sig = freq2sig * (1 + jitterSig) + vib;

    // Source 1 : VarSaw morphable sinus → saw via sourceWidth.
    // sourceWidth=0 → presque sinus ; sourceWidth=1 → saw riche.
    src1 = VarSaw.ar(freq1, 0, sourceWidth.linlin(0, 1, 0.5, 0.05));
    // Adoucir un peu : passer dans tanh pour éviter aliasing dur
    src1 = (src1 * (1 + sourceWidth * 2)).tanh;

    src2 = VarSaw.ar(freq2sig, 0, sourceWidth.linlin(0, 1, 0.5, 0.05));
    src2 = (src2 * (1 + sourceWidth * 2)).tanh;

    // Mix syrinx avant filtrage formantique (un seul tract vocal)
    source = XFade2.ar(src1, (src1 + src2) * 0.5, syrinxBalance * 2 - 1);

    // Drive (pousse les harmoniques avant les formants)
    source = (source * drive).tanh / drive.sqrt;

    // Formants mobiles : chaque formant glisse de fX à fXEnd
    f1now = f1 + ((f1End - f1) * formantEnv);
    f2now = f2 + ((f2End - f2) * formantEnv);
    f3now = f3 + ((f3End - f3) * formantEnv);

    // Tract vocal : 3 résonances en parallèle
    formants = (
        Resonz.ar(source, f1now, 1 / f1Q) * f1Amp +
        Resonz.ar(source, f2now, 1 / f2Q) * f2Amp +
        Resonz.ar(source, f3now, 1 / f3Q) * f3Amp
    );
    // Compense l'atténuation des Resonz (ils baissent fort)
    formants = formants * 6;

    // Flutter (AM rapide) post-formant
    flutter = SinOsc.kr(flutterRate).range(1 - flutterDepth, 1);
    formants = formants * flutter;

    // Click d'attaque (passe AUSSI par les formants, pour cohérence timbre)
    click = HPF.ar(WhiteNoise.ar, 1500)
        * EnvGen.kr(Env.perc(0.001, clickDur, curve: -8))
        * clickAmp;
    click = Resonz.ar(click, f2now, 1 / f2Q) * 4;

    // Composante bruit (pour rauque) : aussi formantée
    noisy = BPF.ar(WhiteNoise.ar, freq1, rq) * 4;
    noisy = Resonz.ar(noisy, f1now, 1 / f1Q) * 3 + noisy * 0.3;

    sig = XFade2.ar(formants, noisy, noise * 2 - 1);
    sig = sig + click;

    // Sécurité : limiter (les Resonz peuvent ringuer)
    sig = sig.softclip;

    sig = Pan2.ar(sig * ampEnv * amp, pan);
    Out.ar(out, sig);
}).add;
)