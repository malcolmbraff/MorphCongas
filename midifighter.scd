(
MIDIClient.init;
MIDIIn.connectAll;
MIDIdef.freeAll;

// États
~knobs       = Array.fill(64, { 0.5 });
~knobsShift  = Array.fill(16, { 0.5 });
~buttons     = Array.fill(64, { 0 });
~sideButtons = Array.fill(6,  { 0 });

// Hooks — vides par défaut, redéfinis dans un bloc séparé
~onKnobChange       = { |num, val, chan| };
~onKnobShiftChange  = { |num, val, chan| };
~onButtonChange     = { |num, state, chan| };
~onSideButtonChange = { |num, state, chan| };

// Rotations (CC, channel 0)
MIDIdef.cc(\twisterRot, { |val, num, chan|
    ~knobs[num] = val / 127.0;
    "rot  ch% num% val% → %\n".postf(chan, num, val, ~knobs[num].round(0.001));
    ~onKnobChange.(num, ~knobs[num], chan);
}, ccNum: (0..63), chan: 0);

// Shift rotations (CC, channel 4)
MIDIdef.cc(\twisterRotShift, { |val, num, chan|
    ~knobsShift[num] = val / 127.0;
    "rotS ch% num% val% → %\n".postf(chan, num, val, ~knobsShift[num].round(0.001));
    ~onKnobShiftChange.(num, ~knobsShift[num], chan);
}, ccNum: (0..15), chan: 4);

// Push encoders (Note On/Off, channel 1)
MIDIdef.noteOn(\twisterPushOn, { |vel, num, chan|
    ~buttons[num] = 1;
    "push ON  ch% num%\n".postf(chan, num);
    ~onButtonChange.(num, 1, chan);
}, chan: 1);

MIDIdef.noteOff(\twisterPushOff, { |vel, num, chan|
    ~buttons[num] = 0;
    "push OFF ch% num%\n".postf(chan, num);
    ~onButtonChange.(num, 0, chan);
}, chan: 1);

// Side buttons (Note On/Off, channel 3)
MIDIdef.noteOn(\twisterSideOn, { |vel, num, chan|
    ~sideButtons[num - 8] = 1;
    "side ON  ch% num%\n".postf(chan, num);
    ~onSideButtonChange.(num - 8, 1, chan);
}, chan: 3);

MIDIdef.noteOff(\twisterSideOff, { |vel, num, chan|
    ~sideButtons[num - 8] = 0;
    "side OFF ch% num%\n".postf(chan, num);
    ~onSideButtonChange.(num - 8, 0, chan);
}, chan: 3);

"MIDI Twister init OK".postln;

)