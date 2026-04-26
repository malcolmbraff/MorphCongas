(
~pushActions = Array.fill(16, { { } });

~pushActions[0] = { ~actions.togglePlay.() };
~pushActions[1] = { ~actions.toggleAuto.() };
~pushActions[2] = { ~actions.prevWord.() };
~pushActions[3] = { ~actions.nextWord.() };


~onButtonChange = { |num, state, chan|
    if(state == 1) { ~pushActions[num].() };
};

~onKnobChange = { |num, val, chan|
    switch(num,
        0, {
            ~morph = val;
        },
        1, {
            // Mix V-inverse : milieu = les deux à 1, côtés = une seule voix
            // val 0   → amp1=1, amp2=0
            // val 0.5 → amp1=1, amp2=1
            // val 1   → amp1=0, amp2=1
            ~amp1 = (1 - val).linlin(0, 0.5, 0, 1).clip(0, 1);
            ~amp2 = val.linlin(0, 0.5, 0, 1).clip(0, 1);
        },
        2, {
            ~sendReverb = val;
        },
        3, {
            ~reverbAmp = val;
            if(~reverbSynth.notNil) { ~reverbSynth.set(\amp, val) };
        },
    );
};
)
