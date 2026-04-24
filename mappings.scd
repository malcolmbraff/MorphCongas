(

// Rotations → variables continues
~onKnobChange = { |num, val, chan|
    switch(num,
        0, { ~morph = val },
        4, { ~sendReverb1 = val },     // envoi voix1 → reverb
        5, { ~sendDelay1  = val },     // envoi voix1 → delay
        6, { ~sendReverb2 = val },     // envoi voix2 → reverb
        7, { ~sendDelay2  = val },     // envoi voix2 → delay
    );
};


// push
~pushActions = Array.fill(16, { { } });  // 16 actions vides par défaut

~pushActions[0] = { ~actions.nextWord.() };
~pushActions[1] = { ~actions.prevWord.() };
~pushActions[2] = { ~actions.startAll.() };
~pushActions[3] = { ~actions.stopAll.() };

~onButtonChange = { |num, state, chan|
    if(state == 1) { ~pushActions[num].() };
};

)


