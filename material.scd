(
~words = [
    [2, 1, 1, 2, 2, 1, 2],
    [1, 2, 1, 1, 2, 1, 2, 1],
    [1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 1, 2, 1, 1, 2, 1, 1],
    [2, 1, 2, 2, 1, 2, 2, 1, 2],
    [1, 2, 1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 1, 2, 1, 2, 1, 1, 2, 1]
];
~wordIndex = 0;
~word = ~words[0];
~morph = 0.0;

// État par slot
~slotActiveBus  = [\a, \a, \a, \a];
~slotSendReverb = [0.3, 0.3, 0.3, 0.3];
~slotSendDelay  = [0.0, 0.0, 0.0, 0.0];

// Défauts utilisés par initSlots et les swap depuis les pushes
~defaultFreq = [150, 100, 200, 75];
~defaultSub  = [true, false, true, false];
)
