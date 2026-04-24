(
// Rotations → variables continues et paramètres de slots
// knob  0     → ~morph
// knobs 4-7   → sendReverb par slot (0..3)
// knobs 8-11  → sendDelay  par slot (0..3)
~onKnobChange = { |num, val, chan|
    case
    { num == 0 } { ~morph = val }
    { (num >= 4) and: { num <= 7 } } {
        var slot = num - 4;
        ~slotSendReverb[slot] = val;
        ~slotSynths[slot].set(\sendReverb, val);
    }
    { (num >= 8) and: { num <= 11 } } {
        var slot = num - 8;
        ~slotSendDelay[slot] = val;
        ~slotSynths[slot].set(\sendDelay, val);
    };
};


// Pushes
// 0    → initSlots
// 1    → stopAllSlots
// 4-7  → swapSlot sur les slots 0..3 (defaults ~defaultFreq, ~word, ~defaultSub)
// 12   → prevWord
// 13   → nextWord
~pushActions = Array.fill(16, { { } });

~pushActions[0] = { ~actions.initSlots.() };
~pushActions[1] = { ~actions.stopAllSlots.() };

4.do { |i|
    ~pushActions[4 + i] = {
        ~actions.swapSlot.(
            i,
            ~defaultFreq[i],
            ~word,
            ~defaultSub[i],
            4,   // fadeTime (s)
            4    // quant (beats)
        );
    };
};

~pushActions[12] = { ~actions.prevWord.() };
~pushActions[13] = { ~actions.nextWord.() };

~onButtonChange = { |num, state, chan|
    if(state == 1) { ~pushActions[num].() };
};
)
