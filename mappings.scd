(
// Routing MIDI dynamique : la résolution num → voix se fait au runtime
// via ~voiceByMidi (rempli par ~makeVoice). Aucune voix codée en dur.
//
// Conventions :
//   knob   0   → ~morph (global)
//   knob   N   → sendReverb de la voix attachée à midi N    (N ∈ 1..15)
//   shiftK N   → sendDelay  de la voix attachée à midi N    (N ∈ 0..15)
//   push   0   → stopAll (toutes les voix actives en fade-out)
//   push   N   → toggle play/stop de la voix midi N         (N ∈ 1..15, sauf 12/13)
//   push   12  → prevWord
//   push   13  → nextWord

~onKnobChange = { |num, val, chan|
    var name;
    if(num == 0) {
        ~morph = val;
    } {
        name = ~voiceByMidi[num];
        if(name.notNil) { ~actions[\setSendReverb].(name, val) };
    };
};

~onKnobShiftChange = { |num, val, chan|
    var name = ~voiceByMidi[num];
    if(name.notNil) { ~actions[\setSendDelay].(name, val) };
};

~onButtonChange = { |num, state, chan|
    var name;
    if(state == 1) {
        case
        { num == 0 }  { ~actions[\stopAll].() }
        { num == 12 } { ~actions[\prevWord].() }
        { num == 13 } { ~actions[\nextWord].() }
        { true } {
            name = ~voiceByMidi[num];
            if(name.notNil) { ~actions[\toggle].(name) };
        };
    };
};

~onSideButtonChange = { |num, state, chan|
    if(state == 1 and: { num == 0 }) { ~actions[\resetMorph].() };
};
)
